import 'dart:convert';

import 'package:deyelyte_client/deyelyte_client.dart';

import '../repositories/device_repository.dart';

class ServerpodDeviceRepository implements DeviceRepository {
  ServerpodDeviceRepository(this._client);
  final Client _client;

  @override
  Future<Map<String, dynamic>> getStatus() async {
    final json = await _client.device.getStatus();
    return jsonDecode(json) as Map<String, dynamic>;
  }
}
