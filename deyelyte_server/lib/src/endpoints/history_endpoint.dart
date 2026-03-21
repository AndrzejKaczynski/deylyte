import 'package:serverpod/serverpod.dart';

/// Returns historical energy summaries and events for the Flutter history screen.
/// Stub implementation — returns zero/empty data until the baseline engine
/// and telemetry aggregation are wired in a later phase.
class HistoryEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Returns aggregate summary metrics for the given date range.
  ///
  /// [rangeDays] — number of days to include (7, 30, or 90)
  ///
  /// Stub returns zero values. Real implementation will aggregate
  /// DeviceTelemetry + EnergyPrice rows.
  Future<Map<String, dynamic>> getSummary(
    Session session,
    int rangeDays,
  ) async {
    return {
      'priceVelocity': 0.0,       // PLN/kWh average over period
      'netRevenuePln': 0.0,       // total net revenue (sell - buy cost)
      'peakLoadKw': 0.0,          // maximum instantaneous load
      'greenMixPercent': 0.0,     // % of load served by PV + battery
      'totalSavingsPln': 0.0,     // savings vs grid-only scenario
      'storageEfficiencyPercent': 0.0,
      'peakDemandKw': 0.0,
      // Carbon offset intentionally omitted — requires grid carbon intensity API
    };
  }

  /// Returns a list of notable market/schedule events for the history screen.
  ///
  /// [rangeDays] — number of days to include (7, 30, or 90)
  ///
  /// Stub returns empty list.
  Future<List<Map<String, dynamic>>> getEvents(
    Session session,
    int rangeDays,
  ) async {
    return [];
  }
}
