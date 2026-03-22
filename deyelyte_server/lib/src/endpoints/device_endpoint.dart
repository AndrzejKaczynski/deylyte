import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Returns HA add-on connection status and inverter model info for the
/// authenticated user. Also exposes model catalogue and model selection.
class DeviceEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // ── Connection status ─────────────────────────────────────────────────────

  /// Returns add-on connection status plus the user's current model selection
  /// and validation state.
  ///
  /// Response fields:
  ///   connected              — true when telemetry received within 3× sync interval
  ///   lastSeenAt             — ISO8601 UTC of most recent telemetry, or null
  ///   inverterReachable      — true if last telemetry had valid inverter state
  ///   inverterModelId        — currently selected model ID, or null
  ///   inverterModelName      — display name of selected model, or null
  ///   modelValidationStatus  — null | 'pending' | 'ok' | 'failed'
  Future<String> getStatus(Session session) async {
    final userInfoId = _uid(session);

    final device = await Device.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userInfoId),
    );

    final config = await AppConfig.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userInfoId),
    );

    InverterModel? model;
    if (config?.inverterModelId != null) {
      model = await InverterModel.db.findFirstRow(
        session,
        where: (t) => t.modelId.equals(config!.inverterModelId!),
      );
    }

    if (device == null) {
      return jsonEncode({
        'connected': false,
        'lastSeenAt': null,
        'inverterReachable': false,
        'inverterModelId': config?.inverterModelId,
        'inverterModelName': model?.displayName,
        'modelValidationStatus': null,
      });
    }

    final now = DateTime.now().toUtc();
    final lastSeen = device.lastSeenAt;
    final interval = device.syncIntervalSeconds ?? 300;
    final connected =
        lastSeen != null && now.difference(lastSeen).inSeconds < interval * 3;

    return jsonEncode({
      'connected': connected,
      'lastSeenAt': lastSeen?.toIso8601String(),
      'inverterReachable': device.lastInverterOk,
      'inverterModelId': config?.inverterModelId,
      'inverterModelName': model?.displayName,
      'modelValidationStatus': device.modelValidationStatus,
    });
  }

  // ── Model catalogue ───────────────────────────────────────────────────────

  /// Returns the full list of supported inverter models.
  /// Response: JSON array of { modelId, displayName }.
  Future<String> listModels(Session session) async {
    final models = await InverterModel.db.find(
      session,
      orderBy: (t) => t.displayName,
    );
    return jsonEncode(
      models.map((m) => {'modelId': m.modelId, 'displayName': m.displayName}).toList(),
    );
  }

  // ── Model selection ───────────────────────────────────────────────────────

  /// Saves the user's inverter model choice.
  /// Resets the device's validation state to 'pending' so the next telemetry
  /// cycle re-verifies that the registers make sense for the chosen model.
  ///
  /// Passing null clears the selection.
  Future<void> setModel(Session session, String? modelId) async {
    final uid = _uid(session);

    // Validate the modelId exists (unless clearing).
    if (modelId != null) {
      final exists = await InverterModel.db.findFirstRow(
        session,
        where: (t) => t.modelId.equals(modelId),
      );
      if (exists == null) throw Exception('Unknown model: $modelId');
    }

    // Update AppConfig.
    final config = await AppConfig.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(uid),
    );
    if (config != null) {
      await AppConfig.db.updateRow(
        session,
        config.copyWith(inverterModelId: modelId),
      );
    }

    // Reset Device validation state so the next telemetry re-checks.
    final device = await Device.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(uid),
    );
    if (device != null) {
      await Device.db.updateRow(
        session,
        device.copyWith(
          modelValidationStatus: modelId == null ? null : 'pending',
          modelValidationAttempts: 0,
        ),
      );
    }
  }

  int _uid(Session session) =>
      int.parse(session.authenticated!.userIdentifier);
}
