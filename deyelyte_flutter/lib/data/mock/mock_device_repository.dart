import '../repositories/device_repository.dart';
import 'mock_data.dart';

class MockDeviceRepository implements DeviceRepository {
  @override
  Future<Map<String, dynamic>> getStatus() async => mockDeviceStatus;
}
