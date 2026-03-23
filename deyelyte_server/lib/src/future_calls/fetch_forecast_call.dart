import 'package:serverpod/serverpod.dart';
import '../generated/future_calls.dart';
import '../generated/protocol.dart';
import '../integrations/solcast/solcast_client.dart';
import '../integrations/open_meteo/open_meteo_client.dart';
import '../engine/pv_estimator.dart';

/// Refreshes PV forecasts for all users every 6 hours.
///
/// Users with Solcast credentials use the Solcast API.
/// Users without Solcast but with a city name fall back to the
/// Open-Meteo radiation estimator.
///
/// Self-rescheduling: reschedules itself at the end of each run.
class FetchForecastCall extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableModel? object) async {
    final allConfigs = await AppConfig.db.find(session);
    session.log(
        'FetchForecastCall: refreshing forecasts for ${allConfigs.length} user(s)');

    for (final config in allConfigs) {
      await _updateUser(session, config);
    }

    await session.serverpod.futureCalls
        .callWithDelay(const Duration(hours: 6))
        .fetchForecastCall
        .invoke(null);
  }

  Future<void> _updateUser(Session session, AppConfig config) async {
    final userInfoId = config.userInfoId;
    try {
      final creds = await IntegrationCredentials.db.findFirstRow(
        session,
        where: (t) => t.userInfoId.equals(userInfoId),
      );

      if (creds?.solcastApiKey != null && creds?.solcastSiteId != null) {
        final client = SolcastClient(
          apiKey: creds!.solcastApiKey!,
          siteId: creds.solcastSiteId!,
          userInfoId: userInfoId,
        );
        await client.fetchAndStoreForecast(session);
        return;
      }

      if (config.cityName == null) {
        session.log(
          'FetchForecastCall: no Solcast and no city for userInfoId $userInfoId — skipping',
          level: LogLevel.warning,
        );
        return;
      }

      double? lat = config.latitude;
      double? lon = config.longitude;
      if (lat == null || lon == null) {
        final coords =
            await OpenMeteoClient.geocodeCity(session, config.cityName!);
        if (coords == null) {
          session.log(
            'FetchForecastCall: geocoding failed for city "${config.cityName}" (userInfoId $userInfoId)',
            level: LogLevel.warning,
          );
          return;
        }
        lat = coords.lat;
        lon = coords.lon;
        await AppConfig.db.updateRow(
            session, config.copyWith(latitude: lat, longitude: lon));
      }

      await PvEstimator.estimateAndStore(session, userInfoId, lat, lon);
    } catch (e) {
      session.log(
        'FetchForecastCall: failed for userInfoId $userInfoId: $e',
        level: LogLevel.error,
      );
    }
  }
}
