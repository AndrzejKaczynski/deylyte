import 'package:serverpod/serverpod.dart';
import '../generated/future_calls.dart';
import '../generated/protocol.dart';
import '../integrations/deye/deye_client.dart';

/// Polls the Deye Cloud API every 15 minutes for all users that have a
/// device SN configured, and inserts an InverterData row per user.
///
/// Self-rescheduling: reschedules itself at the end of each run.
class PollInverterCall extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableModel? object) async {
    final allCreds = await IntegrationCredentials.db.find(
      session,
      where: (t) => t.deyeDeviceSn.notEquals(null),
    );

    session.log('PollInverterCall: polling ${allCreds.length} user(s)');

    for (final creds in allCreds) {
      await _pollUser(session, creds);
    }

    await session.serverpod.futureCalls
        .callWithDelay(const Duration(minutes: 15))
        .pollInverterCall
        .invoke(null);
  }

  Future<void> _pollUser(Session session, IntegrationCredentials creds) async {
    try {
      final client = DeyeCloudClient(
        username: creds.deyeUsername!,
        password: creds.deyePasswordHash!,
        appId: session.passwords['deyeAppId'] ?? '',
        appSecret: session.passwords['deyeAppSecret'] ?? '',
        deviceSn: creds.deyeDeviceSn!,
      );
      await client.authenticateWithHash(session);
      await client.fetchAndStoreInverterData(session, creds.userInfoId);
    } catch (e) {
      session.log(
        'PollInverterCall: failed for userInfoId ${creds.userInfoId}: $e',
        level: LogLevel.error,
      );
    }
  }
}
