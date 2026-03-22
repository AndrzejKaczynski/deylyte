import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// License key validation. Called during onboarding (user is authenticated
/// but license not yet verified). Also called by the HA add-on on startup
/// to obtain the server-assigned sync interval and the inverter register map.
class LicenseEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  /// Validates a license key and associates it with the authenticated user.
  ///
  /// Returns:
  ///   valid               — bool
  ///   tier                — String? ('beta_free' | 'basic' | 'pro') when valid
  ///   syncIntervalSeconds — int? server-assigned poll interval when valid
  ///   registerMap         — Map? inverter register addresses when a model is selected
  ///   reason              — String? human-readable denial reason when invalid
  Future<String> validate(
    Session session,
    String licenseKey,
  ) async {
    final row = await LicenseKey.db.findFirstRow(
      session,
      where: (t) => t.licenseKey.equals(licenseKey),
    );

    if (row == null) {
      return jsonEncode({'valid': false, 'reason': 'Key not found'});
    }
    if (!row.isActive) {
      return jsonEncode({'valid': false, 'reason': 'Key deactivated'});
    }
    final now = DateTime.now().toUtc();
    if (row.expiresAt != null && row.expiresAt!.isBefore(now)) {
      return jsonEncode({'valid': false, 'reason': 'Key expired'});
    }

    // Associate with the authenticated user if not already claimed.
    final uid = session.authenticated != null
        ? int.tryParse(session.authenticated!.userIdentifier)
        : null;
    if (uid != null && row.userId != uid) {
      await LicenseKey.db.updateRow(session, row.copyWith(userId: uid));
    }

    // Update lastSeenAt (fire and forget — don't block the response).
    LicenseKey.db.updateRow(session, row.copyWith(lastSeenAt: now));

    // Look up the tier's configured sync interval.
    final syncConfig = await TierSyncConfig.db.findFirstRow(
      session,
      where: (t) => t.tier.equals(row.tier),
    );
    final syncIntervalSeconds = syncConfig?.syncIntervalSeconds ?? 300;

    // Include the inverter register map if the user has selected a model.
    // The add-on saves this to disk and uses it instead of built-in constants.
    Map<String, dynamic>? registerMap;
    if (row.userId != null) {
      final config = await AppConfig.db.findFirstRow(
        session,
        where: (t) => t.userInfoId.equals(row.userId!),
      );
      if (config?.inverterModelId != null) {
        final model = await InverterModel.db.findFirstRow(
          session,
          where: (t) => t.modelId.equals(config!.inverterModelId!),
        );
        if (model != null) {
          final decoded = jsonDecode(model.registerMapJson) as Map<String, dynamic>;
          registerMap = {'modelId': model.modelId, ...decoded};
        }
      }
    }

    return jsonEncode({
      'valid': true,
      'tier': row.tier,
      'syncIntervalSeconds': syncIntervalSeconds,
      if (registerMap != null) 'registerMap': registerMap,
    });
  }

  /// Returns the active license info for the authenticated user.
  /// Used by the Flutter app to determine feature availability (e.g. history range).
  ///
  /// Returns:
  ///   tier      — String ('beta_free' | 'basic' | 'pro'), or null if no active license
  ///   expiresAt — ISO8601 UTC expiry date, or null if never expires
  Future<String> getUserLicense(Session session) async {
    final auth = session.authenticated;
    if (auth == null) return jsonEncode({'tier': null});
    final uid = int.parse(auth.userIdentifier);

    final now = DateTime.now().toUtc();
    final row = await LicenseKey.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(uid) & t.isActive.equals(true),
    );

    if (row == null || (row.expiresAt != null && row.expiresAt!.isBefore(now))) {
      return jsonEncode({'tier': null});
    }

    final syncConfig = await TierSyncConfig.db.findFirstRow(
      session,
      where: (t) => t.tier.equals(row.tier),
    );

    return jsonEncode({
      'tier': row.tier,
      'expiresAt': row.expiresAt?.toIso8601String(),
      'historyDurationDays': syncConfig?.historyDurationDays ?? 7,
    });
  }
}
