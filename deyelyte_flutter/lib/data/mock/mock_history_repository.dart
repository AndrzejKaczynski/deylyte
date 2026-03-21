import '../repositories/history_repository.dart';
import 'mock_data.dart';

class MockHistoryRepository implements HistoryRepository {
  @override
  Future<Map<String, dynamic>> getSummary(int rangeDays) async =>
      mockHistorySummary;

  @override
  Future<List<Map<String, dynamic>>> getEvents(int rangeDays) async =>
      mockHistoryEvents;
}
