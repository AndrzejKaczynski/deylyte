import 'package:serverpod/serverpod.dart';
import '../integrations/pstryk/pstryk_client.dart';

class PriceEndpoint extends Endpoint {
  Future<void> updatePrices(Session session, String token, int userInfoId) async {
    final client = PstrykClient(token, userInfoId: userInfoId);
    await client.fetchAndStorePrices(session);
  }
}
