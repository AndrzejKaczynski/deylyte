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
    this.batteryCapacityKwh = 10.0,
    this.batteryCost,
    this.batteryLifecycles = 6000,
    this.maxDischargeRateKw = 5.0,
    this.maxChargeRateKw,
    this.gridConnectionKw,
    this.solcast = false,
    this.pstryk = false,
    this.cityName,
    this.priceSource = 'pstryk',
    this.fixedBuyRatePln,
    this.fixedSellRatePln,
    this.priceTimeRanges = const [],
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

  final double batteryCapacityKwh;
  final double? batteryCost;
  final int batteryLifecycles;
  final double maxDischargeRateKw;
  final double? maxChargeRateKw;
  final double? gridConnectionKw;

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

  /// Fixed sell rate (PLN/kWh). Used when priceSource = 'fixed' as fallback.
  final double? fixedSellRatePln;

  /// User-defined price time ranges (for RCE distribution or fixed per-hour rates).
  final List<PriceTimeRange> priceTimeRanges;

  SettingsState copyWith({
    double? minSoc,
    bool? chargingEnabled,
    bool? sellingEnabled,
    bool? pvOnlySelling,
    bool? planningOnly,
    double? maxBuyPrice,
    Object? minSellPrice = _sentinel,
    double? batteryCapacityKwh,
    Object? batteryCost = _sentinel,
    int? batteryLifecycles,
    double? maxDischargeRateKw,
    Object? maxChargeRateKw = _sentinel,
    Object? gridConnectionKw = _sentinel,
    bool? solcast,
    bool? pstryk,
    Object? cityName = _sentinel,
    String? priceSource,
    Object? fixedBuyRatePln = _sentinel,
    Object? fixedSellRatePln = _sentinel,
    List<PriceTimeRange>? priceTimeRanges,
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
        batteryCapacityKwh: batteryCapacityKwh ?? this.batteryCapacityKwh,
        batteryCost:
            batteryCost == _sentinel ? this.batteryCost : batteryCost as double?,
        batteryLifecycles: batteryLifecycles ?? this.batteryLifecycles,
        maxDischargeRateKw: maxDischargeRateKw ?? this.maxDischargeRateKw,
        maxChargeRateKw: maxChargeRateKw == _sentinel
            ? this.maxChargeRateKw
            : maxChargeRateKw as double?,
        gridConnectionKw: gridConnectionKw == _sentinel
            ? this.gridConnectionKw
            : gridConnectionKw as double?,
        solcast: solcast ?? this.solcast,
        pstryk: pstryk ?? this.pstryk,
        cityName: cityName == _sentinel ? this.cityName : cityName as String?,
        priceSource: priceSource ?? this.priceSource,
        fixedBuyRatePln: fixedBuyRatePln == _sentinel
            ? this.fixedBuyRatePln
            : fixedBuyRatePln as double?,
        fixedSellRatePln: fixedSellRatePln == _sentinel
            ? this.fixedSellRatePln
            : fixedSellRatePln as double?,
        priceTimeRanges: priceTimeRanges ?? this.priceTimeRanges,
      );
}

// Sentinel for nullable copyWith fields
const Object _sentinel = Object();

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() => const SettingsState();

  void setMinSoc(double v) => state = state.copyWith(minSoc: v);
  void setChargingEnabled(bool v) => state = state.copyWith(chargingEnabled: v);
  void setSellingEnabled(bool v) => state = state.copyWith(sellingEnabled: v);
  void setPvOnlySelling(bool v) => state = state.copyWith(pvOnlySelling: v);
  void setMaxBuyPrice(double v) => state = state.copyWith(maxBuyPrice: v);
  void setMinSellPrice(double? v) => state = state.copyWith(minSellPrice: v);
  void setBatteryCapacityKwh(double v) =>
      state = state.copyWith(batteryCapacityKwh: v);
  void setBatteryCost(double? v) => state = state.copyWith(batteryCost: v);
  void setBatteryLifecycles(int v) =>
      state = state.copyWith(batteryLifecycles: v);
  void setMaxDischargeRateKw(double v) =>
      state = state.copyWith(maxDischargeRateKw: v);
  void setMaxChargeRateKw(double? v) =>
      state = state.copyWith(maxChargeRateKw: v);
  void setGridConnectionKw(double? v) =>
      state = state.copyWith(gridConnectionKw: v);
  void setPlanningOnly(bool v) => state = state.copyWith(planningOnly: v);
  void setSolcast(bool v) => state = state.copyWith(solcast: v);
  void setPstryk(bool v) => state = state.copyWith(pstryk: v);
  void setCityName(String? v) => state = state.copyWith(cityName: v);
  void setPriceSource(String v) => state = state.copyWith(priceSource: v);
  void setFixedBuyRatePln(double? v) =>
      state = state.copyWith(fixedBuyRatePln: v);
  void setFixedSellRatePln(double? v) =>
      state = state.copyWith(fixedSellRatePln: v);
  void setPriceTimeRanges(List<PriceTimeRange> v) =>
      state = state.copyWith(priceTimeRanges: v);

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
        batteryCapacityKwh: c.batteryCapacityKwh ?? 10.0,
        batteryCost: c.batteryCost,
        batteryLifecycles: c.batteryLifecycles ?? 6000,
        minSoc: c.minSocPercentage ?? 0.15,
        maxDischargeRateKw: c.maxDischargeRateKw ?? 5.0,
        maxChargeRateKw: c.maxChargeRateKw,
        gridConnectionKw: c.gridConnectionKw,
        cityName: c.cityName,
        priceSource: c.priceSource ?? 'pstryk',
        fixedBuyRatePln: c.fixedBuyRatePln,
        fixedSellRatePln: c.fixedSellRatePln,
        priceTimeRanges: state.priceTimeRanges,
        pstryk: c.pstrykEnabled,
      );
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
