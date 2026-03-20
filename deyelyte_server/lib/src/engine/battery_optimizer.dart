import 'dart:math';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'usage_predictor.dart';

// The three commands the EMS can issue to the inverter.
// Everything else (PV priority, self-use, load balancing) is handled by the
// inverter's own logic — the EMS only intervenes for grid charging and selling.
enum EmsCommand {
  chargeFromGrid, // Force charge from grid up to targetSocPercent
  dischargeToGrid, // Sell to grid
  neutral, // Hands-off — inverter manages itself
}

class BatteryOptimizer {
  final Session session;
  final int userInfoId;

  BatteryOptimizer(this.session, {required this.userInfoId});

  Future<List<OptimizationFrame>> calculateSchedule() async {
    final now = DateTime.now().toUtc();
    final generatedAt = now;

    // 1. Load user config
    final config = await AppConfig.db.findFirstRow(session,
        where: (t) => t.userInfoId.equals(userInfoId));

    if (config == null) {
      session.log('AppConfig not found for user $userInfoId, aborting.',
          level: LogLevel.warning);
      return [];
    }

    // 2. Fetch current SoC from the most recent inverter reading
    final latestReading = await InverterData.db.findFirstRow(session,
        where: (t) => t.userInfoId.equals(userInfoId),
        orderBy: (t) => t.timestamp,
        orderDescending: true);

    final currentSoc = latestReading?.batteryLevel ?? 50.0;

    // 3. Fetch next 24h prices and PV forecast
    // Use inclusive lower bound truncated to the current hour so we don't miss it
    final hourStart = DateTime.utc(now.year, now.month, now.day, now.hour);
    final horizon = hourStart.add(const Duration(hours: 24));

    final upcomingPrices = await EnergyPrice.db.find(session,
        where: (t) =>
            t.userInfoId.equals(userInfoId) &
            (t.timestamp >= hourStart) &
            (t.timestamp < horizon),
        orderBy: (t) => t.timestamp);

    final upcomingForecasts = await PvForecast.db.find(session,
        where: (t) =>
            t.userInfoId.equals(userInfoId) &
            (t.timestamp >= hourStart) &
            (t.timestamp < horizon));

    // Key forecasts by truncated hour datetime — avoids merging same clock-hour
    // across different calendar days
    final pvByHour = <DateTime, double>{};
    for (var f in upcomingForecasts) {
      final key = DateTime.utc(f.timestamp.year, f.timestamp.month,
          f.timestamp.day, f.timestamp.hour);
      pvByHour.update(key, (v) => v + f.expectedYieldWatts,
          ifAbsent: () => f.expectedYieldWatts);
    }

    // 4. Fetch 30 days of history for the usage predictor
    final past30Days = now.subtract(const Duration(days: 30));
    final historicalData = await InverterData.db.find(session,
        where: (t) =>
            t.userInfoId.equals(userInfoId) & (t.timestamp > past30Days));

    // 5. Battery economics
    final batteryCapKwh = config.batteryCapacityKwh ?? 10.0;
    final minSoc = config.minSocPercentage ?? 15.0;
    final batteryCost = config.batteryCost ?? 0.0;
    final lifecycles = config.batteryLifecycles ?? 6000;
    final maxDischargeRateKw = config.maxDischargeRateKw ?? 5.0;

    // Wear cost per kWh discharged: batteryCost / (cycles × capacityKwh)
    final wearCostPerKwh = (lifecycles > 0 && batteryCapKwh > 0)
        ? batteryCost / (lifecycles * batteryCapKwh)
        : 0.0;

    final minSellThreshold = config.minSellPriceThreshold; // null = no floor
    final chargeThreshold = config.alwaysChargePriceThreshold; // max buy price to trigger charge

    // 6. Build per-hour candidate data
    final candidates = <_HourCandidate>[];
    for (var price in upcomingPrices) {
      final hourKey = DateTime.utc(price.timestamp.year, price.timestamp.month,
          price.timestamp.day, price.timestamp.hour);
      final grossLoadW = await UsagePredictor.predictUsageForHour(
          session, price.timestamp, historicalData);
      final pvW = pvByHour[hourKey] ?? 0.0;
      // Net load: demand that PV cannot cover, must come from battery or grid
      final netLoadW = max(0.0, grossLoadW - pvW);

      candidates.add(_HourCandidate(
        price: price,
        grossLoadW: grossLoadW,
        pvW: pvW,
        netLoadW: netLoadW,
      ));
    }

    // 6b. Fetch outage-reserve dates that fall within the 24h window
    final outageReserves = await OutageReserve.db.find(session,
        where: (t) =>
            t.userInfoId.equals(userInfoId) &
            (t.date >= hourStart) &
            (t.date < horizon));

    // Collect the calendar dates (day precision) flagged as outage days
    final outageDates = outageReserves
        .map((r) => DateTime.utc(r.date.year, r.date.month, r.date.day))
        .toSet();

    // 6c. Pre-outage smart charging
    // If an outage day falls within the 24h window, cheaply pre-charge to 100%
    // before it arrives, factoring in expected PV.
    final preOutageChargeHours = <DateTime>{};
    if (outageDates.isNotEmpty) {
      final earliestOutage =
          outageDates.reduce((a, b) => a.isBefore(b) ? a : b);

      // Simulate the natural SoC trajectory (no commands) up to the outage to
      // find how much additional grid charge is actually needed
      double projectedSoc = currentSoc;
      for (var c in candidates) {
        final hd = DateTime.utc(c.price.timestamp.year,
            c.price.timestamp.month, c.price.timestamp.day);
        if (hd.isBefore(earliestOutage)) {
          projectedSoc = (projectedSoc +
                  c.pvW / 1000.0 / batteryCapKwh * 100.0 -
                  c.netLoadW / 1000.0 / batteryCapKwh * 100.0)
              .clamp(minSoc, 100.0);
        }
      }

      final chargeNeededKwh =
          max(0.0, (100.0 - projectedSoc) / 100.0 * batteryCapKwh);

      if (chargeNeededKwh > 0) {
        // Pick cheapest pre-outage hours to cover the deficit
        final preOutageCandidates = candidates
            .where((c) {
              final hd = DateTime.utc(c.price.timestamp.year,
                  c.price.timestamp.month, c.price.timestamp.day);
              return hd.isBefore(earliestOutage);
            })
            .toList()
          ..sort((a, b) => a.price.buyPrice.compareTo(b.price.buyPrice));

        double remaining = chargeNeededKwh;
        for (var c in preOutageCandidates) {
          if (remaining <= 0) break;
          preOutageChargeHours.add(c.price.timestamp);
          remaining -= maxDischargeRateKw;
        }
      }
    }

    // 7. Greedy discharge selection
    // Discharge budget: if pvOnlySelling, limit to expected PV yield (only sell
    // what the sun generates, not grid-charged energy). Otherwise allow full
    // usable capacity.
    final totalPvKwh =
        pvByHour.values.fold(0.0, (sum, w) => sum + w) / 1000.0; // W→kWh

    final usableCapacityKwh = batteryCapKwh * (1.0 - minSoc / 100.0);
    double dischargeBudgetKwh =
        config.pvOnlySelling ? totalPvKwh : usableCapacityKwh;

    // Find cheapest future recharge price for each hour (for arbitrage spread)
    // When heavy PV is expected to recharge for free, recharge cost is 0
    for (var c in candidates) {
      double cheapestBuyAhead = double.maxFinite;
      for (var other in candidates) {
        if (other.price.timestamp.isAfter(c.price.timestamp) &&
            other.price.buyPrice < cheapestBuyAhead) {
          cheapestBuyAhead = other.price.buyPrice;
        }
      }
      // If PV can fully recharge the battery from what we'd discharge, recharge
      // is effectively free — use 0 as the future buy price
      final pvRechargesForFree = totalPvKwh >= maxDischargeRateKw;
      c.cheapestRechargePrice = pvRechargesForFree
          ? 0.0
          : (cheapestBuyAhead == double.maxFinite
              ? c.price.buyPrice
              : cheapestBuyAhead);
    }

    // Sort by sell price descending for greedy allocation
    final dischargeRanked = List<_HourCandidate>.from(candidates)
      ..sort((a, b) => b.price.sellPrice.compareTo(a.price.sellPrice));

    final dischargeHours = <DateTime>{};
    for (var c in dischargeRanked) {
      if (dischargeBudgetKwh <= 0) break;
      if (!config.sellingEnabled) break;

      // Never discharge on outage-reserve days — keep battery full
      final hourDate = DateTime.utc(c.price.timestamp.year,
          c.price.timestamp.month, c.price.timestamp.day);
      if (outageDates.contains(hourDate)) continue;

      final sellPrice = c.price.sellPrice;
      final spread = sellPrice - c.cheapestRechargePrice;
      final meetsMinSell =
          minSellThreshold == null || sellPrice >= minSellThreshold;

      if (meetsMinSell && spread > wearCostPerKwh) {
        dischargeHours.add(c.price.timestamp);
        dischargeBudgetKwh -= maxDischargeRateKw;
      }
    }

    // 8. PV-headroom-aware charge target
    // Look 6 hours ahead from each charge candidate; if heavy PV is coming,
    // leave room so the battery can absorb it without clipping
    double chargeTarget(DateTime hourTime) {
      if (config.topUpRequested) return 100.0;
      double pvNext6hKwh = 0.0;
      for (var c in candidates) {
        final diff = c.price.timestamp.difference(hourTime);
        if (diff.inHours >= 0 && diff.inHours < 6) {
          pvNext6hKwh += c.pvW / 1000.0; // W to kWh per hour slot
        }
      }
      final headroom = (pvNext6hKwh / batteryCapKwh) * 100.0;
      return min(100.0, 100.0 - headroom + minSoc).clamp(minSoc, 100.0);
    }

    // 9. Hour-by-hour SoC simulation + build final schedule
    double estimatedSoc = currentSoc;
    final List<OptimizationFrame> schedule = [];

    for (var c in candidates) {
      final price = c.price;
      EmsCommand command = EmsCommand.neutral;
      String reason = 'Normal auto operation.';
      double? targetSoc;

      final hourDate = DateTime.utc(
          price.timestamp.year, price.timestamp.month, price.timestamp.day);
      final isOutageDay = outageDates.contains(hourDate);

      // Rule -1a: Pre-outage cheap charging — fill battery at cheapest hours
      // before the outage day arrives (PV production already factored in)
      if (preOutageChargeHours.contains(price.timestamp)) {
        command = EmsCommand.chargeFromGrid;
        targetSoc = 100.0;
        reason =
            'Pre-outage charge at ${price.buyPrice.toStringAsFixed(4)} — cheapest slot before reserve day.';
      }
      // Rule -1b: Outage day — block selling; top up at any price if SoC low
      else if (isOutageDay) {
        if (estimatedSoc < 95.0) {
          command = EmsCommand.chargeFromGrid;
          targetSoc = 100.0;
          reason =
              'Outage reserve day — SoC ${estimatedSoc.toStringAsFixed(0)}% < 95%, charging to 100%.';
        } else {
          // Battery is full (PV or pre-charging did the job) — stay neutral
          reason = 'Outage reserve day — battery full, holding energy.';
        }
      }
      // Rule 0: Top-up override — charge to 100% regardless of price
      else if (config.topUpRequested && config.chargingEnabled) {
        command = EmsCommand.chargeFromGrid;
        targetSoc = 100.0;
        reason = 'Manual top-up requested — charging to 100%.';
      }
      // Rule A: Cheap/free grid charge
      else if (config.chargingEnabled &&
          price.buyPrice <= chargeThreshold &&
          estimatedSoc < chargeTarget(price.timestamp) &&
          !dischargeHours.contains(price.timestamp)) {
        command = EmsCommand.chargeFromGrid;
        targetSoc = chargeTarget(price.timestamp);
        reason =
            'Buy price (${price.buyPrice.toStringAsFixed(4)}) ≤ threshold ($chargeThreshold). Charging to ${targetSoc.toStringAsFixed(0)}% SoC.';
      }
      // Rule B: Greedy discharge to grid
      else if (dischargeHours.contains(price.timestamp)) {
        final socAfterDischarge =
            estimatedSoc - (maxDischargeRateKw / batteryCapKwh) * 100.0;
        if (socAfterDischarge >= minSoc) {
          command = EmsCommand.dischargeToGrid;
          reason =
              'Sell at ${price.sellPrice.toStringAsFixed(4)}, spread=${( price.sellPrice - c.cheapestRechargePrice).toStringAsFixed(4)}, wear=${wearCostPerKwh.toStringAsFixed(4)}/kWh.';
        }
        // Not enough SoC left — fall through to neutral
      }

      final netLoadKwh = c.netLoadW / 1000.0;
      final pvChargeKwh = (c.pvW / 1000.0).clamp(0.0, batteryCapKwh);

      // Advance SoC estimate for next hour
      switch (command) {
        case EmsCommand.chargeFromGrid:
          estimatedSoc = min(targetSoc!, estimatedSoc + (maxDischargeRateKw / batteryCapKwh) * 100.0);
        case EmsCommand.dischargeToGrid:
          estimatedSoc = max(minSoc, estimatedSoc - (maxDischargeRateKw / batteryCapKwh) * 100.0);
        case EmsCommand.neutral:
          // In neutral the inverter uses PV first, then battery for net load
          estimatedSoc = (estimatedSoc + pvChargeKwh / batteryCapKwh * 100.0 -
                  netLoadKwh / batteryCapKwh * 100.0)
              .clamp(minSoc, 100.0);
      }

      schedule.add(OptimizationFrame(
        userInfoId: userInfoId,
        generatedAt: generatedAt,
        hour: price.timestamp,
        command: command.name,
        targetSocPercent: targetSoc,
        reason: reason,
        estimatedSocAtStart: estimatedSoc,
        expectedNetLoadW: c.netLoadW,
        expectedPvW: c.pvW,
      ));
    }

    return schedule;
  }
}

class _HourCandidate {
  final EnergyPrice price;
  final double grossLoadW;
  final double pvW;
  final double netLoadW;
  double cheapestRechargePrice = 0.0;

  _HourCandidate({
    required this.price,
    required this.grossLoadW,
    required this.pvW,
    required this.netLoadW,
  });
}
