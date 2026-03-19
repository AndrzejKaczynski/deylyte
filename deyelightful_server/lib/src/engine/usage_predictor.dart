import 'dart:math';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class UsagePredictor {
  
  /// Predicts the average household load in Watts for a specific 1-hour window.
  static Future<double> predictUsageForHour(
    Session session, 
    DateTime targetHour,
    List<InverterData> historicalData,
  ) async {
    final targetIsWeekend = targetHour.weekday > 5;
    
    // 1. Filter by Time of Day (Hour) and Day Type (Weekend vs Workday)
    var matchedData = historicalData.where((d) {
      final isWeekend = d.timestamp.weekday > 5;
      final sameHour = d.timestamp.hour == targetHour.hour;
      return sameHour && (isWeekend == targetIsWeekend);
    }).toList();

    if (matchedData.isEmpty) {
      return 500.0; // Safe default base load if no data exists
    }

    // 2. Outlier Rejection (Drop top 5% and bottom 5% of anomalies)
    matchedData.sort((a, b) => a.loadPower.compareTo(b.loadPower));
    
    int dropCount = (matchedData.length * 0.05).floor();
    if (matchedData.length > dropCount * 2 && dropCount > 0) {
      matchedData = matchedData.sublist(dropCount, matchedData.length - dropCount);
    }

    if (matchedData.isEmpty) {
      return 500.0;
    }

    // 3. Apply Recency Bias (Weighted Average)
    double totalWeightedLoad = 0.0;
    double totalWeight = 0.0;

    for (var d in matchedData) {
      // Days difference from the target expected hour
      int daysOld = targetHour.difference(d.timestamp).inDays.abs();
      daysOld = max(1, daysOld); // Guard against zero division
      
      // Inverse weighting: recent days get vastly higher mathematical weight
      double weight = 1.0 / daysOld;
      
      totalWeightedLoad += d.loadPower * weight;
      totalWeight += weight;
    }

    if (totalWeight == 0) return 500.0;
    
    return totalWeightedLoad / totalWeight;
  }
}
