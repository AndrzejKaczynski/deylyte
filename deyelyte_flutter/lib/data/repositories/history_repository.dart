abstract class HistoryRepository {
  /// Returns aggregate summary metrics for [rangeDays] days.
  Future<Map<String, dynamic>> getSummary(int rangeDays);

  /// Returns notable events for [rangeDays] days.
  Future<List<Map<String, dynamic>>> getEvents(int rangeDays);
}
