import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../integrations/solcast/solcast_client.dart';
import '../integrations/open_meteo/open_meteo_client.dart';
import '../engine/pv_estimator.dart';

class ForecastEndpoint extends Endpoint {
  /// Refreshes the PV forecast for the authenticated user.
  /// Uses Solcast if credentials are configured; falls back to the
  /// Open-Meteo estimator (requires cityName in AppConfig) if not.
  Future<void> updateForecast(Session session) async {
    final userInfoId = _requireUserInfoId(session);

    final creds = await IntegrationCredentials.db.findFirstRow(session,
        where: (t) => t.userInfoId.equals(userInfoId));

    if (creds?.solcastApiKey != null && creds?.solcastSiteId != null) {
      final client = SolcastClient(
        apiKey: creds!.solcastApiKey!,
        siteId: creds.solcastSiteId!,
        userInfoId: userInfoId,
      );
      await client.fetchAndStoreForecast(session);
      return;
    }

    // Fallback: Open-Meteo radiation + historical calibration
    final config = await AppConfig.db.findFirstRow(session,
        where: (t) => t.userInfoId.equals(userInfoId));

    if (config?.cityName == null) {
      session.log(
        'No Solcast credentials and no city configured — skipping PV forecast.',
        level: LogLevel.warning,
      );
      return;
    }

    // Resolve and cache coordinates on first run
    double? lat = config!.latitude;
    double? lon = config.longitude;
    if (lat == null || lon == null) {
      final coords =
          await OpenMeteoClient.geocodeCity(session, config.cityName!);
      if (coords == null) {
        session.log(
          'Geocoding failed for city "${config.cityName}" — skipping PV forecast.',
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
  }

  int _requireUserInfoId(Session session) {
    final authInfo = session.authenticated;
    if (authInfo == null) throw Exception('Not authenticated');
    return int.parse(authInfo.userIdentifier);
  }
}
