import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

/// Fetches RCE (Rynkowa Cena Energii Elektrycznej) prices from the PSE public
/// API and stores them as EnergyPrice rows.
///
/// PSE API: GET https://api.raporty.pse.pl/api/rce-pln?$filter=doba eq 'YYYY-MM-DD'
/// Returns PLN/MWh; periodId 1–24 maps to hours 0–23.
///
/// The effective buy price = RCE (PLN/kWh) + distribution charge for that hour
/// (looked up from the user's PriceTimeRange list).
/// The sell price = RCE only (Polish net-billing compensates prosumers at RCE).
class RceClient {
  static const String _baseUrl = 'https://api.raporty.pse.pl/api/rce-pln';

  final int userInfoId;
  final List<PriceTimeRange> timeRanges;
  /// VAT rate applied to RCE spot price (e.g. 0.23 for 23%). Default 0.23.
  final double vatRate;

  RceClient({
    required this.userInfoId,
    required this.timeRanges,
    double? vatRate,
  }) : vatRate = vatRate ?? 0.23;

  /// Returns the distribution charge (PLN/kWh) for a given UTC hour (0–23).
  /// Finds the first matching range; defaults to 0.0 if none covers the hour.
  double _distributionForHour(int hour) {
    for (final range in timeRanges) {
      final start = range.hourStart;
      final end = range.hourEnd;
      // Support wrap-around windows (e.g. 22–6 for a night-rate window).
      final covers = end <= start
          ? hour >= start || hour < end
          : hour >= start && hour < end;
      if (covers) return range.distributionRatePln;
    }
    return 0.0;
  }

  /// Fetches today and tomorrow so the optimizer always has a full 24 h ahead.
  Future<void> fetchAndStorePrices(Session session) async {
    final now = DateTime.now().toUtc();
    await _fetchDay(session, now);
    await _fetchDay(session, now.add(const Duration(days: 1)));
  }

  Future<void> _fetchDay(Session session, DateTime date) async {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final uri = Uri.parse("$_baseUrl?\$filter=doba eq '$dateStr'");

    final response =
        await http.get(uri, headers: {'Accept': 'application/json'});

    if (response.statusCode != 200) {
      session.log(
        'RCE: fetch failed for $dateStr — HTTP ${response.statusCode}',
        level: LogLevel.warning,
      );
      return;
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final values = data['value'] as List?;
    if (values == null || values.isEmpty) {
      session.log('RCE: no data returned for $dateStr');
      return;
    }

    for (final item in values) {
      final periodId = item['periodId'] as int; // 1–24
      final rceMwh = (item['rce_pln'] as num).toDouble(); // PLN/MWh
      final rceKwh = rceMwh / 1000.0; // PLN/kWh

      final hour = periodId - 1; // 0–23
      final timestamp = DateTime.utc(date.year, date.month, date.day, hour);

      final buyPrice = rceKwh * (1 + vatRate) + _distributionForHour(hour);
      final sellPrice = rceKwh; // prosumer settlement at RCE, no distribution

      final existing = await EnergyPrice.db.findFirstRow(
        session,
        where: (t) =>
            t.timestamp.equals(timestamp) & t.userInfoId.equals(userInfoId),
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
            timestamp: timestamp,
            buyPrice: buyPrice,
            sellPrice: sellPrice,
            currency: 'PLN',
          ),
        );
      }
    }

    session.log('RCE: stored prices for $dateStr (user $userInfoId)');
  }
}
