import 'package:deyelyte_client/deyelyte_client.dart';

import '../repositories/telemetry_repository.dart';
import 'mock_data.dart';

class MockTelemetryRepository implements TelemetryRepository {
  @override
  Future<DeviceTelemetry?> getLatest() async => mockLatestTelemetry;

  @override
  Future<List<DeviceTelemetry>> getHistory(int hours) async => mockHistory;
}
