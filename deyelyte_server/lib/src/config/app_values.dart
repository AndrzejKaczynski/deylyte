import 'dart:io';

import 'package:yaml/yaml.dart';

/// Non-secret application configuration loaded from config/config.yaml.
/// Initialise once at startup via [AppValues.load] before using [AppValues.instance].
class AppValues {
  AppValues._({
    required this.vatRate,
    required this.rceSurchargesPln,
  });

  static AppValues? _instance;

  static AppValues get instance {
    assert(_instance != null, 'AppValues.load() must be called before accessing AppValues.instance');
    return _instance!;
  }

  /// Fractional VAT rate applied to electricity purchases (e.g. 0.23 for 23%).
  final double vatRate;

  /// Static per-kWh surcharges published annually by URE (OZE + kogeneracja + jakościowa).
  final double rceSurchargesPln;

  /// Loads config/config.yaml relative to the server working directory.
  /// Falls back to safe defaults if the file is missing (e.g. in tests).
  static Future<void> load({String runMode = 'development'}) async {
    const defaults = (vatRate: 0.23, rceSurchargesPln: 0.0328);

    final file = File('config/config.yaml');
    if (!file.existsSync()) {
      print('WARNING: config/config.yaml not found — using defaults');
      _instance = AppValues._(vatRate: defaults.vatRate, rceSurchargesPln: defaults.rceSurchargesPln);
      return;
    }

    final doc = loadYaml(await file.readAsString()) as YamlMap;
    final shared = (doc['shared'] as YamlMap?) ?? YamlMap();
    final modeSpecific = (doc[runMode] as YamlMap?) ?? YamlMap();

    // Mode-specific values override shared values.
    double read(String key, double fallback) {
      final v = modeSpecific[key] ?? shared[key];
      return (v as num?)?.toDouble() ?? fallback;
    }

    _instance = AppValues._(
      vatRate: read('vatRate', defaults.vatRate),
      rceSurchargesPln: read('rceSurchargesPln', defaults.rceSurchargesPln),
    );
  }
}
