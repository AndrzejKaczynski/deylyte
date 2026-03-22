import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Returns HA add-on connection status for the authenticated user.
/// Called by Flutter on every app launch and by the onboarding polling widget.
class DeviceEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Returns add-on connection status.
  ///
  /// Response fields:
  ///   connected         — true when telemetry received within 3× the device's
  ///                       configured sync interval (i.e. 3 missed polls = offline)
  ///   lastSeenAt        — ISO8601 UTC of most recent telemetry, or null
  ///   inverterReachable — true if last telemetry had valid inverter state
  Future<String> getStatus(Session session) async {
    final userInfoId = _uid(session);

    final device = await Device.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userInfoId),
    );

    if (device == null) {
      return jsonEncode({
        'connected': false,
        'lastSeenAt': null,
        'inverterReachable': false,
      });
    }

    final now = DateTime.now().toUtc();
    final lastSeen = device.lastSeenAt;
    // Offline after 3 consecutive missed polls.
    final interval = device.syncIntervalSeconds ?? 300;
    final connected =
        lastSeen != null &&
        now.difference(lastSeen).inSeconds < interval * 3;

    return jsonEncode({
      'connected': connected,
      'lastSeenAt': lastSeen?.toIso8601String(),
      'inverterReachable': device.lastInverterOk,
    });
  }

  int _uid(Session session) =>
      int.parse(session.authenticated!.userIdentifier);
}
