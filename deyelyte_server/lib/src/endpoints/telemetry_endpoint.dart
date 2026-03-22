import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Handles inverter telemetry from the HA add-on and serves telemetry
/// history to the Flutter app.
class TelemetryEndpoint extends Endpoint {
  // ── Add-on facing (no login — license key auth) ───────────────────────────

  static const _maxValidationAttempts = 3;

  /// Receives a single telemetry snapshot from the HA add-on.
  /// Auth: the add-on provides its licenseKey as a plain parameter.
  ///
  /// [currentModelId] is the model ID the add-on is currently using (if any).
  /// When this differs from the server-side selection, the response includes
  /// a [registerMap] so the add-on updates its local cache without restarting.
  ///
  /// On success:
  ///   - Upserts a Device row (updates lastSeenAt + lastInverterOk + syncIntervalSeconds)
  ///   - Inserts a DeviceTelemetry row
  ///   - Validates telemetry against the selected model when status is 'pending'
  ///
  /// Returns JSON:
  ///   { "stop": true }                      — license expired/deactivated; add-on must stop
  ///   { }                                   — planning mode, no commands
  ///   { "commands": {...} }                 — live mode commands
  ///   Any response may also include:
  ///   { "syncIntervalSeconds": N }          — if the interval has changed
  ///   { "registerMap": {...} }              — if the server model differs from currentModelId
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
    String? currentModelId,
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

    // Load the user's app config (needed for model selection + planning mode).
    var config = await AppConfig.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(license.userId),
    );

    // Resolve register map to send back if the add-on's model is stale.
    Map<String, dynamic>? registerMapToSend;
    final serverModelId = config?.inverterModelId;
    if (serverModelId != null && serverModelId != currentModelId) {
      final model = await InverterModel.db.findFirstRow(
        session,
        where: (t) => t.modelId.equals(serverModelId),
      );
      if (model != null) {
        final decoded = jsonDecode(model.registerMapJson) as Map<String, dynamic>;
        registerMapToSend = {'modelId': model.modelId, ...decoded};
      }
    }

    // Upsert Device row.
    final existing = await Device.db.findFirstRow(
      session,
      where: (t) => t.hashedSerial.equals(deviceId),
    );

    final intervalChanged = existing?.syncIntervalSeconds != expectedInterval;

    // Run model validation when status is 'pending'.
    String? newValidationStatus = existing?.modelValidationStatus;
    int newAttempts = existing?.modelValidationAttempts ?? 0;

    if (existing?.modelValidationStatus == 'pending') {
      if (_telemetryIsPlausible(batterySOC, pvPowerW, gridPowerW, loadPowerW, batteryPowerW)) {
        newValidationStatus = 'ok';
        newAttempts = 0;
      } else {
        newAttempts += 1;
        if (newAttempts >= _maxValidationAttempts) {
          newValidationStatus = 'failed';
        }
      }
    }

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
          modelValidationStatus: serverModelId != null ? 'pending' : null,
          modelValidationAttempts: 0,
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
          modelValidationStatus: newValidationStatus,
          modelValidationAttempts: newAttempts,
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

    // First telemetry ever — start the 7-day baseline collection period.
    if (config != null && config.dataGatheringSince == null) {
      config = await AppConfig.db.updateRow(
        session,
        config.copyWith(dataGatheringSince: DateTime.now().toUtc()),
      );
    }

    // Build response.
    final extra = <String, dynamic>{
      if (intervalChanged) 'syncIntervalSeconds': expectedInterval,
      if (registerMapToSend != null) 'registerMap': registerMapToSend,
    };

    // Planning mode (or no config yet) → return empty response (+ extras).
    if (config == null || config.planningOnly) {
      return jsonEncode({...extra});
    }

    // Live mode → return current commands (+ extras).
    return jsonEncode({
      'commands': {
        'chargeFromGrid': config.chargingEnabled,
        'sellToGrid': config.sellingEnabled,
      },
      ...extra,
    });
  }

  /// Returns true when all telemetry values are within physically plausible
  /// ranges for a hybrid battery inverter.  A false result means the add-on
  /// is likely reading from wrong registers for the selected model.
  static bool _telemetryIsPlausible(
    double batterySOC,
    double pvPowerW,
    double gridPowerW,
    double loadPowerW,
    double batteryPowerW,
  ) {
    if (batterySOC < 0 || batterySOC > 100) return false;
    if (pvPowerW < 0 || pvPowerW > 50000) return false;
    if (loadPowerW < 0 || loadPowerW > 50000) return false;
    if (gridPowerW < -50000 || gridPowerW > 50000) return false;
    if (batteryPowerW < -50000 || batteryPowerW > 50000) return false;
    // All-zero readings after the first attempt are suspicious
    // (could happen at night, so we only flag if every field is 0).
    final allZero = batterySOC == 0 &&
        pvPowerW == 0 &&
        gridPowerW == 0 &&
        loadPowerW == 0 &&
        batteryPowerW == 0;
    if (allZero) return false;
    return true;
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
  /// The window is capped server-side using [TierSyncConfig.historyDurationDays]
  /// for the user's active tier. [hours] is the client's requested window;
  /// the server enforces the cap.
  Future<List<DeviceTelemetry>> getHistory(Session session, int hours) async {
    final uid = _uid(session);
    if (uid == null) return [];

    // Determine tier cap from TierSyncConfig.
    final license = await LicenseKey.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(uid) & t.isActive.equals(true),
    );
    final syncConfig = license == null
        ? null
        : await TierSyncConfig.db.findFirstRow(
            session,
            where: (t) => t.tier.equals(license.tier),
          );
    final maxDays = syncConfig?.historyDurationDays ?? 7;
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
