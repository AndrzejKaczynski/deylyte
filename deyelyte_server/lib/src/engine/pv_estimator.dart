import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../integrations/open_meteo/open_meteo_client.dart';

class PvEstimator {
  static const int _lookbackDays = 14;

  // Night hours produce near-zero radiation — skip to avoid dividing by noise.
  static const double _minRadiationThreshold = 10.0; // W/m²

  // Minimum inverter readings per hour before we trust the factor.
  static const int _minSamplesRequired = 3;

  /// Estimates PV production for the next 24h using historical inverter data
  /// calibrated against Open-Meteo solar radiation, then writes the result
  /// into the pv_forecast table (same schema as Solcast).
  static Future<void> estimateAndStore(
    Session session,
    int userInfoId,
    double latitude,
    double longitude,
  ) async {
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final startDate = today.subtract(const Duration(days: _lookbackDays));

    // 1. Historical radiation for the lookback window
    final historicalRad = await OpenMeteoClient.fetchHistoricalHourlyRadiation(
      session, latitude, longitude, startDate, yesterday,
    );
    if (historicalRad.isEmpty) {
      session.log('PvEstimator: no historical radiation returned, aborting.');
      return;
    }

    // 2. Historical inverter data for the same window
    final inverterData = await InverterData.db.find(session,
        where: (t) =>
            t.userInfoId.equals(userInfoId) &
            (t.timestamp >= startDate) &
            (t.timestamp < today));

    // 3. Compute per-hour-of-day efficiency factors
    //    factor[h] = avg(pvPower[h]) / avg(radiation[h])
    //    Units: W / (W/m²) = m² — effective panel area as seen from horizontal
    final pvSumByHour = <int, double>{};
    final pvCountByHour = <int, int>{};
    for (final d in inverterData) {
      final h = d.timestamp.hour;
      pvSumByHour[h] = (pvSumByHour[h] ?? 0.0) + d.pvPower;
      pvCountByHour[h] = (pvCountByHour[h] ?? 0) + 1;
    }

    final radSumByHour = <int, double>{};
    final radCountByHour = <int, int>{};
    for (final entry in historicalRad.entries) {
      final h = entry.key.hour;
      radSumByHour[h] = (radSumByHour[h] ?? 0.0) + entry.value;
      radCountByHour[h] = (radCountByHour[h] ?? 0) + 1;
    }

    final factor = <int, double>{};
    for (var h = 0; h < 24; h++) {
      final radCount = radCountByHour[h] ?? 0;
      final avgRad = radCount > 0 ? radSumByHour[h]! / radCount : 0.0;

      if (avgRad < _minRadiationThreshold) {
        factor[h] = 0.0; // Night hour — no production
        continue;
      }

      final pvCount = pvCountByHour[h] ?? 0;
      if (pvCount < _minSamplesRequired) {
        factor[h] = 0.0; // Not enough history to calibrate
        continue;
      }

      factor[h] = pvSumByHour[h]! / pvCount / avgRad;
    }

    // 4. Forecast radiation for the next 24h
    final forecastRad = await OpenMeteoClient.fetchForecastHourlyRadiation(
      session, latitude, longitude,
    );
    if (forecastRad.isEmpty) {
      session.log('PvEstimator: no forecast radiation returned, aborting.');
      return;
    }

    // 5. Compute estimated watts and upsert into pv_forecast
    final hourStart = DateTime.utc(now.year, now.month, now.day, now.hour);
    final horizon = hourStart.add(const Duration(hours: 24));
    var rowCount = 0;

    for (final entry in forecastRad.entries) {
      final ts = entry.key;
      if (ts.isBefore(hourStart) || !ts.isBefore(horizon)) continue;

      final estimatedW = (factor[ts.hour] ?? 0.0) * entry.value;

      final existing = await PvForecast.db.findFirstRow(session,
          where: (t) =>
              t.timestamp.equals(ts) & t.userInfoId.equals(userInfoId));

      if (existing != null) {
        existing.expectedYieldWatts = estimatedW;
        await PvForecast.db.updateRow(session, existing);
      } else {
        await PvForecast.db.insertRow(
            session,
            PvForecast(
              userInfoId: userInfoId,
              timestamp: ts,
              expectedYieldWatts: estimatedW,
            ));
      }
      rowCount++;
    }

    session.log('PvEstimator: wrote $rowCount forecast rows for user $userInfoId.');
  }
}
