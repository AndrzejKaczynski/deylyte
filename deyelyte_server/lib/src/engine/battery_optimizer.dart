import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'usage_predictor.dart';

enum InverterCommandMode {
  charge,    // Force charge from grid
  discharge, // Force discharge/sell to grid
  selfUse,   // Use battery to cover load, avoid grid import
  auto       // Let inverter decide based on load and PV
}

class OptimizationScheduleFrame {
  final DateTime startTime;
  final DateTime endTime;
  final InverterCommandMode mode;
  final String reason;
  final double expectedLoadW;
  final double expectedPvW;

  OptimizationScheduleFrame({
    required this.startTime,
    required this.endTime,
    required this.mode,
    required this.reason,
    this.expectedLoadW = 0,
    this.expectedPvW = 0,
  });
}

class BatteryOptimizer {
  final Session session;
  final int userInfoId;

  BatteryOptimizer(this.session, {required this.userInfoId});

  Future<List<OptimizationScheduleFrame>> calculateSchedule() async {
    // 1. Fetch user-scoped Config
    final config = await AppConfig.db.findFirstRow(session,
      where: (t) => t.userInfoId.equals(userInfoId),
    );

    if (config == null) {
      session.log('AppConfig not found for user $userInfoId, aborting.', level: LogLevel.warning);
      return [];
    }

    if (!config.workModeEnabled) {
      session.log('Work mode disabled for user $userInfoId, skipping.');
      return [];
    }

    if (config.dataGatheringSince == null) {
      session.log('dataGatheringSince is null for user $userInfoId, skipping.');
      return [];
    }

    final daysSinceStart = DateTime.now().difference(config.dataGatheringSince!).inDays;
    final isTrainingMode = daysSinceStart < 7;

    if (isTrainingMode) {
      session.log('Training Mode ($daysSinceStart days). Charging on free energy; discharge blocked.');
    }

    // 2. Fetch user-scoped data for the next 24 hours
    final now = DateTime.now().toUtc();
    final tomorrow = now.add(const Duration(hours: 24));

    final upcomingPrices = await EnergyPrice.db.find(session,
      where: (t) => t.userInfoId.equals(userInfoId) & (t.timestamp > now) & (t.timestamp < tomorrow),
      orderBy: (t) => t.timestamp,
    );

    final upcomingForecasts = await PvForecast.db.find(session,
      where: (t) => t.userInfoId.equals(userInfoId) & (t.timestamp > now) & (t.timestamp < tomorrow),
    );

    // Build PV forecast lookup (hour -> total expected Watts)
    final pvByHour = <int, double>{};
    for (var f in upcomingForecasts) {
      pvByHour.update(f.timestamp.hour, (v) => v + f.expectedYieldWatts, ifAbsent: () => f.expectedYieldWatts);
    }

    // 3. Fetch last 30 days of user-scoped history for the Usage Predictor
    final past30Days = now.subtract(const Duration(days: 30));
    final historicalData = await InverterData.db.find(session,
      where: (t) => t.userInfoId.equals(userInfoId) & (t.timestamp > past30Days),
    );

    // 4. Compute rolling 7-day price percentile (P85) for discharge threshold
    final past7Days = now.subtract(const Duration(days: 7));
    final recentPrices = await EnergyPrice.db.find(session,
      where: (t) => t.userInfoId.equals(userInfoId) & (t.timestamp > past7Days),
    );

    double peakThreshold;
    if (recentPrices.length >= 24) {
      final sortedHistorical = recentPrices.map((p) => p.buyPrice).toList()..sort();
      final p85Index = (sortedHistorical.length * 0.85).floor().clamp(0, sortedHistorical.length - 1);
      peakThreshold = sortedHistorical[p85Index];
    } else {
      // Fallback: use 80% of today's max
      double maxPrice = -double.maxFinite;
      for (var p in upcomingPrices) {
        if (p.buyPrice > maxPrice) maxPrice = p.buyPrice;
      }
      peakThreshold = maxPrice * 0.8;
    }

    // 5. Battery economics
    final chargeThreshold = config.alwaysChargePriceThreshold;
    final minSellThreshold = config.minSellPriceThreshold ?? 0.0;
    final minSoc = config.minSocPercentage ?? 15.0;
    final batteryCapKwh = config.batteryCapacityKwh ?? 10.0;
    final batteryCost = config.batteryCost ?? 0.0;
    final lifecycles = config.batteryLifecycles ?? 6000;

    // Wear-and-tear cost per kWh discharged
    // Formula: batteryCost / (lifecycles * batteryCapKwh)
    final wearCostPerKwh = (lifecycles > 0 && batteryCapKwh > 0)
        ? batteryCost / (lifecycles * batteryCapKwh)
        : 0.0;

    // Usable capacity in kWh (above the SoC floor)
    final usableCapacityKwh = batteryCapKwh * (1.0 - minSoc / 100.0);

    // 6. Greedy Spread: rank hours by sell profitability
    // Build candidate list for each hour
    final hourCandidates = <_HourCandidate>[];
    for (var price in upcomingPrices) {
      final expectedLoad = await UsagePredictor.predictUsageForHour(session, price.timestamp, historicalData);
      final expectedPv = pvByHour[price.timestamp.hour] ?? 0.0;

      // Find cheapest upcoming charge price (for arbitrage spread)
      double cheapestBuyAhead = double.maxFinite;
      for (var p in upcomingPrices) {
        if (p.timestamp.isAfter(price.timestamp) && p.buyPrice < cheapestBuyAhead) {
          cheapestBuyAhead = p.buyPrice;
        }
      }

      hourCandidates.add(_HourCandidate(
        price: price,
        expectedLoadW: expectedLoad,
        expectedPvW: expectedPv,
        cheapestRechargePrice: cheapestBuyAhead == double.maxFinite ? price.buyPrice : cheapestBuyAhead,
      ));
    }

    // Sort candidates by sell price descending for greedy allocation
    final dischargeRanked = List<_HourCandidate>.from(hourCandidates)
      ..sort((a, b) => b.price.sellPrice.compareTo(a.price.sellPrice));

    double remainingDischargeKwh = usableCapacityKwh;
    final dischargeHours = <DateTime>{};

    for (var candidate in dischargeRanked) {
      if (remainingDischargeKwh <= 0) break;

      final sellPrice = candidate.price.sellPrice;
      final arbitrageSpread = sellPrice - candidate.cheapestRechargePrice;

      // Arbitrage check: only discharge if spread > wear cost
      if (sellPrice >= minSellThreshold && arbitrageSpread > wearCostPerKwh) {
        dischargeHours.add(candidate.price.timestamp);
        remainingDischargeKwh -= 1.0; // ~1kWh per hour discharge rate
      }
    }

    // 7. PV-Aware Capacity Reservation
    // If heavy PV is expected, allow more aggressive discharge to make room
    double totalUpcomingPvKwh = 0;
    for (var f in upcomingForecasts) {
      totalUpcomingPvKwh += f.expectedYieldWatts * 0.5 / 1000.0; // 30-min periods to kWh
    }

    // If solar alone can fill the battery, we can afford to discharge deeper
    if (totalUpcomingPvKwh >= batteryCapKwh * 0.5) {
      remainingDischargeKwh += totalUpcomingPvKwh * 0.3; // Allow 30% of incoming PV as extra discharge headroom
    }

    // 8. Build final schedule
    List<OptimizationScheduleFrame> schedule = [];

    for (var candidate in hourCandidates) {
      InverterCommandMode mode = InverterCommandMode.auto;
      String reason = "Normal auto operation";

      final price = candidate.price;
      final expectedPv = candidate.expectedPvW;

      // Rule A: Charge when prices are at or below threshold
      if (price.buyPrice <= chargeThreshold) {
        mode = InverterCommandMode.charge;
        reason = "Price (${price.buyPrice}) ≤ threshold ($chargeThreshold). Charging.";
      }
      // Rule B: Greedy discharge during the best-ranked sell hours
      else if (dischargeHours.contains(price.timestamp)) {
        if (isTrainingMode) {
          mode = InverterCommandMode.auto;
          reason = "Training Mode: discharge blocked until 7 days of data gathered.";
        } else {
          mode = InverterCommandMode.discharge;
          reason = "Greedy Spread: sell@${price.sellPrice}, wear=${wearCostPerKwh.toStringAsFixed(3)}/kWh.";
        }
      }
      // Rule C: Grid Import Avoidance — use battery instead of buying expensive grid
      else if (price.buyPrice >= peakThreshold && expectedPv < candidate.expectedLoadW) {
        if (!isTrainingMode) {
          mode = InverterCommandMode.selfUse;
          reason = "Grid avoidance: buy@${price.buyPrice} is expensive. Using battery for load.";
        }
      }

      schedule.add(OptimizationScheduleFrame(
        startTime: price.timestamp,
        endTime: price.timestamp.add(const Duration(hours: 1)),
        mode: mode,
        reason: reason,
        expectedLoadW: candidate.expectedLoadW,
        expectedPvW: expectedPv,
      ));
    }

    return schedule;
  }
}

class _HourCandidate {
  final EnergyPrice price;
  final double expectedLoadW;
  final double expectedPvW;
  final double cheapestRechargePrice;

  _HourCandidate({
    required this.price,
    required this.expectedLoadW,
    required this.expectedPvW,
    required this.cheapestRechargePrice,
  });
}
