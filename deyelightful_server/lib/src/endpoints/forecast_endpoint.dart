import 'package:serverpod/serverpod.dart';
import '../integrations/solcast/solcast_client.dart';

class ForecastEndpoint extends Endpoint {
  Future<void> updateForecast(Session session, String apiKey, String siteId, int userInfoId) async {
    final client = SolcastClient(apiKey: apiKey, siteId: siteId, userInfoId: userInfoId);
    await client.fetchAndStoreForecast(session);
  }
}
