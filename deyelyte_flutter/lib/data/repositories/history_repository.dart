abstract class HistoryRepository {
  /// Returns aggregate summary metrics for [from]..[to] (inclusive).
  Future<Map<String, dynamic>> getSummary(DateTime from, DateTime to);
}
