import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class CredentialsEndpoint extends Endpoint {
  // ---------------------------------------------------------------------------
  // Save
  // ---------------------------------------------------------------------------

  /// Save Deye Cloud credentials. The password is stored as a SHA256 hash.
  /// Schedules InitUserCall on the first save to fetch the device SN.
  Future<void> saveDeye(
    Session session,
    String username,
    String password,
    String appId,
    String appSecret,
  ) async {
    final userInfoId = _requireUserInfoId(session);
    final existing = await _loadCredentials(session, userInfoId);
    final isFirstSave = existing?.deyeUsername == null;
    final passwordHash = sha256.convert(utf8.encode(password)).toString();

    await _upsert(
      session,
      userInfoId,
      existing,
      (c) => c.copyWith(
        deyeUsername: username,
        deyePasswordHash: passwordHash,
        deyeAppId: appId,
        deyeAppSecret: appSecret,
      ),
    );

    if (isFirstSave) {
      // InitUserCall will find all users with deyeUsername set but no deviceSn
      // and complete their initialisation.
      await session.serverpod.futureCallWithDelay(
        'InitUserCall',
        null,
        const Duration(seconds: 5),
      );
      session.log('InitUserCall scheduled (first Deye save for userInfoId $userInfoId)');
    }
  }

  /// Save Solcast PV forecast credentials.
  Future<void> saveSolcast(
    Session session,
    String apiKey,
    String siteId,
  ) async {
    final userInfoId = _requireUserInfoId(session);
    final existing = await _loadCredentials(session, userInfoId);
    await _upsert(session, userInfoId, existing,
        (c) => c.copyWith(solcastApiKey: apiKey, solcastSiteId: siteId));
  }

  /// Save Pstryk energy pricing token.
  Future<void> savePstryk(Session session, String token) async {
    final userInfoId = _requireUserInfoId(session);
    final existing = await _loadCredentials(session, userInfoId);
    await _upsert(session, userInfoId, existing,
        (c) => c.copyWith(pstrykToken: token));
  }

  // ---------------------------------------------------------------------------
  // Remove (wipes credentials so user must re-enter from scratch)
  // ---------------------------------------------------------------------------

  /// Remove Deye credentials. Also clears deviceSn and resets dataGatheringSince.
  Future<void> removeDeye(Session session) async {
    final userInfoId = _requireUserInfoId(session);
    final existing = await _loadCredentials(session, userInfoId);
    if (existing == null) return;

    await _upsert(session, userInfoId, existing, (c) => c.copyWith(
      deyeUsername: null,
      deyePasswordHash: null,
      deyeAppId: null,
      deyeAppSecret: null,
      deyeDeviceSn: null,
    ));

    // Reset the data-gathering clock so the 7-day window restarts on reconnect.
    final config = await AppConfig.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userInfoId),
    );
    if (config != null) {
      await AppConfig.db.updateRow(
          session, config.copyWith(dataGatheringSince: null));
    }
  }

  /// Remove Solcast credentials.
  Future<void> removeSolcast(Session session) async {
    final userInfoId = _requireUserInfoId(session);
    final existing = await _loadCredentials(session, userInfoId);
    if (existing == null) return;
    await _upsert(session, userInfoId, existing,
        (c) => c.copyWith(solcastApiKey: null, solcastSiteId: null));
  }

  /// Remove Pstryk credentials.
  Future<void> removePstryk(Session session) async {
    final userInfoId = _requireUserInfoId(session);
    final existing = await _loadCredentials(session, userInfoId);
    if (existing == null) return;
    await _upsert(session, userInfoId, existing,
        (c) => c.copyWith(pstrykToken: null));
  }

  // ---------------------------------------------------------------------------
  // Status
  // ---------------------------------------------------------------------------

  /// Returns which integrations are currently configured.
  Future<Map<String, bool>> getStatus(Session session) async {
    final userInfoId = _requireUserInfoId(session);
    final creds = await _loadCredentials(session, userInfoId);
    return {
      'deye': creds?.deyeUsername != null,
      'solcast': creds?.solcastApiKey != null,
      'pstryk': creds?.pstrykToken != null,
    };
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  int _requireUserInfoId(Session session) {
    final authInfo = session.authenticated;
    if (authInfo == null) throw Exception('Not authenticated');
    return int.parse(authInfo.userIdentifier);
  }

  Future<IntegrationCredentials?> _loadCredentials(
      Session session, int userInfoId) {
    return IntegrationCredentials.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userInfoId),
    );
  }

  Future<void> _upsert(
    Session session,
    int userInfoId,
    IntegrationCredentials? existing,
    IntegrationCredentials Function(IntegrationCredentials) apply,
  ) async {
    final base = existing ?? IntegrationCredentials(userInfoId: userInfoId);
    final updated = apply(base);
    if (existing?.id != null) {
      await IntegrationCredentials.db.updateRow(session, updated);
    } else {
      await IntegrationCredentials.db.insertRow(session, updated);
    }
  }
}
