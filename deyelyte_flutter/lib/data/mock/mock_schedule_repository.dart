import 'package:deyelyte_client/deyelyte_client.dart';

import '../repositories/schedule_repository.dart';

class MockScheduleRepository implements ScheduleRepository {
  @override
  Future<OptimizationFrame?> getCurrent() async => null;

  @override
  Future<List<OptimizationFrame>> getForecast() async => [];

  @override
  Future<List<Map<String, dynamic>>> getEvents() async => [];
}
