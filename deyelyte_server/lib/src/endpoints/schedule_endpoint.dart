import 'dart:convert';

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

  /// Returns OptimizationFrames for today (UTC day boundary).
  Future<List<OptimizationFrame>> getTodayFrames(Session session) async {
    final uid = _uid(session);
    if (uid == null) return [];
    final now = DateTime.now().toUtc();
    final dayStart = DateTime.utc(now.year, now.month, now.day);
    final dayEnd = dayStart.add(const Duration(hours: 24));
    return OptimizationFrame.db.find(
      session,
      where: (t) =>
          t.userInfoId.equals(uid) &
          t.hour.between(dayStart, dayEnd),
      orderBy: (t) => t.hour,
    );
  }

  /// Returns schedule events as a list of maps for the Flutter schedule screen.
  /// Stub: returns empty list until optimization engine is wired.
  Future<String> getEvents(Session session) async => jsonEncode([]);

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

  /// Returns schedule frames AND an offline fallback policy for the add-on.
  ///
  /// The add-on should cache this response locally. If the server is
  /// unreachable for more than [offlineGraceMinutes] (default 15), the add-on
  /// applies [offlineFallback] instead of the cached schedule — stopping all
  /// active charging/discharging commands to protect against expensive
  /// runaway behaviour. Default grace period is 120 minutes (2 missed hourly
  /// fetches) to avoid false positives from brief server restarts.
  ///
  /// [offlineFallback] keys:
  ///   - `chargingEnabled` (bool)  — whether to charge when offline
  ///   - `sellingEnabled`  (bool)  — whether to discharge/sell when offline
  ///   - `maxBuyPricePln`  (double) — max buy price to honour offline
  ///   - `priceSource`     (String) — pricing mode used for this fallback
  ///   - `offlineGraceMinutes` (int) — grace period before fallback activates
  Future<String> getScheduleWithFallback(
    Session session,
    String licenseKey,
  ) async {
    final license = await LicenseKey.db.findFirstRow(
      session,
      where: (t) => t.licenseKey.equals(licenseKey) & t.isActive.equals(true),
    );
    if (license == null) {
      return jsonEncode({'frames': [], 'offlineFallback': _safeDefaults()});
    }

    final now = DateTime.now().toUtc();
    final hourStart = DateTime.utc(now.year, now.month, now.day, now.hour);

    final frames = await OptimizationFrame.db.find(
      session,
      where: (t) =>
          t.userInfoId.equals(license.userId) & (t.hour >= hourStart),
      orderBy: (t) => t.hour,
    );

    final config = await AppConfig.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(license.userId),
    );

    // Prefer baseline values (captured at first live-enable) for the fallback
    // — they represent the conservative settings the user started with.
    final fallback = config == null
        ? _safeDefaults()
        : {
            'chargingEnabled':
                config.baselineChargingEnabled ?? false,
            'sellingEnabled':
                config.baselineSellingEnabled ?? false,
            'maxBuyPricePln':
                config.baselineMaxBuyPrice ?? config.alwaysChargePriceThreshold,
            'priceSource':
                config.baselinePriceSource ?? config.priceSource ?? 'fixed',
            'offlineGraceMinutes': 120,
          };

    return jsonEncode({
      'frames': frames.map((f) => f.toJson()).toList(),
      'offlineFallback': fallback,
      // Stable per-device offset (0–59 min) so all add-ons don't hit the
      // server simultaneously at the top of every hour.
      'fetchOffsetMinutes': _fetchOffset(licenseKey),
    });
  }

  /// Derives a stable 0–59 minute fetch offset from the license key so
  /// requests are spread evenly across the hour (deterministic jitter).
  /// The same key always gets the same offset — no state needed.
  int _fetchOffset(String licenseKey) {
    // Simple djb2-style hash over the UTF-8 bytes, then mod 60.
    final bytes = utf8.encode(licenseKey);
    var hash = 5381;
    for (final b in bytes) {
      hash = ((hash << 5) + hash + b) & 0x7fffffff;
    }
    return hash % 60;
  }

  /// Conservative safe defaults used when no config exists yet.
  Map<String, dynamic> _safeDefaults() => {
        'chargingEnabled': false,
        'sellingEnabled': false,
        'maxBuyPricePln': 0.0,
        'priceSource': 'fixed',
        'offlineGraceMinutes': 120,
      };

  int? _uid(Session session) {
    final auth = session.authenticated;
    if (auth == null) return null;
    return int.tryParse(auth.userIdentifier);
  }
}
