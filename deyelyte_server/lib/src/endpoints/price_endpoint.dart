import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../integrations/pstryk/pstryk_client.dart';

class PriceEndpoint extends Endpoint {
  Future<void> updatePrices(Session session, String token, int userInfoId) async {
    final client = PstrykClient(token, userInfoId: userInfoId);
    await client.fetchAndStorePrices(session);
  }

  /// Returns today's energy prices (UTC day boundary) for the authenticated user.
  Future<List<EnergyPrice>> getTodayPrices(Session session) async {
    final auth = session.authenticated;
    if (auth == null) throw Exception('Not authenticated');
    final uid = int.parse(auth.userIdentifier);
    final now = DateTime.now().toUtc();
    final dayStart = DateTime.utc(now.year, now.month, now.day);
    final dayEnd = dayStart.add(const Duration(hours: 24));
    return EnergyPrice.db.find(
      session,
      where: (t) =>
          t.userInfoId.equals(uid) &
          t.timestamp.between(dayStart, dayEnd),
      orderBy: (t) => t.timestamp,
    );
  }
}
