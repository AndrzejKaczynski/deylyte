import 'dart:convert';

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

/// Add-on connection status + inverter model info. Refreshed on demand.
final addonStatusProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return ref.read(deviceRepositoryProvider).getStatus();
});

/// Supported inverter models from the server catalogue.
/// Each entry: { 'modelId': String, 'displayName': String }.
final inverterModelsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.read(deviceRepositoryProvider).listModels();
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

/// PV energy produced today (kWh), integrated from telemetry samples since local midnight.
final dailySolarYieldProvider = FutureProvider<double?>((ref) async {
  final samples = await ref.watch(telemetryHistory24hProvider.future);
  if (samples.isEmpty) return null;
  final now = DateTime.now();
  final midnight = DateTime(now.year, now.month, now.day);
  final today = samples.where((s) => s.timestamp.toLocal().isAfter(midnight)).toList();
  if (today.length < 2) return null;
  double kwh = 0;
  for (int i = 1; i < today.length; i++) {
    final dt = today[i].timestamp.difference(today[i - 1].timestamp).inSeconds / 3600.0;
    final avgW = (today[i].pvPowerW + today[i - 1].pvPowerW) / 2;
    kwh += avgW * dt / 1000.0;
  }
  return kwh < 0 ? 0 : kwh;
});

/// The authenticated user's active license tier ('beta_free' | 'basic' | 'pro' | null).
final userLicenseTierProvider = FutureProvider<String?>((ref) async {
  try {
    final raw = await ref.read(clientProvider).license.getUserLicense();
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return data['tier'] as String?;
  } catch (_) {
    return null;
  }
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
int rangeDays(int index) => const [7, 30, 60, 90][index];

/// Maximum history days the current user's tier allows.
/// Falls back to 7 if the tier config has not been loaded yet.
final userHistoryDurationDaysProvider = FutureProvider<int>((ref) async {
  try {
    final raw = await ref.read(clientProvider).license.getUserLicense();
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return (data['historyDurationDays'] as int?) ?? 7;
  } catch (_) {
    return 7;
  }
});

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
