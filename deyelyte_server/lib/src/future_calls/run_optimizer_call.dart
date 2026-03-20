import 'package:serverpod/serverpod.dart';
import '../engine/battery_optimizer.dart';
import '../generated/protocol.dart';

/// Runs the battery optimizer every hour for all users that have Deye
/// configured, and upserts the resulting 24-frame schedule to the DB.
///
/// Phase 1 (data-gathering): writes to DB only — no commands sent to inverter.
/// Phase 2: will add sendSchedule() call here after the 7-day window check.
///
/// Self-rescheduling: reschedules itself at the end of each run.
class RunOptimizerCall extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableModel? object) async {
    final allCreds = await IntegrationCredentials.db.find(
      session,
      where: (t) => t.deyeDeviceSn.notEquals(null),
    );

    session.log('RunOptimizerCall: optimising ${allCreds.length} user(s)');

    for (final creds in allCreds) {
      await _runForUser(session, creds.userInfoId);
    }

    await session.serverpod.futureCallWithDelay(
      'RunOptimizerCall',
      null,
      const Duration(hours: 1),
    );
  }

  Future<void> _runForUser(Session session, int userInfoId) async {
    try {
      final optimizer = BatteryOptimizer(session, userInfoId: userInfoId);
      final frames = await optimizer.calculateSchedule();

      for (final frame in frames) {
        final existing = await OptimizationFrame.db.findFirstRow(
          session,
          where: (t) =>
              t.userInfoId.equals(userInfoId) & t.hour.equals(frame.hour),
        );
        if (existing != null) {
          await OptimizationFrame.db.updateRow(
              session, frame.copyWith(id: existing.id));
        } else {
          await OptimizationFrame.db.insertRow(session, frame);
        }
      }

      session.log(
          'RunOptimizerCall: ${frames.length} frames upserted for userInfoId $userInfoId');
    } catch (e) {
      session.log(
        'RunOptimizerCall: failed for userInfoId $userInfoId: $e',
        level: LogLevel.error,
      );
    }
  }
}
