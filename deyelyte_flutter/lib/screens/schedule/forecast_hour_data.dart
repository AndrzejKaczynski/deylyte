import 'package:deyelyte_client/deyelyte_client.dart';

// ─── Data model ───────────────────────────────────────────────────────────────

class HourData {
  const HourData({
    required this.hour,
    required this.pvKw,
    required this.pvIsActual,
    this.pvActualKw,
    this.loadKw,
    this.gridKw,
    this.batteryKw,
    this.buyPrice,
    this.sellPrice,
    this.socPct,
    this.command,
  });

  final int hour; // 0-23 local time
  final double pvKw; // actual measurement for past hours, forecast for future
  final bool pvIsActual; // true = measured telemetry, false = forecast
  final double? pvActualKw; // partial actual for current hour only
  final double? loadKw; // home consumption kW (actual only)
  final double? gridKw; // grid power: positive = importing, negative = exporting (actual only)
  final double? batteryKw; // battery power: positive = charging, negative = discharging (actual only)
  final double? buyPrice; // PLN/kWh
  final double? sellPrice; // PLN/kWh
  final double? socPct; // 0-100
  final String? command; // 'charge' | 'discharge' | 'idle' | null

  static List<HourData> buildHours(
    List<PvForecast> forecast,
    List<EnergyPrice> prices,
    List<OptimizationFrame> frames,
    List<DeviceTelemetry> telemetry,
  ) {
    final now = DateTime.now().toLocal();
    final nowHour = now.hour;

    // Telemetry aggregation: sum + count per local hour for today
    final pvSum = List<double>.filled(24, 0);
    final pvCount = List<int>.filled(24, 0);
    final loadSum = List<double>.filled(24, 0);
    final loadCount = List<int>.filled(24, 0);
    final gridSum = List<double>.filled(24, 0);
    final gridCount = List<int>.filled(24, 0);
    final batterySum = List<double>.filled(24, 0);
    final batteryCount = List<int>.filled(24, 0);
    final socSum = List<double>.filled(24, 0);
    final socCount = List<int>.filled(24, 0);

    for (final t in telemetry) {
      final lt = t.timestamp.toLocal();
      if (lt.year == now.year && lt.month == now.month && lt.day == now.day) {
        pvSum[lt.hour] += t.pvPowerW;
        pvCount[lt.hour]++;
        loadSum[lt.hour] += t.loadPowerW;
        loadCount[lt.hour]++;
        gridSum[lt.hour] += t.gridPowerW;
        gridCount[lt.hour]++;
        batterySum[lt.hour] += t.batteryPowerW;
        batteryCount[lt.hour]++;
        socSum[lt.hour] += t.batterySOC;
        socCount[lt.hour]++;
      }
    }

    // Forecast PV: average W per local hour for today
    final forecastPvSum = List<double>.filled(24, 0);
    final forecastPvCount = List<int>.filled(24, 0);
    for (final r in forecast) {
      final t = r.timestamp.toLocal();
      if (t.year == now.year && t.month == now.month && t.day == now.day) {
        forecastPvSum[t.hour] += r.expectedYieldWatts;
        forecastPvCount[t.hour]++;
      }
    }

    // Prices keyed by local hour
    final priceByHour = <int, EnergyPrice>{};
    for (final p in prices) {
      priceByHour[p.timestamp.toLocal().hour] = p;
    }

    // Schedule frames keyed by local hour
    final frameByHour = <int, OptimizationFrame>{};
    for (final f in frames) {
      frameByHour[f.hour.toLocal().hour] = f;
    }

    return List.generate(24, (h) {
      final isActual = h < nowHour;

      // PV kW: actual for past, forecast for current+future
      final double pvKw;
      if (isActual && pvCount[h] > 0) {
        pvKw = (pvSum[h] / pvCount[h] / 1000.0).clamp(0.0, double.infinity);
      } else if (!isActual && forecastPvCount[h] > 0) {
        pvKw = forecastPvSum[h] / forecastPvCount[h] / 1000.0;
      } else {
        pvKw = 0.0;
      }

      // Partial actual for current hour (both actual + forecast shown)
      final double? pvActualKw = (h == nowHour && pvCount[h] > 0)
          ? (pvSum[h] / pvCount[h] / 1000.0).clamp(0.0, double.infinity)
          : null;

      // Load, grid, battery, SoC: actual data only (past hours + current hour)
      final bool hasActual = h <= nowHour && pvCount[h] > 0;
      final double? loadKw =
          (hasActual && loadCount[h] > 0) ? loadSum[h] / loadCount[h] / 1000.0 : null;
      final double? gridKw =
          (hasActual && gridCount[h] > 0) ? gridSum[h] / gridCount[h] / 1000.0 : null;
      final double? batteryKw =
          (hasActual && batteryCount[h] > 0) ? batterySum[h] / batteryCount[h] / 1000.0 : null;

      final price = priceByHour[h];
      final frame = frameByHour[h];

      // SoC: actual telemetry for past/current hours, optimizer estimate for future
      final double? socPct;
      if (hasActual && socCount[h] > 0) {
        socPct = socSum[h] / socCount[h]; // batterySOC is already a percentage
      } else {
        socPct = frame?.estimatedSocAtStart;
      }

      return HourData(
        hour: h,
        pvKw: pvKw,
        pvIsActual: isActual,
        pvActualKw: pvActualKw,
        loadKw: loadKw,
        gridKw: gridKw,
        batteryKw: batteryKw,
        buyPrice: price?.buyPrice,
        sellPrice: price?.sellPrice,
        socPct: socPct,
        command: frame?.command,
      );
    });
  }
}

// ─── Layer visibility ─────────────────────────────────────────────────────────

class Layers {
  bool showPvIntake = true;
  bool showPvEstimate = true;
  bool showLoad = true;
  bool showSoc = true;
  bool showBuyPrice = true;
  bool showSellPrice = true;
  bool showPlan = true;
}
