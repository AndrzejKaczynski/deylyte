import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Serves all history data for the Flutter history screen.
/// Each method returns a bundled response — one call per view.
class HistoryEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // ── Tier enforcement ──────────────────────────────────────────────────────

  /// Earliest UTC date the user may browse.
  /// Pro: back to dataGatheringSince (effectively unlimited).
  /// Basic / beta_free: 1st of the previous calendar month.
  Future<DateTime> _earliestAllowedDate(Session session, int uid) async {
    final results = await Future.wait([
      LicenseKey.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(uid) & t.isActive.equals(true),
      ),
      AppConfig.db.findFirstRow(
        session,
        where: (t) => t.userInfoId.equals(uid),
      ),
    ]);
    final license = results[0] as LicenseKey?;
    final config = results[1] as AppConfig?;
    final dataStart = config?.dataGatheringSince;

    if (license?.tier == 'pro') {
      return dataStart ?? DateTime.utc(2020);
    }

    // basic / beta_free: current + previous month
    final now = DateTime.now().toUtc();
    final limit = DateTime.utc(now.year, now.month - 1, 1);
    if (dataStart != null && dataStart.isAfter(limit)) return dataStart;
    return limit;
  }

  int _uid(Session session) =>
      int.parse(session.authenticated!.userIdentifier);

  // ── Bundled single-day data ───────────────────────────────────────────────

  /// Returns telemetry + prices + frames for a single UTC day.
  Future<HistoryDayData> getDayData(Session session, DateTime date) async {
    final uid = _uid(session);
    final earliest = await _earliestAllowedDate(session, uid);

    final dayStart = DateTime.utc(date.year, date.month, date.day);
    if (dayStart.isBefore(earliest)) {
      return HistoryDayData(
          date: dayStart, telemetry: [], prices: [], frames: []);
    }

    final dayEnd = dayStart.add(const Duration(days: 1));
    final results = await Future.wait([
      DeviceTelemetry.db.find(
        session,
        where: (t) =>
            t.userId.equals(uid) &
            (t.timestamp >= dayStart) &
            (t.timestamp < dayEnd),
        orderBy: (t) => t.timestamp,
      ),
      EnergyPrice.db.find(
        session,
        where: (t) =>
            t.userInfoId.equals(uid) &
            (t.timestamp >= dayStart) &
            (t.timestamp < dayEnd),
        orderBy: (t) => t.timestamp,
      ),
      OptimizationFrame.db.find(
        session,
        where: (t) =>
            t.userInfoId.equals(uid) &
            (t.generatedAt >= dayStart) &
            (t.generatedAt < dayEnd),
        orderBy: (t) => t.hour,
      ),
    ]);

    return HistoryDayData(
      date: dayStart,
      telemetry: results[0] as List<DeviceTelemetry>,
      prices: results[1] as List<EnergyPrice>,
      frames: results[2] as List<OptimizationFrame>,
    );
  }

  // ── Bundled period data ───────────────────────────────────────────────────

  /// Returns daily aggregates + avg prices + frames for [from]..[to] (inclusive).
  Future<HistoryPeriodData> getPeriodData(
    Session session,
    DateTime from,
    DateTime to,
  ) async {
    final uid = _uid(session);
    final earliest = await _earliestAllowedDate(session, uid);

    var rangeStart = DateTime.utc(from.year, from.month, from.day);
    final rangeEnd =
        DateTime.utc(to.year, to.month, to.day).add(const Duration(days: 1));

    if (rangeStart.isBefore(earliest)) rangeStart = earliest;
    if (!rangeStart.isBefore(rangeEnd)) {
      return HistoryPeriodData(
        fromDate: rangeStart,
        toDate: DateTime.utc(to.year, to.month, to.day),
        aggregates: [],
        dailyAvgPrices: [],
        frames: [],
      );
    }

    final results = await Future.wait([
      // Daily telemetry aggregates
      session.db.unsafeQuery(
        """
        SELECT
          DATE_TRUNC('day', "timestamp") AS day,
          AVG("pvPowerW")       AS avg_pv,
          AVG("loadPowerW")     AS avg_load,
          AVG("gridPowerW")     AS avg_grid,
          AVG("batteryPowerW")  AS avg_battery,
          AVG("batterySOC")     AS avg_soc,
          COUNT(*)              AS sample_count
        FROM "device_telemetry"
        WHERE "userId" = @userId
          AND "timestamp" >= @from
          AND "timestamp" < @to
        GROUP BY DATE_TRUNC('day', "timestamp")
        ORDER BY day
        """,
        parameters: QueryParameters.named({
          'userId': uid,
          'from': rangeStart,
          'to': rangeEnd,
        }),
      ),
      // Daily average prices
      session.db.unsafeQuery(
        """
        SELECT
          DATE_TRUNC('day', "timestamp") AS day,
          AVG("buyPrice")  AS avg_buy,
          AVG("sellPrice") AS avg_sell
        FROM "energy_price"
        WHERE "userInfoId" = @userId
          AND "timestamp" >= @from
          AND "timestamp" < @to
        GROUP BY DATE_TRUNC('day', "timestamp")
        ORDER BY day
        """,
        parameters: QueryParameters.named({
          'userId': uid,
          'from': rangeStart,
          'to': rangeEnd,
        }),
      ),
      // Raw frames for the period
      OptimizationFrame.db.find(
        session,
        where: (t) =>
            t.userInfoId.equals(uid) &
            (t.generatedAt >= rangeStart) &
            (t.generatedAt < rangeEnd),
        orderBy: (t) => t.generatedAt,
      ),
    ]);

    final telemetryRows = results[0] as List;
    final priceRows = results[1] as List;
    final frames = results[2] as List<OptimizationFrame>;

    final aggregates = telemetryRows.map((row) {
      final m = row.toColumnMap();
      return DailyEnergyAggregate(
        date: (m['day'] as DateTime).toUtc(),
        avgPvPowerW: (m['avg_pv'] as num).toDouble(),
        avgLoadPowerW: (m['avg_load'] as num).toDouble(),
        avgGridPowerW: (m['avg_grid'] as num).toDouble(),
        avgBatteryPowerW: (m['avg_battery'] as num).toDouble(),
        avgBatterySOC: (m['avg_soc'] as num).toDouble(),
        sampleCount: (m['sample_count'] as num).toInt(),
      );
    }).toList();

    final dailyAvgPrices = priceRows.map((row) {
      final m = row.toColumnMap();
      return DailyAvgPrice(
        date: (m['day'] as DateTime).toUtc(),
        avgBuyPrice: (m['avg_buy'] as num?)?.toDouble() ?? 0.0,
        avgSellPrice: (m['avg_sell'] as num?)?.toDouble() ?? 0.0,
      );
    }).toList();

    return HistoryPeriodData(
      fromDate: rangeStart,
      toDate: DateTime.utc(to.year, to.month, to.day),
      aggregates: aggregates,
      dailyAvgPrices: dailyAvgPrices,
      frames: frames,
    );
  }

  // ── Summary ───────────────────────────────────────────────────────────────

  /// Aggregate summary metrics for [from]..[to] (inclusive UTC dates).
  Future<String> getSummary(
    Session session,
    DateTime from,
    DateTime to,
  ) async {
    final uid = _uid(session);
    final earliest = await _earliestAllowedDate(session, uid);

    var rangeStart = DateTime.utc(from.year, from.month, from.day);
    final rangeEnd =
        DateTime.utc(to.year, to.month, to.day).add(const Duration(days: 1));
    if (rangeStart.isBefore(earliest)) rangeStart = earliest;

    if (!rangeStart.isBefore(rangeEnd)) {
      return jsonEncode(_zeroSummary);
    }

    final results = await Future.wait([
      session.db.unsafeQuery(
        """
        SELECT
          AVG("pvPowerW")   AS avg_pv,
          AVG("loadPowerW") AS avg_load,
          MAX("loadPowerW") AS peak_load,
          AVG("gridPowerW") AS avg_grid
        FROM "device_telemetry"
        WHERE "userId" = @userId
          AND "timestamp" >= @from AND "timestamp" < @to
        """,
        parameters: QueryParameters.named(
            {'userId': uid, 'from': rangeStart, 'to': rangeEnd}),
      ),
      session.db.unsafeQuery(
        """
        SELECT
          AVG("buyPrice")  AS avg_buy,
          AVG("sellPrice") AS avg_sell
        FROM "energy_price"
        WHERE "userInfoId" = @userId
          AND "timestamp" >= @from AND "timestamp" < @to
        """,
        parameters: QueryParameters.named(
            {'userId': uid, 'from': rangeStart, 'to': rangeEnd}),
      ),
    ]);

    final tRow = (results[0] as List).firstOrNull?.toColumnMap();
    final pRow = (results[1] as List).firstOrNull?.toColumnMap();

    final avgPvW = (tRow?['avg_pv'] as num?)?.toDouble() ?? 0.0;
    final avgLoadW = (tRow?['avg_load'] as num?)?.toDouble() ?? 0.0;
    final peakLoadW = (tRow?['peak_load'] as num?)?.toDouble() ?? 0.0;
    final avgGridW = (tRow?['avg_grid'] as num?)?.toDouble() ?? 0.0;
    final avgBuy = (pRow?['avg_buy'] as num?)?.toDouble() ?? 0.0;
    final avgSell = (pRow?['avg_sell'] as num?)?.toDouble() ?? 0.0;

    // Green mix: share of load covered by PV (rough — ignores battery path)
    final loadKw = avgLoadW / 1000;
    final pvKw = avgPvW / 1000;
    final greenMix =
        loadKw > 0 ? (pvKw / loadKw * 100).clamp(0.0, 100.0) : 0.0;

    // Net revenue estimate from average grid flow × average prices
    final gridKw = avgGridW / 1000;
    final exportKw = gridKw < 0 ? -gridKw : 0.0;
    final importKw = gridKw > 0 ? gridKw : 0.0;
    final netRevenue = exportKw * avgSell - importKw * avgBuy;
    final totalSavings = (loadKw - importKw) * avgBuy;

    return jsonEncode({
      'avgBuyPrice': _r4(avgBuy),
      'avgSellPrice': _r4(avgSell),
      'netRevenuePln': _r2(netRevenue),
      'peakLoadKw': _r2(peakLoadW / 1000),
      'greenMixPercent': _r1(greenMix),
      'totalSavingsPln': _r2(totalSavings),
      'storageEfficiencyPercent': 0.0,
      'peakDemandKw': _r2(peakLoadW / 1000),
    });
  }

  static const _zeroSummary = {
    'avgBuyPrice': 0.0,
    'avgSellPrice': 0.0,
    'netRevenuePln': 0.0,
    'peakLoadKw': 0.0,
    'greenMixPercent': 0.0,
    'totalSavingsPln': 0.0,
    'storageEfficiencyPercent': 0.0,
    'peakDemandKw': 0.0,
  };

  static double _r1(double v) => double.parse(v.toStringAsFixed(1));
  static double _r2(double v) => double.parse(v.toStringAsFixed(2));
  static double _r4(double v) => double.parse(v.toStringAsFixed(4));

}
