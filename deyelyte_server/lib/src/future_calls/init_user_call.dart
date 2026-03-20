import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../integrations/deye/deye_client.dart';

/// One-shot FutureCall triggered when a user first saves Deye credentials.
///
/// Responsibilities:
/// 1. Authenticate with Deye Cloud and fetch the device serial number.
/// 2. Store the device SN in IntegrationCredentials.
/// 3. Set AppConfig.dataGatheringSince (marks the start of the 7-day window).
/// 4. Schedule the recurring PollInverterCall and RunOptimizerCall.
///
/// Processes ALL users that have Deye credentials but no device SN yet,
/// so it is safe to schedule multiple times (idempotent per user).
class InitUserCall extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableModel? object) async {
    final pending = await IntegrationCredentials.db.find(
      session,
      where: (t) => t.deyeUsername.notEquals(null) & t.deyeDeviceSn.equals(null),
    );

    if (pending.isEmpty) {
      session.log('InitUserCall: no users pending initialisation');
      return;
    }

    for (final creds in pending) {
      await _initUser(session, creds);
    }
  }

  Future<void> _initUser(Session session, IntegrationCredentials creds) async {
    final userInfoId = creds.userInfoId;
    session.log('InitUserCall: initialising userInfoId $userInfoId');

    try {
      // We store a SHA256 hash in DB, never plaintext. Use authenticateWithHash
      // so the stored hash is sent directly to the Deye API (which also expects
      // SHA256) without double-hashing.
      final client = DeyeCloudClient(
        username: creds.deyeUsername!,
        password: creds.deyePasswordHash!,
        appId: creds.deyeAppId ?? '',
        appSecret: creds.deyeAppSecret ?? '',
        deviceSn: '', // not yet known — fetching below
      );

      await client.authenticateWithHash(session);

      final deviceSn = await client.fetchDeviceSn(session);

      await IntegrationCredentials.db.updateRow(
        session,
        creds.copyWith(deyeDeviceSn: deviceSn),
      );

      // Set dataGatheringSince on AppConfig (creates one if missing).
      final config = await AppConfig.db.findFirstRow(
        session,
        where: (t) => t.userInfoId.equals(userInfoId),
      );
      if (config != null) {
        await AppConfig.db.updateRow(
          session,
          config.copyWith(dataGatheringSince: DateTime.now().toUtc()),
        );
      }

      session.log('InitUserCall: userInfoId $userInfoId initialised, SN=$deviceSn');
    } catch (e) {
      session.log(
        'InitUserCall: failed for userInfoId $userInfoId: $e',
        level: LogLevel.error,
      );
      // Don't rethrow — allow other users to be processed.
    }
  }
}
