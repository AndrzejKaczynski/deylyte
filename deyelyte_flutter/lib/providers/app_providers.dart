import 'package:deyelyte_client/deyelyte_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

import '../config/app_config.dart';
import '../data/mock/mock_device_repository.dart';
import '../data/mock/mock_history_repository.dart';
import '../data/mock/mock_license_repository.dart';
import '../data/mock/mock_schedule_repository.dart';
import '../data/mock/mock_telemetry_repository.dart';
import '../data/repositories/device_repository.dart';
import '../data/repositories/history_repository.dart';
import '../data/repositories/license_repository.dart';
import '../data/repositories/schedule_repository.dart';
import '../data/repositories/telemetry_repository.dart';
import '../data/serverpod/serverpod_device_repository.dart';
import '../data/serverpod/serverpod_history_repository.dart';
import '../data/serverpod/serverpod_license_repository.dart';
import '../data/serverpod/serverpod_schedule_repository.dart';
import '../data/serverpod/serverpod_telemetry_repository.dart';

// ── Core infrastructure ───────────────────────────────────────────────────────

/// Serverpod HTTP client — overridden in main() via ProviderScope.
final clientProvider = Provider<Client>(
  (ref) => throw UnimplementedError('clientProvider not overridden'),
);

/// Serverpod SessionManager (ChangeNotifier) — overridden in main() via ProviderScope.
/// Watching this provider re-builds widgets whenever auth state changes.
final sessionManagerProvider = ChangeNotifierProvider<SessionManager>(
  (ref) => throw UnimplementedError('sessionManagerProvider not overridden'),
);

// ── Repository providers (swap real ↔ mock via Env.useMockData) ───────────────

final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  if (Env.useMockData) return MockDeviceRepository();
  return ServerpodDeviceRepository(ref.read(clientProvider));
});

final telemetryRepositoryProvider = Provider<TelemetryRepository>((ref) {
  if (Env.useMockData) return MockTelemetryRepository();
  return ServerpodTelemetryRepository(ref.read(clientProvider));
});

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  if (Env.useMockData) return MockScheduleRepository();
  return ServerpodScheduleRepository(ref.read(clientProvider));
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  if (Env.useMockData) return MockHistoryRepository();
  return ServerpodHistoryRepository(ref.read(clientProvider));
});

final licenseRepositoryProvider = Provider<LicenseRepository>((ref) {
  if (Env.useMockData) return MockLicenseRepository();
  return ServerpodLicenseRepository(ref.read(clientProvider));
});

// ── Data providers ────────────────────────────────────────────────────────────

/// Selected date range index for HistoryScreen (0=7d, 1=30d, 2=90d).
final historyRangeProvider = StateProvider<int>((ref) => 1);

/// Loads the user's AppConfig from the server. Null if the user has no config yet.
class AppConfigNotifier extends AsyncNotifier<AppConfig?> {
  @override
  Future<AppConfig?> build() async {
    return ref.read(clientProvider).appConfig.getConfig();
  }

  Future<void> save(AppConfig config) async {
    await ref.read(clientProvider).appConfig.saveConfig(config);
  }
}

final appConfigProvider =
    AsyncNotifierProvider<AppConfigNotifier, AppConfig?>(AppConfigNotifier.new);

/// Loads integration-enabled flags from server (stored in IntegrationCredentials).
/// Note: 'deye' key is removed — add-on connection is tracked via addonStatusProvider.
final integrationStatusProvider = FutureProvider<Map<String, bool>>((ref) async {
  return ref.read(clientProvider).credentials.getStatus();
});

/// Loads the user's price time ranges from the server.
final priceTimeRangesProvider = FutureProvider<List<PriceTimeRange>>((ref) async {
  return ref.read(clientProvider).priceTimeRanges.getTimeRanges();
});

// ── Device / add-on status ────────────────────────────────────────────────────

/// Add-on connection status. Refreshed on demand (invalidate to re-fetch).
final addonStatusProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return ref.read(deviceRepositoryProvider).getStatus();
});

// ── Telemetry ─────────────────────────────────────────────────────────────────

/// Most recent telemetry snapshot. Null when add-on hasn't sent data yet.
final latestTelemetryProvider = FutureProvider<DeviceTelemetry?>((ref) {
  return ref.read(telemetryRepositoryProvider).getLatest();
});

/// Last 24 hours of telemetry, ordered oldest-first.
final telemetryHistory24hProvider = FutureProvider<List<DeviceTelemetry>>((ref) {
  return ref.read(telemetryRepositoryProvider).getHistory(24);
});

// ── Schedule ──────────────────────────────────────────────────────────────────

/// OptimizationFrame for the current hour. Null when no schedule exists yet.
final currentScheduleProvider = FutureProvider<OptimizationFrame?>((ref) {
  return ref.read(scheduleRepositoryProvider).getCurrent();
});

/// All upcoming OptimizationFrames (today onwards).
final scheduleForecastProvider = FutureProvider<List<OptimizationFrame>>((ref) {
  return ref.read(scheduleRepositoryProvider).getForecast();
});

/// Schedule events for the Power Allocation Flow + Upcoming Events cards.
final scheduleEventsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.read(scheduleRepositoryProvider).getEvents();
});

// ── History ───────────────────────────────────────────────────────────────────

/// Helper to map historyRangeProvider index to days.
int rangeDays(int index) => const [7, 30, 90][index];

/// History summary metrics. Re-fetches when range changes.
final historySummaryProvider =
    FutureProvider.family<Map<String, dynamic>, int>((ref, days) {
  return ref.read(historyRepositoryProvider).getSummary(days);
});

/// History events. Re-fetches when range changes.
final historyEventsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, int>((ref, days) {
  return ref.read(historyRepositoryProvider).getEvents(days);
});
