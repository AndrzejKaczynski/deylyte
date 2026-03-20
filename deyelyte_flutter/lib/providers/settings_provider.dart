import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  const SettingsState({
    this.minSoc = 0.15,
    this.chargingEnabled = false,
    this.sellingEnabled = false,
    this.pvOnlySelling = true,
    this.maxBuyPrice = 0.0,
    this.minSellPrice,
    this.batteryCapacityKwh = 10.0,
    this.batteryCost,
    this.batteryLifecycles = 6000,
    this.maxDischargeRateKw = 5.0,
    this.deye = false,
    this.solcast = false,
    this.pstryk = false,
  });

  final double minSoc;
  final bool chargingEnabled;
  final bool sellingEnabled;

  // Only sell PV-generated energy (default). Set to false to enable grid arbitrage.
  final bool pvOnlySelling;

  final double maxBuyPrice;
  final double? minSellPrice;

  final double batteryCapacityKwh;
  final double? batteryCost;
  final int batteryLifecycles;
  final double maxDischargeRateKw;

  final bool deye;
  final bool solcast;
  final bool pstryk;

  SettingsState copyWith({
    double? minSoc,
    bool? chargingEnabled,
    bool? sellingEnabled,
    bool? pvOnlySelling,
    double? maxBuyPrice,
    Object? minSellPrice = _sentinel,
    double? batteryCapacityKwh,
    Object? batteryCost = _sentinel,
    int? batteryLifecycles,
    double? maxDischargeRateKw,
    bool? deye,
    bool? solcast,
    bool? pstryk,
  }) =>
      SettingsState(
        minSoc: minSoc ?? this.minSoc,
        chargingEnabled: chargingEnabled ?? this.chargingEnabled,
        sellingEnabled: sellingEnabled ?? this.sellingEnabled,
        pvOnlySelling: pvOnlySelling ?? this.pvOnlySelling,
        maxBuyPrice: maxBuyPrice ?? this.maxBuyPrice,
        minSellPrice: minSellPrice == _sentinel
            ? this.minSellPrice
            : minSellPrice as double?,
        batteryCapacityKwh: batteryCapacityKwh ?? this.batteryCapacityKwh,
        batteryCost: batteryCost == _sentinel
            ? this.batteryCost
            : batteryCost as double?,
        batteryLifecycles: batteryLifecycles ?? this.batteryLifecycles,
        maxDischargeRateKw: maxDischargeRateKw ?? this.maxDischargeRateKw,
        deye: deye ?? this.deye,
        solcast: solcast ?? this.solcast,
        pstryk: pstryk ?? this.pstryk,
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
  void setMinSellPrice(double? v) =>
      state = state.copyWith(minSellPrice: v);
  void setBatteryCapacityKwh(double v) =>
      state = state.copyWith(batteryCapacityKwh: v);
  void setBatteryCost(double? v) => state = state.copyWith(batteryCost: v);
  void setBatteryLifecycles(int v) =>
      state = state.copyWith(batteryLifecycles: v);
  void setMaxDischargeRateKw(double v) =>
      state = state.copyWith(maxDischargeRateKw: v);
  void setDeye(bool v) => state = state.copyWith(deye: v);
  void setSolcast(bool v) => state = state.copyWith(solcast: v);
  void setPstryk(bool v) => state = state.copyWith(pstryk: v);
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
