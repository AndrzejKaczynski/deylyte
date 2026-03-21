import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// License key validation. Called during onboarding (user is authenticated
/// but license not yet verified). Also called by the HA add-on on startup.
class LicenseEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  /// Validates a license key and associates it with the authenticated user.
  ///
  /// Returns:
  ///   valid  — bool
  ///   tier   — String? ('beta_free' | 'basic' | 'pro') when valid
  ///   reason — String? human-readable denial reason when invalid
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

    return jsonEncode({'valid': true, 'tier': row.tier});
  }
}
