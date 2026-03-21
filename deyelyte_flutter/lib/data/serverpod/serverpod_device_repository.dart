import 'package:deyelyte_client/deyelyte_client.dart';

import '../repositories/device_repository.dart';

class ServerpodDeviceRepository implements DeviceRepository {
  ServerpodDeviceRepository(this._client);
  final Client _client;

  @override
  Future<Map<String, dynamic>> getStatus() =>
      _client.device.getStatus();
}
