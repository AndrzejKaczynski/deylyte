/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class AppConfig implements _i1.SerializableModel {
  AppConfig._({
    this.id,
    required this.userInfoId,
    this.dataGatheringSince,
    required this.chargingEnabled,
    required this.sellingEnabled,
    required this.pvOnlySelling,
    required this.topUpRequested,
    required this.alwaysChargePriceThreshold,
    this.minSellPriceThreshold,
    this.batteryCapacityKwh,
    this.batteryCost,
    this.batteryLifecycles,
    this.minSocPercentage,
    this.maxDischargeRateKw,
    this.maxChargeRateKw,
    this.gridConnectionKw,
    this.cityName,
    this.latitude,
    this.longitude,
    this.priceSource,
    this.fixedBuyRatePln,
    this.fixedSellRatePln,
    required this.pstrykEnabled,
  });

  factory AppConfig({
    int? id,
    required int userInfoId,
    DateTime? dataGatheringSince,
    required bool chargingEnabled,
    required bool sellingEnabled,
    required bool pvOnlySelling,
    required bool topUpRequested,
    required double alwaysChargePriceThreshold,
    double? minSellPriceThreshold,
    double? batteryCapacityKwh,
    double? batteryCost,
    int? batteryLifecycles,
    double? minSocPercentage,
    double? maxDischargeRateKw,
    double? maxChargeRateKw,
    double? gridConnectionKw,
    String? cityName,
    double? latitude,
    double? longitude,
    String? priceSource,
    double? fixedBuyRatePln,
    double? fixedSellRatePln,
    required bool pstrykEnabled,
  }) = _AppConfigImpl;

  factory AppConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppConfig(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      dataGatheringSince: jsonSerialization['dataGatheringSince'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['dataGatheringSince'],
            ),
      chargingEnabled: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['chargingEnabled'],
      ),
      sellingEnabled: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['sellingEnabled'],
      ),
      pvOnlySelling: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['pvOnlySelling'],
      ),
      topUpRequested: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['topUpRequested'],
      ),
      alwaysChargePriceThreshold:
          (jsonSerialization['alwaysChargePriceThreshold'] as num).toDouble(),
      minSellPriceThreshold:
          (jsonSerialization['minSellPriceThreshold'] as num?)?.toDouble(),
      batteryCapacityKwh: (jsonSerialization['batteryCapacityKwh'] as num?)
          ?.toDouble(),
      batteryCost: (jsonSerialization['batteryCost'] as num?)?.toDouble(),
      batteryLifecycles: jsonSerialization['batteryLifecycles'] as int?,
      minSocPercentage: (jsonSerialization['minSocPercentage'] as num?)
          ?.toDouble(),
      maxDischargeRateKw: (jsonSerialization['maxDischargeRateKw'] as num?)
          ?.toDouble(),
      maxChargeRateKw: (jsonSerialization['maxChargeRateKw'] as num?)
          ?.toDouble(),
      gridConnectionKw: (jsonSerialization['gridConnectionKw'] as num?)
          ?.toDouble(),
      cityName: jsonSerialization['cityName'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      priceSource: jsonSerialization['priceSource'] as String?,
      fixedBuyRatePln: (jsonSerialization['fixedBuyRatePln'] as num?)
          ?.toDouble(),
      fixedSellRatePln: (jsonSerialization['fixedSellRatePln'] as num?)
          ?.toDouble(),
      pstrykEnabled: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['pstrykEnabled'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userInfoId;

  DateTime? dataGatheringSince;

  bool chargingEnabled;

  bool sellingEnabled;

  bool pvOnlySelling;

  bool topUpRequested;

  double alwaysChargePriceThreshold;

  double? minSellPriceThreshold;

  double? batteryCapacityKwh;

  double? batteryCost;

  int? batteryLifecycles;

  double? minSocPercentage;

  double? maxDischargeRateKw;

  double? maxChargeRateKw;

  double? gridConnectionKw;

  String? cityName;

  double? latitude;

  double? longitude;

  String? priceSource;

  double? fixedBuyRatePln;

  double? fixedSellRatePln;

  bool pstrykEnabled;

  /// Returns a shallow copy of this [AppConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppConfig copyWith({
    int? id,
    int? userInfoId,
    DateTime? dataGatheringSince,
    bool? chargingEnabled,
    bool? sellingEnabled,
    bool? pvOnlySelling,
    bool? topUpRequested,
    double? alwaysChargePriceThreshold,
    double? minSellPriceThreshold,
    double? batteryCapacityKwh,
    double? batteryCost,
    int? batteryLifecycles,
    double? minSocPercentage,
    double? maxDischargeRateKw,
    double? maxChargeRateKw,
    double? gridConnectionKw,
    String? cityName,
    double? latitude,
    double? longitude,
    String? priceSource,
    double? fixedBuyRatePln,
    double? fixedSellRatePln,
    bool? pstrykEnabled,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppConfig',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      if (dataGatheringSince != null)
        'dataGatheringSince': dataGatheringSince?.toJson(),
      'chargingEnabled': chargingEnabled,
      'sellingEnabled': sellingEnabled,
      'pvOnlySelling': pvOnlySelling,
      'topUpRequested': topUpRequested,
      'alwaysChargePriceThreshold': alwaysChargePriceThreshold,
      if (minSellPriceThreshold != null)
        'minSellPriceThreshold': minSellPriceThreshold,
      if (batteryCapacityKwh != null) 'batteryCapacityKwh': batteryCapacityKwh,
      if (batteryCost != null) 'batteryCost': batteryCost,
      if (batteryLifecycles != null) 'batteryLifecycles': batteryLifecycles,
      if (minSocPercentage != null) 'minSocPercentage': minSocPercentage,
      if (maxDischargeRateKw != null) 'maxDischargeRateKw': maxDischargeRateKw,
      if (maxChargeRateKw != null) 'maxChargeRateKw': maxChargeRateKw,
      if (gridConnectionKw != null) 'gridConnectionKw': gridConnectionKw,
      if (cityName != null) 'cityName': cityName,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (priceSource != null) 'priceSource': priceSource,
      if (fixedBuyRatePln != null) 'fixedBuyRatePln': fixedBuyRatePln,
      if (fixedSellRatePln != null) 'fixedSellRatePln': fixedSellRatePln,
      'pstrykEnabled': pstrykEnabled,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppConfigImpl extends AppConfig {
  _AppConfigImpl({
    int? id,
    required int userInfoId,
    DateTime? dataGatheringSince,
    required bool chargingEnabled,
    required bool sellingEnabled,
    required bool pvOnlySelling,
    required bool topUpRequested,
    required double alwaysChargePriceThreshold,
    double? minSellPriceThreshold,
    double? batteryCapacityKwh,
    double? batteryCost,
    int? batteryLifecycles,
    double? minSocPercentage,
    double? maxDischargeRateKw,
    double? maxChargeRateKw,
    double? gridConnectionKw,
    String? cityName,
    double? latitude,
    double? longitude,
    String? priceSource,
    double? fixedBuyRatePln,
    double? fixedSellRatePln,
    required bool pstrykEnabled,
  }) : super._(
         id: id,
         userInfoId: userInfoId,
         dataGatheringSince: dataGatheringSince,
         chargingEnabled: chargingEnabled,
         sellingEnabled: sellingEnabled,
         pvOnlySelling: pvOnlySelling,
         topUpRequested: topUpRequested,
         alwaysChargePriceThreshold: alwaysChargePriceThreshold,
         minSellPriceThreshold: minSellPriceThreshold,
         batteryCapacityKwh: batteryCapacityKwh,
         batteryCost: batteryCost,
         batteryLifecycles: batteryLifecycles,
         minSocPercentage: minSocPercentage,
         maxDischargeRateKw: maxDischargeRateKw,
         maxChargeRateKw: maxChargeRateKw,
         gridConnectionKw: gridConnectionKw,
         cityName: cityName,
         latitude: latitude,
         longitude: longitude,
         priceSource: priceSource,
         fixedBuyRatePln: fixedBuyRatePln,
         fixedSellRatePln: fixedSellRatePln,
         pstrykEnabled: pstrykEnabled,
       );

  /// Returns a shallow copy of this [AppConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppConfig copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    Object? dataGatheringSince = _Undefined,
    bool? chargingEnabled,
    bool? sellingEnabled,
    bool? pvOnlySelling,
    bool? topUpRequested,
    double? alwaysChargePriceThreshold,
    Object? minSellPriceThreshold = _Undefined,
    Object? batteryCapacityKwh = _Undefined,
    Object? batteryCost = _Undefined,
    Object? batteryLifecycles = _Undefined,
    Object? minSocPercentage = _Undefined,
    Object? maxDischargeRateKw = _Undefined,
    Object? maxChargeRateKw = _Undefined,
    Object? gridConnectionKw = _Undefined,
    Object? cityName = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? priceSource = _Undefined,
    Object? fixedBuyRatePln = _Undefined,
    Object? fixedSellRatePln = _Undefined,
    bool? pstrykEnabled,
  }) {
    return AppConfig(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      dataGatheringSince: dataGatheringSince is DateTime?
          ? dataGatheringSince
          : this.dataGatheringSince,
      chargingEnabled: chargingEnabled ?? this.chargingEnabled,
      sellingEnabled: sellingEnabled ?? this.sellingEnabled,
      pvOnlySelling: pvOnlySelling ?? this.pvOnlySelling,
      topUpRequested: topUpRequested ?? this.topUpRequested,
      alwaysChargePriceThreshold:
          alwaysChargePriceThreshold ?? this.alwaysChargePriceThreshold,
      minSellPriceThreshold: minSellPriceThreshold is double?
          ? minSellPriceThreshold
          : this.minSellPriceThreshold,
      batteryCapacityKwh: batteryCapacityKwh is double?
          ? batteryCapacityKwh
          : this.batteryCapacityKwh,
      batteryCost: batteryCost is double? ? batteryCost : this.batteryCost,
      batteryLifecycles: batteryLifecycles is int?
          ? batteryLifecycles
          : this.batteryLifecycles,
      minSocPercentage: minSocPercentage is double?
          ? minSocPercentage
          : this.minSocPercentage,
      maxDischargeRateKw: maxDischargeRateKw is double?
          ? maxDischargeRateKw
          : this.maxDischargeRateKw,
      maxChargeRateKw: maxChargeRateKw is double?
          ? maxChargeRateKw
          : this.maxChargeRateKw,
      gridConnectionKw: gridConnectionKw is double?
          ? gridConnectionKw
          : this.gridConnectionKw,
      cityName: cityName is String? ? cityName : this.cityName,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      priceSource: priceSource is String? ? priceSource : this.priceSource,
      fixedBuyRatePln: fixedBuyRatePln is double?
          ? fixedBuyRatePln
          : this.fixedBuyRatePln,
      fixedSellRatePln: fixedSellRatePln is double?
          ? fixedSellRatePln
          : this.fixedSellRatePln,
      pstrykEnabled: pstrykEnabled ?? this.pstrykEnabled,
    );
  }
}
