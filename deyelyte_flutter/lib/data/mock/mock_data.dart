import 'package:deyelyte_client/deyelyte_client.dart';

// Realistic mock values matching a Deye SUN inverter midday scenario.
// Used when USE_MOCK_DATA=true (scripts/run_mock.sh).

final mockLatestTelemetry = DeviceTelemetry(
  deviceId: 'mock-device-sha256',
  userId: 1,
  timestamp: DateTime.now().toUtc(),
  batterySOC: 84.0,
  pvPowerW: 3200.0,
  gridPowerW: 0.0,
  loadPowerW: 1800.0,
  batteryPowerW: -1400.0, // negative = charging
);

final List<DeviceTelemetry> mockHistory = List.generate(24, (i) {
  final ts = DateTime.now().toUtc().subtract(Duration(hours: 23 - i));
  return DeviceTelemetry(
    deviceId: 'mock-device-sha256',
    userId: 1,
    timestamp: ts,
    batterySOC: 40.0 + (i * 2.0).clamp(0, 44),
    pvPowerW: i >= 7 && i <= 18 ? (i <= 12 ? i * 270.0 : (18 - i) * 270.0) : 0,
    gridPowerW: 0.0,
    loadPowerW: 1500.0 + (i % 3) * 200.0,
    batteryPowerW: -800.0,
  );
});

final Map<String, dynamic> mockDeviceStatus = {
  'connected': true,
  'lastSeenAt': DateTime.now().toUtc().toIso8601String(),
  'inverterReachable': true,
};

final Map<String, dynamic> mockHistorySummary = {
  'priceVelocity': 0.54,
  'netRevenuePln': 142.80,
  'peakLoadKw': 4.2,
  'greenMixPercent': 88.0,
  'totalSavingsPln': 210.40,
  'storageEfficiencyPercent': 94.0,
  'peakDemandKw': 4.2,
};

final List<Map<String, dynamic>> mockHistoryEvents = [
  {
    'type': 'feed_in',
    'label': 'Feed-in Export',
    'valuePln': 18.40,
    'timestamp': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
  },
  {
    'type': 'charge',
    'label': 'Smart Charging',
    'valuePln': -4.20,
    'timestamp': DateTime.now().subtract(const Duration(hours: 8)).toIso8601String(),
  },
  {
    'type': 'peak_shaving',
    'label': 'Peak Shaving',
    'valuePln': 6.80,
    'timestamp': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
  },
];
