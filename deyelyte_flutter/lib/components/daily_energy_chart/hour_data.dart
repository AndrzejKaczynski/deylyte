import 'package:deyelyte_client/deyelyte_client.dart';

// ─── Per-hour data model ──────────────────────────────────────────────────────

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
  final double? gridKw; // grid power: positive = importing, negative = exporting
  final double? batteryKw; // battery power: positive = charging, negative = discharging
  final double? buyPrice; // PLN/kWh
  final double? sellPrice; // PLN/kWh
  final double? socPct; // 0-100
  final String? command; // 'charge' | 'discharge' | 'idle' | null

  /// Builds 24 [HourData] entries for today, blending live telemetry,
  /// PV forecast, energy prices, and optimizer frames.
  /// Past hours use actual telemetry; future hours use forecast + frame estimates.
  static List<HourData> buildHours(
    List<PvForecast> forecast,
    List<EnergyPrice> prices,
    List<OptimizationFrame> frames,
    List<DeviceTelemetry> telemetry,
  ) {
    final now = DateTime.now().toLocal();
    final nowHour = now.hour;

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

    final forecastPvSum = List<double>.filled(24, 0);
    final forecastPvCount = List<int>.filled(24, 0);
    for (final r in forecast) {
      final t = r.timestamp.toLocal();
      if (t.year == now.year && t.month == now.month && t.day == now.day) {
        forecastPvSum[t.hour] += r.expectedYieldWatts;
        forecastPvCount[t.hour]++;
      }
    }

    final priceByHour = <int, EnergyPrice>{};
    for (final p in prices) {
      priceByHour[p.timestamp.toLocal().hour] = p;
    }

    final frameByHour = <int, OptimizationFrame>{};
    for (final f in frames) {
      frameByHour[f.hour.toLocal().hour] = f;
    }

    return List.generate(24, (h) {
      final isActual = h < nowHour;

      final double pvKw;
      if (isActual && pvCount[h] > 0) {
        pvKw = (pvSum[h] / pvCount[h] / 1000.0).clamp(0.0, double.infinity);
      } else if (!isActual && forecastPvCount[h] > 0) {
        pvKw = forecastPvSum[h] / forecastPvCount[h] / 1000.0;
      } else {
        pvKw = 0.0;
      }

      final double? pvActualKw = (h == nowHour && pvCount[h] > 0)
          ? (pvSum[h] / pvCount[h] / 1000.0).clamp(0.0, double.infinity)
          : null;

      final bool hasActual = h <= nowHour && pvCount[h] > 0;
      final double? loadKw =
          (hasActual && loadCount[h] > 0) ? loadSum[h] / loadCount[h] / 1000.0 : null;
      final double? gridKw =
          (hasActual && gridCount[h] > 0) ? gridSum[h] / gridCount[h] / 1000.0 : null;
      final double? batteryKw =
          (hasActual && batteryCount[h] > 0) ? batterySum[h] / batteryCount[h] / 1000.0 : null;

      final price = priceByHour[h];
      final frame = frameByHour[h];

      final double? socPct;
      if (hasActual && socCount[h] > 0) {
        socPct = socSum[h] / socCount[h];
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

  /// Builds one [HourData] per day for the inclusive range [from]..[to],
  /// aggregating telemetry to daily averages (kW) and prices to daily averages.
  /// [hour] field = column index (0 = [from], last = [to]).
  static List<HourData> buildForDateRange(
    DateTime from,
    DateTime to,
    List<EnergyPrice> prices,
    List<OptimizationFrame> frames,
    List<DeviceTelemetry> telemetry,
  ) {
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day);
    final days = toDate.difference(fromDate).inDays + 1;

    return List.generate(days, (i) {
      final date = fromDate.add(Duration(days: i));

      final dayTelemetry = telemetry.where((t) {
        final lt = t.timestamp.toLocal();
        return lt.year == date.year && lt.month == date.month && lt.day == date.day;
      }).toList();

      final count = dayTelemetry.length;
      final pvAvg = count == 0
          ? 0.0
          : (dayTelemetry.fold(0.0, (s, t) => s + t.pvPowerW) / count / 1000.0)
              .clamp(0.0, double.infinity);
      final loadAvg = count == 0
          ? null
          : dayTelemetry.fold(0.0, (s, t) => s + t.loadPowerW) / count / 1000.0;
      final gridAvg = count == 0
          ? null
          : dayTelemetry.fold(0.0, (s, t) => s + t.gridPowerW) / count / 1000.0;
      final battAvg = count == 0
          ? null
          : dayTelemetry.fold(0.0, (s, t) => s + t.batteryPowerW) / count / 1000.0;
      final socAvg = count == 0
          ? null
          : dayTelemetry.fold(0.0, (s, t) => s + t.batterySOC) / count;

      final dayPrices = prices.where((p) {
        final lt = p.timestamp.toLocal();
        return lt.year == date.year && lt.month == date.month && lt.day == date.day;
      }).toList();
      final pCount = dayPrices.length;
      final buyAvg = pCount == 0
          ? null
          : dayPrices.fold(0.0, (s, p) => s + p.buyPrice) / pCount;
      final sellAvg = pCount == 0
          ? null
          : dayPrices.fold(0.0, (s, p) => s + p.sellPrice) / pCount;

      final dayFrames = frames.where((f) {
        final lt = f.hour.toLocal();
        return lt.year == date.year && lt.month == date.month && lt.day == date.day;
      }).toList();
      final cmdCounts = <String, int>{};
      for (final f in dayFrames) {
        cmdCounts[f.command] = (cmdCounts[f.command] ?? 0) + 1;
      }
      final dominantCmd = cmdCounts.isEmpty
          ? null
          : cmdCounts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

      return HourData(
        hour: i,
        pvKw: pvAvg,
        pvIsActual: true,
        loadKw: loadAvg,
        gridKw: gridAvg,
        batteryKw: battAvg,
        socPct: socAvg,
        buyPrice: buyAvg,
        sellPrice: sellAvg,
        command: dominantCmd,
      );
    });
  }

  /// Builds one [HourData] per day for the inclusive range [from]..[to],
  /// using pre-aggregated [DailyEnergyAggregate] rows from the server.
  /// Falls back to zero values for days missing from [aggregates].
  /// Prices and frames are still resolved client-side (they're small).
  static List<HourData> buildFromAggregates(
    DateTime from,
    DateTime to,
    List<DailyEnergyAggregate> aggregates,
    List<EnergyPrice> prices,
    List<OptimizationFrame> frames,
  ) {
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day);
    final days = toDate.difference(fromDate).inDays + 1;

    // Index aggregates by UTC date (year/month/day).
    final aggByDate = <String, DailyEnergyAggregate>{};
    for (final a in aggregates) {
      final d = a.date.toLocal();
      aggByDate['${d.year}-${d.month}-${d.day}'] = a;
    }

    return List.generate(days, (i) {
      final date = fromDate.add(Duration(days: i));
      final key = '${date.year}-${date.month}-${date.day}';
      final agg = aggByDate[key];

      final dayPrices = prices.where((p) {
        final lt = p.timestamp.toLocal();
        return lt.year == date.year && lt.month == date.month && lt.day == date.day;
      }).toList();
      final pCount = dayPrices.length;
      final buyAvg = pCount == 0 ? null : dayPrices.fold(0.0, (s, p) => s + p.buyPrice) / pCount;
      final sellAvg =
          pCount == 0 ? null : dayPrices.fold(0.0, (s, p) => s + p.sellPrice) / pCount;

      final dayFrames = frames.where((f) {
        final lt = f.hour.toLocal();
        return lt.year == date.year && lt.month == date.month && lt.day == date.day;
      }).toList();
      final cmdCounts = <String, int>{};
      for (final f in dayFrames) {
        cmdCounts[f.command] = (cmdCounts[f.command] ?? 0) + 1;
      }
      final dominantCmd = cmdCounts.isEmpty
          ? null
          : cmdCounts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

      return HourData(
        hour: i,
        pvKw: agg != null ? (agg.avgPvPowerW / 1000.0).clamp(0.0, double.infinity) : 0.0,
        pvIsActual: true,
        loadKw: agg != null ? agg.avgLoadPowerW / 1000.0 : null,
        gridKw: agg != null ? agg.avgGridPowerW / 1000.0 : null,
        batteryKw: agg != null ? agg.avgBatteryPowerW / 1000.0 : null,
        socPct: agg?.avgBatterySOC,
        buyPrice: buyAvg,
        sellPrice: sellAvg,
        command: dominantCmd,
      );
    });
  }

  /// Returns 7 evenly-spaced axis labels (e.g. "18 Mar") for a date range.
  static List<String> buildPeriodAxisLabels(DateTime from, DateTime to) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day);
    final days = toDate.difference(fromDate).inDays;
    return List.generate(7, (i) {
      final offset = (i * days / 6).round();
      final d = fromDate.add(Duration(days: offset));
      return '${d.day} ${months[d.month - 1]}';
    });
  }

  /// Builds 24 [HourData] entries for a specific past [date].
  /// All hours use actual telemetry only — no forecast, no estimates.
  static List<HourData> buildForDate(
    DateTime date,
    List<EnergyPrice> prices,
    List<OptimizationFrame> frames,
    List<DeviceTelemetry> telemetry,
  ) {
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
      if (lt.year == date.year && lt.month == date.month && lt.day == date.day) {
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

    final priceByHour = <int, EnergyPrice>{};
    for (final p in prices) {
      priceByHour[p.timestamp.toLocal().hour] = p;
    }

    final frameByHour = <int, OptimizationFrame>{};
    for (final f in frames) {
      frameByHour[f.hour.toLocal().hour] = f;
    }

    return List.generate(24, (h) {
      final hasTelemetry = pvCount[h] > 0;
      return HourData(
        hour: h,
        pvKw: hasTelemetry ? (pvSum[h] / pvCount[h] / 1000.0).clamp(0.0, double.infinity) : 0.0,
        pvIsActual: true,
        loadKw: (hasTelemetry && loadCount[h] > 0) ? loadSum[h] / loadCount[h] / 1000.0 : null,
        gridKw: (hasTelemetry && gridCount[h] > 0) ? gridSum[h] / gridCount[h] / 1000.0 : null,
        batteryKw:
            (hasTelemetry && batteryCount[h] > 0) ? batterySum[h] / batteryCount[h] / 1000.0 : null,
        socPct: (hasTelemetry && socCount[h] > 0) ? socSum[h] / socCount[h] : null,
        buyPrice: priceByHour[h]?.buyPrice,
        sellPrice: priceByHour[h]?.sellPrice,
        command: frameByHour[h]?.command,
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
