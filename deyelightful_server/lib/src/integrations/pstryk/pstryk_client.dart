import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

class PstrykClient {
  static const String baseUrl = 'https://api.pstryk.pl/integrations';
  final String token;
  final int userInfoId;

  PstrykClient(this.token, {required this.userInfoId});

  Future<void> fetchAndStorePrices(Session session) async {
    final now = DateTime.now().toUtc();
    final start = '${DateTime(now.year, now.month, now.day).toIso8601String()}Z';

    final headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json',
    };

    // Fetch Buy Prices
    final buyUri = Uri.parse('$baseUrl/pricing/?resolution=hour&window_start=$start');
    final buyRes = await http.get(buyUri, headers: headers);
    
    // Fetch Sell Prices (Prosumer)
    final sellUri = Uri.parse('$baseUrl/prosumer-pricing/?resolution=hour&window_start=$start');
    final sellRes = await http.get(sellUri, headers: headers);

    if (buyRes.statusCode != 200 || sellRes.statusCode != 200) {
      session.log('Failed to fetch Pstryk prices: ${buyRes.statusCode} / ${sellRes.statusCode}');
      return;
    }

    final buyData = jsonDecode(buyRes.body);
    final sellData = jsonDecode(sellRes.body);

    final buyFrames = buyData['frames'] as List;
    final sellFrames = sellData['frames'] as List;

    final sellMap = {
      for (var f in sellFrames) f['start']: f['price_gross']
    };

    for (var frame in buyFrames) {
      final startTimeStr = frame['start'] as String;
      final startTime = DateTime.parse(startTimeStr).toUtc();
      
      final buyPrice = (frame['price_gross'] as num).toDouble();
      final sellPrice = (sellMap[startTimeStr] as num?)?.toDouble() ?? 0.0;

      final existing = await EnergyPrice.db.findFirstRow(session,
        where: (t) => t.timestamp.equals(startTime) & t.userInfoId.equals(userInfoId),
      );

      if (existing != null) {
        existing.buyPrice = buyPrice;
        existing.sellPrice = sellPrice;
        await EnergyPrice.db.updateRow(session, existing);
      } else {
        final newPrice = EnergyPrice(
          userInfoId: userInfoId,
          timestamp: startTime,
          buyPrice: buyPrice,
          sellPrice: sellPrice,
          currency: 'PLN',
        );
        await EnergyPrice.db.insertRow(session, newPrice);
      }
    }
    
    session.log('Successfully updated Pstryk prices.');
  }
}
