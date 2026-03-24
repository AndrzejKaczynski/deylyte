import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/future_calls.dart';
import '../generated/protocol.dart';

class CredentialsEndpoint extends Endpoint {
  // ---------------------------------------------------------------------------
  // Save
  // ---------------------------------------------------------------------------

  /// Save Deye Cloud credentials. The password is stored as a SHA256 hash.
  /// appId and appSecret are read from server config (passwords.yaml) — not
  /// supplied by the user.
  /// Schedules InitUserCall on the first save to fetch the device SN.
  Future<void> saveDeye(
    Session session,
    String username,
    String password,
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
      ),
    );

    if (isFirstSave) {
      // InitUserCall will find all users with deyeUsername set but no deviceSn
      // and complete their initialisation.
      await session.serverpod.futureCalls
          .callWithDelay(const Duration(seconds: 5))
          .initUserCall
          .invoke(null);
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

  /// Save Pstryk energy pricing token and enable the integration.
  Future<void> savePstryk(Session session, String token) async {
    final userInfoId = _requireUserInfoId(session);
    final existing = await _loadCredentials(session, userInfoId);
    await _upsert(session, userInfoId, existing,
        (c) => c.copyWith(pstrykToken: token));
    await _setPstrykEnabled(session, userInfoId, true);
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

  /// Remove Pstryk credentials and disable the integration.
  Future<void> removePstryk(Session session) async {
    final userInfoId = _requireUserInfoId(session);
    final existing = await _loadCredentials(session, userInfoId);
    if (existing == null) return;
    await _upsert(session, userInfoId, existing,
        (c) => c.copyWith(pstrykToken: null));
    await _setPstrykEnabled(session, userInfoId, false);
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

  Future<void> _setPstrykEnabled(
      Session session, int userInfoId, bool enabled) async {
    final config = await AppConfig.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userInfoId),
    );
    if (config != null) {
      await AppConfig.db.updateRow(
          session, config.copyWith(pstrykEnabled: enabled));
    }
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
