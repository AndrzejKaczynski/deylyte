import 'package:serverpod/serverpod.dart';
import '../generated/future_calls.dart';
import '../generated/protocol.dart';
import '../integrations/pstryk/pstryk_client.dart';
import '../integrations/rce/rce_client.dart';

/// Polls energy prices every hour for all users that have an AppConfig.
/// Dispatches to the correct source based on AppConfig.priceSource:
///   - 'pstryk' (default): fetches from Pstryk API using stored token.
///   - 'rce':              fetches from PSE public RCE API.
///   - 'fixed':            pre-populates the next 48 h with fixed rates.
///
/// Self-rescheduling: reschedules itself at the end of each run.
class PollEnergyPricesCall extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableModel? object) async {
    final allConfigs = await AppConfig.db.find(session);
    session.log(
        'PollEnergyPricesCall: updating prices for ${allConfigs.length} user(s)');

    for (final config in allConfigs) {
      await _updateForUser(session, config);
    }

    await session.serverpod.futureCalls
        .callWithDelay(const Duration(hours: 1))
        .pollEnergyPricesCall
        .invoke(null);
  }

  Future<void> _updateForUser(Session session, AppConfig config) async {
    final userInfoId = config.userInfoId;
    final source = config.priceSource ?? 'pstryk';

    try {
      switch (source) {
        case 'rce':
          final ranges = await PriceTimeRange.db.find(
            session,
            where: (t) => t.userInfoId.equals(userInfoId),
          );
          final client =
              RceClient(userInfoId: userInfoId, timeRanges: ranges);
          await client.fetchAndStorePrices(session);

        case 'fixed':
          final ranges = await PriceTimeRange.db.find(
            session,
            where: (t) => t.userInfoId.equals(userInfoId),
          );
          await _writeFixedRates(session, config, ranges);

        default: // 'pstryk'
          if (!config.pstrykEnabled) {
            session.log(
              'PollEnergyPricesCall: Pstryk not enabled for user $userInfoId — skipping',
              level: LogLevel.debug,
            );
            return;
          }
          final creds = await IntegrationCredentials.db.findFirstRow(
            session,
            where: (t) => t.userInfoId.equals(userInfoId),
          );
          final token = creds?.pstrykToken;
          if (token == null) {
            session.log(
              'PollEnergyPricesCall: no Pstryk token for user $userInfoId — skipping',
              level: LogLevel.warning,
            );
            return;
          }
          final client = PstrykClient(token, userInfoId: userInfoId);
          await client.fetchAndStorePrices(session);
      }
    } catch (e) {
      session.log(
        'PollEnergyPricesCall: failed for user $userInfoId (source=$source): $e',
        level: LogLevel.error,
      );
    }
  }

  /// Writes fixed buy/sell rates for the next 48 hours.
  /// For each hour, finds the matching PriceTimeRange (if any);
  /// falls back to config.fixedBuyRatePln / fixedSellRatePln if no range covers it.
  Future<void> _writeFixedRates(
    Session session,
    AppConfig config,
    List<PriceTimeRange> ranges,
  ) async {
    final fallbackBuy = config.fixedBuyRatePln;
    final fallbackSell = config.fixedSellRatePln;
    if (fallbackBuy == null && ranges.isEmpty) return;

    final userInfoId = config.userInfoId;
    final now = DateTime.now().toUtc();
    final hourStart = DateTime.utc(now.year, now.month, now.day, now.hour);

    for (int i = 0; i < 48; i++) {
      final ts = hourStart.add(Duration(hours: i));
      final hour = ts.hour;

      // Find matching range for this hour.
      PriceTimeRange? match;
      for (final r in ranges) {
        final covers = r.hourEnd <= r.hourStart
            ? hour >= r.hourStart || hour < r.hourEnd
            : hour >= r.hourStart && hour < r.hourEnd;
        if (covers) {
          match = r;
          break;
        }
      }

      final buyRate = match?.ratePln ?? fallbackBuy;
      final sellRate = match?.sellRatePln ?? fallbackSell;
      if (buyRate == null) continue;

      final existing = await EnergyPrice.db.findFirstRow(
        session,
        where: (t) =>
            t.timestamp.equals(ts) & t.userInfoId.equals(userInfoId),
      );

      if (existing != null) {
        existing.buyPrice = buyRate;
        existing.sellPrice = sellRate ?? 0.0;
        await EnergyPrice.db.updateRow(session, existing);
      } else {
        await EnergyPrice.db.insertRow(
          session,
          EnergyPrice(
            userInfoId: userInfoId,
            timestamp: ts,
            buyPrice: buyRate,
            sellPrice: sellRate ?? 0.0,
            currency: 'PLN',
          ),
        );
      }
    }
  }
}
