import 'package:deyelyte_client/deyelyte_client.dart';

import '../repositories/schedule_repository.dart';

class ServerpodScheduleRepository implements ScheduleRepository {
  ServerpodScheduleRepository(this._client);
  final Client _client;

  @override
  Future<OptimizationFrame?> getCurrent() => _client.schedule.getCurrent();

  @override
  Future<List<OptimizationFrame>> getForecast() =>
      _client.schedule.getForecast();

  @override
  Future<List<Map<String, dynamic>>> getEvents() =>
      _client.schedule.getEvents();
}
