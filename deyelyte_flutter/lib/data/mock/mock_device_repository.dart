import '../repositories/device_repository.dart';
import 'mock_data.dart';

class MockDeviceRepository implements DeviceRepository {
  @override
  Future<Map<String, dynamic>> getStatus() async => mockDeviceStatus;

  @override
  Future<List<Map<String, dynamic>>> listModels() async => mockInverterModels;

  @override
  Future<void> setModel(String? modelId) async {}
}
