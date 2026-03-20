import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class BaselineEndpoint extends Endpoint {
  
  Future<String> calculateBaseline(Session session, int userInfoId) async {
    final now = DateTime.now().toUtc();
    final startOfDay = DateTime.utc(now.year, now.month, now.day);
    final startOfMonth = DateTime.utc(now.year, now.month, 1);

    final inverterData = await InverterData.db.find(session,
      where: (t) => t.userInfoId.equals(userInfoId) & (t.timestamp > startOfMonth),
    );

    final prices = await EnergyPrice.db.find(session,
      where: (t) => t.userInfoId.equals(userInfoId) & (t.timestamp > startOfMonth),
    );

    // Build price lookup by hour
    final priceByHour = <String, EnergyPrice>{};
    for (var p in prices) {
      final key = '${p.timestamp.year}-${p.timestamp.month}-${p.timestamp.day}-${p.timestamp.hour}';
      priceByHour[key] = p;
    }

    double dailyCost = 0.0;
    double dailyProfit = 0.0;
    double monthlyCost = 0.0;
    double monthlyProfit = 0.0;

    for (var data in inverterData) {
      // Match the 15-min frame to its hourly price
      final key = '${data.timestamp.year}-${data.timestamp.month}-${data.timestamp.day}-${data.timestamp.hour}';
      final price = priceByHour[key];
      if (price == null) continue;

      // gridPower: positive = importing, negative = exporting
      final intervalHours = 0.25; // 15-minute intervals
      double energyKwh;

      if (data.gridPower > 0) {
        // Importing from grid
        energyKwh = data.gridPower * intervalHours / 1000.0;
        final cost = energyKwh * price.buyPrice;
        monthlyCost += cost;
        if (data.timestamp.isAfter(startOfDay)) {
          dailyCost += cost;
        }
      } else if (data.gridPower < 0) {
        // Exporting to grid
        energyKwh = data.gridPower.abs() * intervalHours / 1000.0;
        final profit = energyKwh * price.sellPrice;
        monthlyProfit += profit;
        if (data.timestamp.isAfter(startOfDay)) {
          dailyProfit += profit;
        }
      }
    }

    final dailyNet = dailyCost - dailyProfit;
    final monthlyNet = monthlyCost - monthlyProfit;

    // Negative net = user is making money, positive = user is paying
    return '{"dailyCost": ${dailyCost.toStringAsFixed(2)}, "dailyProfit": ${dailyProfit.toStringAsFixed(2)}, "dailyNet": ${dailyNet.toStringAsFixed(2)}, "monthlyCost": ${monthlyCost.toStringAsFixed(2)}, "monthlyProfit": ${monthlyProfit.toStringAsFixed(2)}, "monthlyNet": ${monthlyNet.toStringAsFixed(2)}}';
  }
}
