import 'package:deyelyte_client/deyelyte_client.dart';

abstract class ScheduleRepository {
  /// Returns the OptimizationFrame for the current hour, or null.
  Future<OptimizationFrame?> getCurrent();

  /// Returns all upcoming OptimizationFrames.
  Future<List<OptimizationFrame>> getForecast();

  /// Returns schedule events for the schedule screen.
  Future<List<Map<String, dynamic>>> getEvents();
}
