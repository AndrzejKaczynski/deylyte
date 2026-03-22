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

  @override
  Future<List<Map<String, dynamic>>> listModels() async {
    final json = await _client.device.listModels();
    final list = jsonDecode(json) as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  }

  @override
  Future<void> setModel(String? modelId) async {
    await _client.device.setModel(modelId);
  }
}
