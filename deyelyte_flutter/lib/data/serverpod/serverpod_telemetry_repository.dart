import 'package:deyelyte_client/deyelyte_client.dart';

import '../repositories/telemetry_repository.dart';

class ServerpodTelemetryRepository implements TelemetryRepository {
  ServerpodTelemetryRepository(this._client);
  final Client _client;

  @override
  Future<DeviceTelemetry?> getLatest() => _client.telemetry.getLatest();

  @override
  Future<List<DeviceTelemetry>> getHistory(int hours) =>
      _client.telemetry.getHistory(hours);
}
