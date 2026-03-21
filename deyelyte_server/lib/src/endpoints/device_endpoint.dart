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
  ///   connected       — true when telemetry received within last 5 minutes
  ///   lastSeenAt      — ISO8601 UTC of most recent telemetry, or null
  ///   inverterReachable — true if last telemetry had valid inverter state
  Future<Map<String, dynamic>> getStatus(Session session) async {
    final userInfoId = _uid(session);

    final device = await Device.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userInfoId),
    );

    if (device == null) {
      return {
        'connected': false,
        'lastSeenAt': null,
        'inverterReachable': false,
      };
    }

    final now = DateTime.now().toUtc();
    final lastSeen = device.lastSeenAt;
    final connected =
        lastSeen != null && now.difference(lastSeen).inMinutes < 5;

    return {
      'connected': connected,
      'lastSeenAt': lastSeen?.toIso8601String(),
      'inverterReachable': device.lastInverterOk,
    };
  }

  int _uid(Session session) =>
      int.parse(session.authenticated!.userIdentifier);
}
