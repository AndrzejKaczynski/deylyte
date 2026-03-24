import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

class PstrykClient {
  static const String _baseUrl = 'https://api.pstryk.pl/integrations';
  final String token;
  final int userInfoId;

  PstrykClient(this.token, {required this.userInfoId});

  Map<String, String> get _headers => {
        'Authorization': token,
        'Content-Type': 'application/json',
      };

  Future<void> fetchAndStorePrices(Session session) async {
    final now = DateTime.now().toUtc();
    // Warsaw is UTC+1 (CET) or UTC+2 (CEST). Subtract 2h from UTC midnight so
    // window_start is always <= Warsaw 00:00 regardless of DST. The extra hours
    // fetched from yesterday are harmless — they just update existing records.
    // NOTE: for_tz is forbidden with resolution=hour (API returns 400), so UTC
    // window adjustment is the only option.
    final windowStart = DateTime.utc(now.year, now.month, now.day)
        .subtract(const Duration(hours: 2));
    final windowEnd = windowStart.add(const Duration(hours: 50));

    final uri = Uri.parse(
      '$_baseUrl/meter-data/unified-metrics/'
      '?metrics=pricing'
      '&resolution=hour'
      '&window_start=${_fmtUtc(windowStart)}'
      '&window_end=${_fmtUtc(windowEnd)}',
    );

    final res = await http.get(uri, headers: _headers);

    if (res.statusCode != 200) {
      session.log(
        'Pstryk unified-metrics fetch failed: ${res.statusCode} — ${res.body}',
        level: LogLevel.error,
      );
      throw Exception('Pstryk API returned ${res.statusCode}');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final frames = data['frames'] as List;

    int stored = 0;
    for (final frame in frames) {
      final startTimeStr = frame['start'] as String;
      final startTime = DateTime.parse(startTimeStr).toUtc();

      final metrics = frame['metrics'] as Map<String, dynamic>?;
      final pricing = metrics?['pricing'] as Map<String, dynamic>?;
      if (pricing == null) continue;

      // price_gross is null when tomorrow's TGE prices aren't published yet
      final buyPrice = (pricing['price_gross'] as num?)?.toDouble();
      if (buyPrice == null) continue;

      final sellPrice =
          (pricing['price_prosumer_gross'] as num?)?.toDouble() ?? 0.0;

      final existing = await EnergyPrice.db.findFirstRow(
        session,
        where: (t) =>
            t.timestamp.equals(startTime) & t.userInfoId.equals(userInfoId),
      );

      if (existing != null) {
        existing.buyPrice = buyPrice;
        existing.sellPrice = sellPrice;
        await EnergyPrice.db.updateRow(session, existing);
      } else {
        await EnergyPrice.db.insertRow(
          session,
          EnergyPrice(
            userInfoId: userInfoId,
            timestamp: startTime,
            buyPrice: buyPrice,
            sellPrice: sellPrice,
            currency: 'PLN',
          ),
        );
      }
      stored++;
    }

    session.log('Pstryk: stored $stored price frames (today + tomorrow).');
  }

  static String _fmtUtc(DateTime dt) {
    final iso = dt.toIso8601String();
    final trimmed =
        iso.contains('.') ? iso.substring(0, iso.indexOf('.')) : iso.replaceAll('Z', '');
    return '${trimmed}Z';
  }
}
