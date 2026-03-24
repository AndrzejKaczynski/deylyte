import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../integrations/pstryk/pstryk_client.dart';

class PriceEndpoint extends Endpoint {
  Future<void> updatePrices(Session session, String token, int userInfoId) async {
    final client = PstrykClient(token, userInfoId: userInfoId);
    await client.fetchAndStorePrices(session);
  }

  /// Fetches prices immediately using the authenticated user's stored Pstryk token.
  /// Used after saving credentials to verify they are valid and populate initial data.
  Future<void> triggerFetch(Session session) async {
    final auth = session.authenticated;
    if (auth == null) throw Exception('Not authenticated');
    final uid = int.parse(auth.userIdentifier);

    final creds = await IntegrationCredentials.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(uid),
    );
    final token = creds?.pstrykToken;
    if (token == null) throw Exception('No Pstryk token configured');

    final client = PstrykClient(token, userInfoId: uid);
    await client.fetchAndStorePrices(session);
  }

  /// Returns energy prices for the last [days] days (for the history screen).
  Future<List<EnergyPrice>> getPricesForPeriod(Session session, int days) async {
    final auth = session.authenticated;
    if (auth == null) throw Exception('Not authenticated');
    final uid = int.parse(auth.userIdentifier);
    final cutoff = DateTime.now().toUtc().subtract(Duration(days: days));
    return EnergyPrice.db.find(
      session,
      where: (t) => t.userInfoId.equals(uid) & (t.timestamp >= cutoff),
      orderBy: (t) => t.timestamp,
    );
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
