import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

class OpenMeteoClient {
  static const _geocodingBase = 'https://geocoding-api.open-meteo.com/v1';
  static const _archiveBase = 'https://archive-api.open-meteo.com/v1';
  static const _forecastBase = 'https://api.open-meteo.com/v1';

  /// Resolves a city name to lat/lon. Returns null if not found or on error.
  static Future<({double lat, double lon})?> geocodeCity(
    Session session,
    String cityName,
  ) async {
    final uri = Uri.parse(
        '$_geocodingBase/search?name=${Uri.encodeComponent(cityName)}&count=1&format=json');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      session.log('OpenMeteo geocoding failed (${response.statusCode}) for "$cityName"');
      return null;
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List?;
    if (results == null || results.isEmpty) {
      session.log('OpenMeteo geocoding: no results for "$cityName"');
      return null;
    }
    final first = results.first as Map<String, dynamic>;
    return (
      lat: (first['latitude'] as num).toDouble(),
      lon: (first['longitude'] as num).toDouble(),
    );
  }

  /// Fetches hourly shortwave radiation (W/m²) for a historical date range.
  /// Returns a map of UTC hour → W/m².
  static Future<Map<DateTime, double>> fetchHistoricalHourlyRadiation(
    Session session,
    double lat,
    double lon,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final start = _fmtDate(startDate);
    final end = _fmtDate(endDate);
    final uri = Uri.parse(
        '$_archiveBase/archive?latitude=$lat&longitude=$lon'
        '&start_date=$start&end_date=$end'
        '&hourly=shortwave_radiation&timezone=UTC');
    return _parseHourlyRadiation(session, uri);
  }

  /// Fetches hourly shortwave radiation (W/m²) for the next 2 days.
  /// Returns a map of UTC hour → W/m².
  static Future<Map<DateTime, double>> fetchForecastHourlyRadiation(
    Session session,
    double lat,
    double lon,
  ) async {
    final uri = Uri.parse(
        '$_forecastBase/forecast?latitude=$lat&longitude=$lon'
        '&hourly=shortwave_radiation&forecast_days=2&timezone=UTC');
    return _parseHourlyRadiation(session, uri);
  }

  static Future<Map<DateTime, double>> _parseHourlyRadiation(
    Session session,
    Uri uri,
  ) async {
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      session.log('OpenMeteo radiation fetch failed (${response.statusCode}): $uri');
      return {};
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final hourly = data['hourly'] as Map<String, dynamic>;
    final times = hourly['time'] as List;
    final radiation = hourly['shortwave_radiation'] as List;

    final result = <DateTime, double>{};
    for (var i = 0; i < times.length; i++) {
      // Open-Meteo returns "2026-03-06T00:00" — append seconds + Z for UTC parse
      final dt = DateTime.parse('${times[i]}:00Z');
      final rad = radiation[i];
      if (rad != null) {
        result[dt] = (rad as num).toDouble();
      }
    }
    return result;
  }

  static String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
