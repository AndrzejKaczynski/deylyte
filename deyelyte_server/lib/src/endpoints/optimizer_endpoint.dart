import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../engine/battery_optimizer.dart';

class OptimizerEndpoint extends Endpoint {
  /// Run the optimizer for the authenticated user, persist the 24-frame plan,
  /// and return it. Upserts by (userInfoId, hour) so repeated calls refresh
  /// the plan in place.
  Future<List<OptimizationFrame>> calculateAndStore(Session session) async {
    final userInfoId = _requireUserInfoId(session);
    final optimizer = BatteryOptimizer(session, userInfoId: userInfoId);
    final frames = await optimizer.calculateSchedule();

    for (var frame in frames) {
      final existing = await OptimizationFrame.db.findFirstRow(session,
          where: (t) =>
              t.userInfoId.equals(userInfoId) &
              t.hour.equals(frame.hour));
      if (existing != null) {
        final updated = frame.copyWith(id: existing.id);
        await OptimizationFrame.db.updateRow(session, updated);
      } else {
        await OptimizationFrame.db.insertRow(session, frame);
      }
    }

    return frames;
  }

  /// Return the stored 24-hour plan for the authenticated user, ordered by hour.
  Future<List<OptimizationFrame>> getSchedule(Session session) async {
    final userInfoId = _requireUserInfoId(session);
    final now = DateTime.now().toUtc();
    final hourStart =
        DateTime.utc(now.year, now.month, now.day, now.hour);

    return OptimizationFrame.db.find(session,
        where: (t) =>
            t.userInfoId.equals(userInfoId) & (t.hour >= hourStart),
        orderBy: (t) => t.hour);
  }

  /// Set the one-off top-up flag — the next plan recalculation will charge
  /// to 100% at the cheapest available hours.
  Future<void> requestTopUp(Session session) async {
    final userInfoId = _requireUserInfoId(session);
    final config = await _requireConfig(session, userInfoId);
    await AppConfig.db.updateRow(
        session, config.copyWith(topUpRequested: true));
  }

  /// Cancel a pending top-up request.
  Future<void> cancelTopUp(Session session) async {
    final userInfoId = _requireUserInfoId(session);
    final config = await _requireConfig(session, userInfoId);
    await AppConfig.db.updateRow(
        session, config.copyWith(topUpRequested: false));
  }

  /// Add an outage-reserve date. The optimizer will pre-charge cheaply to 100%
  /// before this date and block all selling on the day itself.
  Future<void> addOutageReserve(
      Session session, DateTime date, String? note) async {
    final userInfoId = _requireUserInfoId(session);
    final day = DateTime.utc(date.year, date.month, date.day);
    final existing = await OutageReserve.db.findFirstRow(session,
        where: (t) =>
            t.userInfoId.equals(userInfoId) & t.date.equals(day));
    if (existing == null) {
      await OutageReserve.db.insertRow(session,
          OutageReserve(userInfoId: userInfoId, date: day, note: note));
    }
  }

  /// Remove an outage-reserve date.
  Future<void> removeOutageReserve(Session session, DateTime date) async {
    final userInfoId = _requireUserInfoId(session);
    final day = DateTime.utc(date.year, date.month, date.day);
    final existing = await OutageReserve.db.findFirstRow(session,
        where: (t) =>
            t.userInfoId.equals(userInfoId) & t.date.equals(day));
    if (existing != null) {
      await OutageReserve.db.deleteRow(session, existing);
    }
  }

  /// List all upcoming outage-reserve dates for the authenticated user.
  Future<List<OutageReserve>> getOutageReserves(Session session) async {
    final userInfoId = _requireUserInfoId(session);
    final today = DateTime.now().toUtc();
    final todayDate = DateTime.utc(today.year, today.month, today.day);
    return OutageReserve.db.find(session,
        where: (t) =>
            t.userInfoId.equals(userInfoId) & (t.date >= todayDate),
        orderBy: (t) => t.date);
  }

  // ---------------------------------------------------------------------------

  int _requireUserInfoId(Session session) {
    final authInfo = session.authenticated;
    if (authInfo == null) throw Exception('Not authenticated');
    return int.parse(authInfo.userIdentifier);
  }

  Future<AppConfig> _requireConfig(Session session, int userInfoId) async {
    final config = await AppConfig.db.findFirstRow(session,
        where: (t) => t.userInfoId.equals(userInfoId));
    if (config == null) throw Exception('AppConfig not found');
    return config;
  }
}
