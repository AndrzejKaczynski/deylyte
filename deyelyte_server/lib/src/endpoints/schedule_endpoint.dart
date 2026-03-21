import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Serves optimization schedules to the Flutter app and the HA add-on.
class ScheduleEndpoint extends Endpoint {
  @override
  bool get requireLogin => false; // login enforced per-method

  // ── Flutter facing (requires login) ──────────────────────────────────────

  /// Returns the OptimizationFrame for the current hour, or null.
  Future<OptimizationFrame?> getCurrent(Session session) async {
    final uid = _uid(session);
    if (uid == null) return null;

    final now = DateTime.now().toUtc();
    final hourStart = DateTime.utc(now.year, now.month, now.day, now.hour);

    return OptimizationFrame.db.findFirstRow(
      session,
      where: (t) =>
          t.userInfoId.equals(uid) & t.hour.equals(hourStart),
    );
  }

  /// Returns all upcoming OptimizationFrames (current hour onwards).
  Future<List<OptimizationFrame>> getForecast(Session session) async {
    final uid = _uid(session);
    if (uid == null) return [];

    final now = DateTime.now().toUtc();
    final hourStart = DateTime.utc(now.year, now.month, now.day, now.hour);

    return OptimizationFrame.db.find(
      session,
      where: (t) =>
          t.userInfoId.equals(uid) & (t.hour >= hourStart),
      orderBy: (t) => t.hour,
    );
  }

  /// Returns schedule events as a list of maps for the Flutter schedule screen.
  /// Stub: returns empty list until optimization engine is wired.
  Future<List<Map<String, dynamic>>> getEvents(Session session) async => [];

  // ── Add-on facing (license key auth, no user session) ────────────────────

  /// Returns upcoming OptimizationFrames for the user associated with
  /// [licenseKey]. Returns an empty list on invalid license.
  Future<List<OptimizationFrame>> getSchedule(
    Session session,
    String licenseKey,
  ) async {
    final license = await LicenseKey.db.findFirstRow(
      session,
      where: (t) => t.licenseKey.equals(licenseKey) & t.isActive.equals(true),
    );
    if (license == null) return [];

    final now = DateTime.now().toUtc();
    final hourStart = DateTime.utc(now.year, now.month, now.day, now.hour);

    return OptimizationFrame.db.find(
      session,
      where: (t) =>
          t.userInfoId.equals(license.userId) & (t.hour >= hourStart),
      orderBy: (t) => t.hour,
    );
  }

  int? _uid(Session session) {
    final auth = session.authenticated;
    if (auth == null) return null;
    return int.tryParse(auth.userIdentifier);
  }
}
