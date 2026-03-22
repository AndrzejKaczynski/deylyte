import 'dart:convert';
import 'dart:math';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

import '../generated/protocol.dart';

/// All methods require the caller to be an authenticated admin.
/// Admin rows are created exclusively via direct SQL — no endpoint can
/// grant or revoke admin status.
class AdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // ── Access check ───────────────────────────────────────────────────────────

  /// Returns true if the authenticated user is an admin. Used by the Flutter
  /// router to decide whether to show the /admin section.
  Future<bool> checkAccess(Session session) async {
    return _isAdmin(session);
  }

  // ── License keys ───────────────────────────────────────────────────────────

  /// Returns all license keys, newest first, with basic user info (JSON string).
  Future<String> listLicenseKeys(Session session) async {
    await _requireAdmin(session);

    final keys = await LicenseKey.db.find(
      session,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );

    final result = <Map<String, dynamic>>[];
    for (final k in keys) {
      UserInfo? user;
      try {
        user = await UserInfo.db.findById(session, k.userId);
      } catch (_) {}
      result.add({
        'id': k.id,
        'licenseKey': k.licenseKey,
        'tier': k.tier,
        'isActive': k.isActive,
        'createdAt': k.createdAt.toIso8601String(),
        'expiresAt': k.expiresAt?.toIso8601String(),
        'lastSeenAt': k.lastSeenAt?.toIso8601String(),
        'userId': k.userId,
        'userEmail': user?.email,
        'userName': user?.userName,
      });
    }
    return jsonEncode(result);
  }

  /// Creates a new license key for [userId] with the given [tier].
  /// Returns the generated key string.
  Future<String> createLicenseKey(
    Session session, {
    required int userId,
    required String tier,
    DateTime? expiresAt,
  }) async {
    await _requireAdmin(session);

    final key = _generateKey();
    await LicenseKey.db.insertRow(
      session,
      LicenseKey(
        licenseKey: key,
        userId: userId,
        tier: tier,
        isActive: true,
        createdAt: DateTime.now().toUtc(),
        expiresAt: expiresAt,
      ),
    );
    return key;
  }

  /// Activates or deactivates a license key by its DB id.
  Future<void> setLicenseKeyActive(
    Session session, {
    required int id,
    required bool active,
  }) async {
    await _requireAdmin(session);

    final key = await LicenseKey.db.findById(session, id);
    if (key == null) throw Exception('License key not found');
    await LicenseKey.db.updateRow(session, key.copyWith(isActive: active));
  }

  // ── Users ──────────────────────────────────────────────────────────────────

  /// Returns all users with their app config and device status (JSON string).
  Future<String> listUsers(Session session) async {
    await _requireAdmin(session);

    final users = await UserInfo.db.find(
      session,
      orderBy: (t) => t.created,
      orderDescending: true,
    );

    final result = <Map<String, dynamic>>[];
    for (final u in users) {
      AppConfig? config;
      Device? device;
      try {
        config = await AppConfig.db.findFirstRow(
          session,
          where: (t) => t.userInfoId.equals(u.id!),
        );
        device = await Device.db.findFirstRow(
          session,
          where: (t) => t.userId.equals(u.id!),
        );
      } catch (_) {}

      final lastSeen = device?.lastSeenAt;
      final interval = device?.syncIntervalSeconds ?? 300;
      final connected = lastSeen != null &&
          DateTime.now().toUtc().difference(lastSeen).inSeconds < interval * 3;

      result.add({
        'id': u.id,
        'email': u.email,
        'userName': u.userName,
        'created': u.created.toIso8601String(),
        'planningOnly': config?.planningOnly,
        'dataGatheringSince': config?.dataGatheringSince?.toIso8601String(),
        'priceSource': config?.priceSource,
        'deviceConnected': connected,
        'deviceLastSeen': device?.lastSeenAt?.toIso8601String(),
        'inverterReachable': device?.lastInverterOk,
      });
    }
    return jsonEncode(result);
  }

  // ── Devices ────────────────────────────────────────────────────────────────

  /// Returns all registered devices with connection status (JSON string).
  Future<String> listDevices(Session session) async {
    await _requireAdmin(session);

    final devices = await Device.db.find(
      session,
      orderBy: (t) => t.lastSeenAt,
      orderDescending: true,
    );

    final result = <Map<String, dynamic>>[];
    for (final d in devices) {
      UserInfo? user;
      try {
        user = await UserInfo.db.findById(session, d.userId);
      } catch (_) {}

      final age = d.lastSeenAt == null
          ? null
          : DateTime.now().toUtc().difference(d.lastSeenAt!);

      final dInterval = d.syncIntervalSeconds ?? 300;
      result.add({
        'id': d.id,
        'userId': d.userId,
        'userEmail': user?.email,
        'lastSeenAt': d.lastSeenAt?.toIso8601String(),
        'connected': age != null && age.inSeconds < dInterval * 3,
        'inverterReachable': d.lastInverterOk,
        'syncIntervalSeconds': dInterval,
        'createdAt': d.createdAt.toIso8601String(),
      });
    }
    return jsonEncode(result);
  }

  // ── Tier sync config ───────────────────────────────────────────────────────

  /// Returns all tier permission configurations (JSON string).
  Future<String> listTierPermissions(Session session) async {
    await _requireAdmin(session);
    final configs = await TierSyncConfig.db.find(session);
    return jsonEncode(configs
        .map((c) => {
              'id': c.id,
              'tier': c.tier,
              'syncIntervalSeconds': c.syncIntervalSeconds,
              'historyDurationDays': c.historyDurationDays,
            })
        .toList());
  }

  /// Updates (or inserts) the permissions for the given [tier].
  /// syncIntervalSeconds minimum is 300 s (logger hardware limitation).
  Future<void> updateTierPermissions(
    Session session, {
    required String tier,
    required int syncIntervalSeconds,
    required int historyDurationDays,
  }) async {
    await _requireAdmin(session);

    final clampedInterval = syncIntervalSeconds < 300 ? 300 : syncIntervalSeconds;
    final clampedHistory = historyDurationDays < 1 ? 1 : historyDurationDays;
    final existing = await TierSyncConfig.db.findFirstRow(
      session,
      where: (t) => t.tier.equals(tier),
    );
    if (existing == null) {
      await TierSyncConfig.db.insertRow(
        session,
        TierSyncConfig(
          tier: tier,
          syncIntervalSeconds: clampedInterval,
          historyDurationDays: clampedHistory,
        ),
      );
    } else {
      await TierSyncConfig.db.updateRow(
        session,
        existing.copyWith(
          syncIntervalSeconds: clampedInterval,
          historyDurationDays: clampedHistory,
        ),
      );
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Future<bool> _isAdmin(Session session) async {
    final auth = session.authenticated;
    if (auth == null) return false;
    final uid = int.tryParse(auth.userIdentifier);
    if (uid == null) return false;
    final row = await AdminUser.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(uid),
    );
    return row != null;
  }

  Future<void> _requireAdmin(Session session) async {
    if (!await _isAdmin(session)) {
      throw Exception('Forbidden');
    }
  }

  String _generateKey() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rng = Random.secure();
    // Format: XXXX-XXXX-XXXX-XXXX (easy to read + type)
    return List.generate(4, (_) {
      return List.generate(4, (_) => chars[rng.nextInt(chars.length)]).join();
    }).join('-');
  }
}
