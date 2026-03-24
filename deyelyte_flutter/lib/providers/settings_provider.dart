import 'package:deyelyte_client/deyelyte_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  const SettingsState({
    this.minSoc = 0.15,
    this.chargingEnabled = false,
    this.sellingEnabled = false,
    this.pvOnlySelling = true,
    this.planningOnly = true,
    this.maxBuyPrice = 0.0,
    this.minSellPrice,
    this.solcast = false,
    this.pstryk = false,
    this.cityName,
    this.priceSource = 'pstryk',
    this.fixedBuyRatePln,
    this.priceTimeRanges = const [],
    this.baselineChargingEnabled,
    this.baselineSellingEnabled,
    this.baselineMaxBuyPrice,
    this.baselineMinSellPrice,
    this.baselinePriceSource,
    this.isDirty = false,
  });

  final double minSoc;
  final bool chargingEnabled;
  final bool sellingEnabled;

  // Only sell PV-generated energy (default). Set to false to enable grid arbitrage.
  final bool pvOnlySelling;

  /// When true the optimizer still generates the full schedule but the add-on
  /// skips sending any commands to the inverter. Useful for reviewing the plan
  /// before enabling live control.
  final bool planningOnly;

  final double maxBuyPrice;
  final double? minSellPrice;

  // Integration enabled flags. Credentials (API keys, tokens) are stored
  // server-side in IntegrationCredentials table, keyed by userInfoId.

  /// Whether the Solcast PV forecast integration is enabled.
  final bool solcast;

  /// Whether the Pstryk energy price integration is enabled.
  final bool pstryk;

  final String? cityName;

  // ── Pricing ────────────────────────────────────────────────────────────────

  /// Active price source: 'pstryk' | 'rce' | 'fixed'.
  final String priceSource;

  /// Fixed buy rate (PLN/kWh). Used when priceSource = 'fixed' as fallback.
  final double? fixedBuyRatePln;

  /// User-defined price time ranges (for RCE distribution or fixed per-hour rates).
  final List<PriceTimeRange> priceTimeRanges;

  // ── Baseline snapshot ──────────────────────────────────────────────────────
  // Captured once when the user first enables live control (planningOnly → false).
  // Used as a safe restore point when reverting to planning mode.

  final bool? baselineChargingEnabled;
  final bool? baselineSellingEnabled;
  final double? baselineMaxBuyPrice;
  final double? baselineMinSellPrice;
  final String? baselinePriceSource;

  /// True when local state differs from the last saved/loaded server config.
  final bool isDirty;

  /// Whether a baseline has been captured (i.e. user has gone live at least once).
  bool get hasBaseline => baselineChargingEnabled != null;

  /// Whether the selected price source is fully configured and ready to use.
  /// Charging and selling should be disabled when this is false.
  bool get isPriceSourceReady {
    switch (priceSource) {
      case 'pstryk':
        return pstryk; // requires active integration
      case 'rce':
        return priceTimeRanges.isNotEmpty; // requires at least one distribution charge range
      case 'fixed':
      case 'manual':
        return fixedBuyRatePln != null;
      default:
        return false;
    }
  }

  SettingsState copyWith({
    double? minSoc,
    bool? chargingEnabled,
    bool? sellingEnabled,
    bool? pvOnlySelling,
    bool? planningOnly,
    double? maxBuyPrice,
    Object? minSellPrice = _sentinel,
    bool? solcast,
    bool? pstryk,
    Object? cityName = _sentinel,
    String? priceSource,
    Object? fixedBuyRatePln = _sentinel,
    List<PriceTimeRange>? priceTimeRanges,
    Object? baselineChargingEnabled = _sentinel,
    Object? baselineSellingEnabled = _sentinel,
    Object? baselineMaxBuyPrice = _sentinel,
    Object? baselineMinSellPrice = _sentinel,
    Object? baselinePriceSource = _sentinel,
    bool? isDirty,
  }) =>
      SettingsState(
        minSoc: minSoc ?? this.minSoc,
        chargingEnabled: chargingEnabled ?? this.chargingEnabled,
        sellingEnabled: sellingEnabled ?? this.sellingEnabled,
        pvOnlySelling: pvOnlySelling ?? this.pvOnlySelling,
        planningOnly: planningOnly ?? this.planningOnly,
        maxBuyPrice: maxBuyPrice ?? this.maxBuyPrice,
        minSellPrice: minSellPrice == _sentinel
            ? this.minSellPrice
            : minSellPrice as double?,
        solcast: solcast ?? this.solcast,
        pstryk: pstryk ?? this.pstryk,
        cityName: cityName == _sentinel ? this.cityName : cityName as String?,
        priceSource: priceSource ?? this.priceSource,
        fixedBuyRatePln: fixedBuyRatePln == _sentinel
            ? this.fixedBuyRatePln
            : fixedBuyRatePln as double?,
        priceTimeRanges: priceTimeRanges ?? this.priceTimeRanges,
        baselineChargingEnabled: baselineChargingEnabled == _sentinel
            ? this.baselineChargingEnabled
            : baselineChargingEnabled as bool?,
        baselineSellingEnabled: baselineSellingEnabled == _sentinel
            ? this.baselineSellingEnabled
            : baselineSellingEnabled as bool?,
        baselineMaxBuyPrice: baselineMaxBuyPrice == _sentinel
            ? this.baselineMaxBuyPrice
            : baselineMaxBuyPrice as double?,
        baselineMinSellPrice: baselineMinSellPrice == _sentinel
            ? this.baselineMinSellPrice
            : baselineMinSellPrice as double?,
        baselinePriceSource: baselinePriceSource == _sentinel
            ? this.baselinePriceSource
            : baselinePriceSource as String?,
        isDirty: isDirty ?? this.isDirty,
      );
}

// Sentinel for nullable copyWith fields
const Object _sentinel = Object();

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() => const SettingsState();

  void setMinSoc(double v) => state = state.copyWith(minSoc: v, isDirty: true);
  void setChargingEnabled(bool v) => state = state.copyWith(chargingEnabled: v, isDirty: true);
  void setSellingEnabled(bool v) => state = state.copyWith(sellingEnabled: v, isDirty: true);
  void setPvOnlySelling(bool v) => state = state.copyWith(pvOnlySelling: v, isDirty: true);
  void setMaxBuyPrice(double v) => state = state.copyWith(maxBuyPrice: v, isDirty: true);
  void setMinSellPrice(double? v) => state = state.copyWith(minSellPrice: v, isDirty: true);
  void setPlanningOnly(bool v) => state = state.copyWith(planningOnly: v, isDirty: true);
  void setSolcast(bool v) => state = state.copyWith(solcast: v, isDirty: true);
  void setPstryk(bool v) => state = state.copyWith(pstryk: v, isDirty: true);
  void setCityName(String? v) => state = state.copyWith(cityName: v, isDirty: true);
  void setPriceSource(String v) => state = state.copyWith(priceSource: v, isDirty: true);
  void setFixedBuyRatePln(double? v) =>
      state = state.copyWith(fixedBuyRatePln: v, isDirty: true);
  void setPriceTimeRanges(List<PriceTimeRange> v) =>
      state = state.copyWith(priceTimeRanges: v, isDirty: true);

  /// Load ranges from server on initial fetch — does not mark dirty.
  void loadPriceTimeRanges(List<PriceTimeRange> v) =>
      state = state.copyWith(priceTimeRanges: v);

  /// Set dirty flag (e.g. from hardware text controllers not tracked in state).
  void markDirty() => state = state.copyWith(isDirty: true);

  /// Reset dirty flag after a successful save.
  void markClean() => state = state.copyWith(isDirty: false);

  void loadIntegrationStatus(Map<String, bool> status) =>
      state = state.copyWith(
        solcast: status['solcast'] ?? state.solcast,
        pstryk: status['pstryk'] ?? state.pstryk,
      );

  void loadFrom(AppConfig c) => state = SettingsState(
        chargingEnabled: c.chargingEnabled,
        sellingEnabled: c.sellingEnabled,
        pvOnlySelling: c.pvOnlySelling,
        planningOnly: c.planningOnly,
        maxBuyPrice: c.alwaysChargePriceThreshold,
        minSellPrice: c.minSellPriceThreshold,
        minSoc: c.minSocPercentage ?? 0.15,
        cityName: c.cityName,
        priceSource: c.priceSource ?? 'pstryk',
        fixedBuyRatePln: c.fixedBuyRatePln,
        priceTimeRanges: state.priceTimeRanges,
        solcast: state.solcast, // managed separately via loadIntegrationStatus
        pstryk: state.pstryk,  // managed separately via loadIntegrationStatus
        baselineChargingEnabled: c.baselineChargingEnabled,
        baselineSellingEnabled: c.baselineSellingEnabled,
        baselineMaxBuyPrice: c.baselineMaxBuyPrice,
        baselineMinSellPrice: c.baselineMinSellPrice,
        baselinePriceSource: c.baselinePriceSource,
      );

  /// Revert charging/selling/pricing to the values captured at first live-enable.
  /// No-op if no baseline has been captured yet.
  void restoreToBaseline() {
    if (!state.hasBaseline) return;
    state = state.copyWith(
      chargingEnabled: state.baselineChargingEnabled,
      sellingEnabled: state.baselineSellingEnabled,
      maxBuyPrice: state.baselineMaxBuyPrice ?? state.maxBuyPrice,
      minSellPrice: state.baselineMinSellPrice,
      priceSource: state.baselinePriceSource ?? state.priceSource,
      planningOnly: true,
    );
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
