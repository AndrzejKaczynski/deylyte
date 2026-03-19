import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

class SolcastClient {
  final String apiKey;
  final String siteId;
  final int userInfoId;
  static const String baseUrl = 'https://api.solcast.com.au/rooftop_sites';

  SolcastClient({required this.apiKey, required this.siteId, required this.userInfoId});

  Future<void> fetchAndStoreForecast(Session session) async {
    final uri = Uri.parse('$baseUrl/$siteId/forecasts?format=json');
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      session.log('Failed to fetch Solcast forecast: ${response.statusCode}');
      return;
    }

    final data = jsonDecode(response.body);
    final forecasts = data['forecasts'] as List;

    for (var f in forecasts) {
      final periodEndStr = f['period_end'] as String;
      final periodEnd = DateTime.parse(periodEndStr).toUtc();
      
      // pv_estimate is in kW, convert to Watts for consistency
      final pvEstimate = (f['pv_estimate'] as num).toDouble() * 1000.0;

      final existing = await PvForecast.db.findFirstRow(session,
        where: (t) => t.timestamp.equals(periodEnd) & t.userInfoId.equals(userInfoId),
      );

      if (existing != null) {
        existing.expectedYieldWatts = pvEstimate;
        await PvForecast.db.updateRow(session, existing);
      } else {
        final newForecast = PvForecast(
          userInfoId: userInfoId,
          timestamp: periodEnd,
          expectedYieldWatts: pvEstimate,
        );
        await PvForecast.db.insertRow(session, newForecast);
      }
    }
    
    session.log('Successfully updated Solcast PV forecast.');
  }
}
