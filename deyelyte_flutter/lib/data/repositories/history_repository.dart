abstract class HistoryRepository {
  /// Returns aggregate summary metrics for [from]..[to] (inclusive).
  Future<Map<String, dynamic>> getSummary(DateTime from, DateTime to);

  /// Returns notable events for [from]..[to] (inclusive).
  Future<List<Map<String, dynamic>>> getEvents(DateTime from, DateTime to);
}
