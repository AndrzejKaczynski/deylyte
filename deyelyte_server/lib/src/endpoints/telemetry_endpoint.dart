import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Handles inverter telemetry from the HA add-on and serves telemetry
/// history to the Flutter app.
class TelemetryEndpoint extends Endpoint {
  // ── Add-on facing (no login — license key auth) ───────────────────────────

  /// Receives a single telemetry snapshot from the HA add-on.
  /// Auth: the add-on provides its licenseKey as a plain parameter.
  ///
  /// On success:
  ///   - Upserts a Device row (updates lastSeenAt + lastInverterOk)
  ///   - Inserts a DeviceTelemetry row
  /// Returns JSON: `{}` in planning mode, `{"commands": {...}}` in live mode.
  Future<String> ingest(
    Session session,
    String licenseKey,
    String deviceId,
    DateTime timestamp,
    double batterySOC,
    double gridPowerW,
    double pvPowerW,
    double loadPowerW,
    double batteryPowerW,
  ) async {
    final license = await LicenseKey.db.findFirstRow(
      session,
      where: (t) => t.licenseKey.equals(licenseKey) & t.isActive.equals(true),
    );
    if (license == null) return jsonEncode({}); // silently reject invalid keys

    // Upsert Device row.
    final existing = await Device.db.findFirstRow(
      session,
      where: (t) => t.hashedSerial.equals(deviceId),
    );
    if (existing == null) {
      await Device.db.insertRow(
        session,
        Device(
          userId: license.userId,
          hashedSerial: deviceId,
          licenseKey: licenseKey,
          lastSeenAt: timestamp,
          lastInverterOk: true,
          createdAt: DateTime.now().toUtc(),
        ),
      );
    } else {
      await Device.db.updateRow(
        session,
        existing.copyWith(lastSeenAt: timestamp, lastInverterOk: true),
      );
    }

    // Insert telemetry row.
    await DeviceTelemetry.db.insertRow(
      session,
      DeviceTelemetry(
        deviceId: deviceId,
        userId: license.userId,
        timestamp: timestamp,
        batterySOC: batterySOC,
        gridPowerW: gridPowerW,
        pvPowerW: pvPowerW,
        loadPowerW: loadPowerW,
        batteryPowerW: batteryPowerW,
      ),
    );

    // Look up the user's app config to check planning mode.
    final config = await AppConfig.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(license.userId),
    );

    // Planning mode (or no config yet) → return empty response.
    // Add-on receives no commands and does nothing.
    if (config == null || config.planningOnly) {
      return jsonEncode({});
    }

    // Live mode → return current commands derived from config.
    // The optimizer will eventually populate a schedule table; for now we
    // derive simple on/off commands directly from the user's settings.
    return jsonEncode({
      'commands': {
        'chargeFromGrid': config.chargingEnabled,
        'sellToGrid': config.sellingEnabled,
      },
    });
  }

  // ── Flutter facing (requires login) ──────────────────────────────────────

  @override
  bool get requireLogin => false; // login enforced per-method via _uid()

  /// Returns the most recent telemetry snapshot for the authenticated user.
  /// Returns null when no telemetry has been received yet.
  Future<DeviceTelemetry?> getLatest(Session session) async {
    final uid = _uid(session);
    if (uid == null) return null;
    return DeviceTelemetry.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(uid),
      orderBy: (t) => t.timestamp,
      orderDescending: true,
    );
  }

  /// Returns up to [hours] hours of telemetry history for the authenticated user.
  Future<List<DeviceTelemetry>> getHistory(Session session, int hours) async {
    final uid = _uid(session);
    if (uid == null) return [];
    final cutoff =
        DateTime.now().toUtc().subtract(Duration(hours: hours));
    return DeviceTelemetry.db.find(
      session,
      where: (t) =>
          t.userId.equals(uid) & (t.timestamp >= cutoff),
      orderBy: (t) => t.timestamp,
    );
  }

  int? _uid(Session session) {
    final auth = session.authenticated;
    if (auth == null) return null;
    return int.tryParse(auth.userIdentifier);
  }
}
