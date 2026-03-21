import 'package:deyelyte_client/deyelyte_client.dart';

abstract class TelemetryRepository {
  /// Returns the most recent telemetry snapshot, or null.
  Future<DeviceTelemetry?> getLatest();

  /// Returns up to [hours] hours of telemetry history.
  Future<List<DeviceTelemetry>> getHistory(int hours);
}
