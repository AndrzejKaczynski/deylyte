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
  ///   - Upserts a Device row (updates lastSeenAt + lastInverterOk + syncIntervalSeconds)
  ///   - Inserts a DeviceTelemetry row
  ///
  /// Returns JSON:
  ///   { "stop": true }                      — license expired/deactivated; add-on must stop
  ///   { }                                   — planning mode, no commands
  ///   { "commands": {...} }                 — live mode commands
  ///   Any response may also include:
  ///   { "syncIntervalSeconds": N }          — if the interval has changed, add-on must update
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
      where: (t) => t.licenseKey.equals(licenseKey),
    );

    // Unknown key — silently reject.
    if (license == null) return jsonEncode({});

    // Expired or deactivated — tell the add-on to stop.
    final now = DateTime.now().toUtc();
    final expired =
        license.expiresAt != null && license.expiresAt!.isBefore(now);
    if (!license.isActive || expired) {
      return jsonEncode({'stop': true});
    }

    // Look up this tier's configured sync interval.
    final syncConfig = await TierSyncConfig.db.findFirstRow(
      session,
      where: (t) => t.tier.equals(license.tier),
    );
    final expectedInterval = syncConfig?.syncIntervalSeconds ?? 300;

    // Upsert Device row.
    final existing = await Device.db.findFirstRow(
      session,
      where: (t) => t.hashedSerial.equals(deviceId),
    );

    final intervalChanged = existing?.syncIntervalSeconds != expectedInterval;

    if (existing == null) {
      await Device.db.insertRow(
        session,
        Device(
          userId: license.userId,
          hashedSerial: deviceId,
          licenseKey: licenseKey,
          lastSeenAt: timestamp,
          lastInverterOk: true,
          syncIntervalSeconds: expectedInterval,
          createdAt: DateTime.now().toUtc(),
        ),
      );
    } else {
      await Device.db.updateRow(
        session,
        existing.copyWith(
          lastSeenAt: timestamp,
          lastInverterOk: true,
          syncIntervalSeconds: expectedInterval,
        ),
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
    var config = await AppConfig.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(license.userId),
    );

    // First telemetry ever — start the 7-day baseline collection period.
    if (config != null && config.dataGatheringSince == null) {
      config = await AppConfig.db.updateRow(
        session,
        config.copyWith(dataGatheringSince: DateTime.now().toUtc()),
      );
    }

    // Build response — always include syncIntervalSeconds if it changed.
    final extra = intervalChanged ? {'syncIntervalSeconds': expectedInterval} : <String, dynamic>{};

    // Planning mode (or no config yet) → return empty response (+ interval if changed).
    if (config == null || config.planningOnly) {
      return jsonEncode({...extra});
    }

    // Live mode → return current commands (+ interval if changed).
    return jsonEncode({
      'commands': {
        'chargeFromGrid': config.chargingEnabled,
        'sellToGrid': config.sellingEnabled,
      },
      ...extra,
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

  /// Returns telemetry history for the authenticated user.
  /// The window is capped server-side by tier:
  ///   pro / beta_free → 90 days
  ///   basic           → 30 days
  /// [hours] is the client's requested window; the server enforces the cap.
  Future<List<DeviceTelemetry>> getHistory(Session session, int hours) async {
    final uid = _uid(session);
    if (uid == null) return [];

    // Determine tier cap.
    final license = await LicenseKey.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(uid) & t.isActive.equals(true),
    );
    final maxDays = (license?.tier == 'basic') ? 30 : 90;
    final cappedHours = hours.clamp(1, maxDays * 24);

    final cutoff = DateTime.now().toUtc().subtract(Duration(hours: cappedHours));
    return DeviceTelemetry.db.find(
      session,
      where: (t) => t.userId.equals(uid) & (t.timestamp >= cutoff),
      orderBy: (t) => t.timestamp,
    );
  }

  int? _uid(Session session) {
    final auth = session.authenticated;
    if (auth == null) return null;
    return int.tryParse(auth.userIdentifier);
  }
}
