abstract class DeviceRepository {
  /// Returns add-on connection status.
  /// Keys: connected (bool), lastSeenAt (String?), inverterReachable (bool).
  Future<Map<String, dynamic>> getStatus();
}
