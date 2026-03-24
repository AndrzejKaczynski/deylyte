import '../repositories/history_repository.dart';
import 'mock_data.dart';

class MockHistoryRepository implements HistoryRepository {
  @override
  Future<Map<String, dynamic>> getSummary(DateTime from, DateTime to) async =>
      mockHistorySummary;

  @override
  Future<List<Map<String, dynamic>>> getEvents(DateTime from, DateTime to) async =>
      mockHistoryEvents;
}
