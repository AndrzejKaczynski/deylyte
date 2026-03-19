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
    required this.workModeEnabled,
    required this.alwaysChargePriceThreshold,
    this.minSellPriceThreshold,
    this.batteryCapacityKwh,
    this.batteryCost,
    this.batteryLifecycles,
    this.minSocPercentage,
  });

  factory AppConfig({
    int? id,
    required int userInfoId,
    DateTime? dataGatheringSince,
    required bool workModeEnabled,
    required double alwaysChargePriceThreshold,
    double? minSellPriceThreshold,
    double? batteryCapacityKwh,
    double? batteryCost,
    int? batteryLifecycles,
    double? minSocPercentage,
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
      workModeEnabled: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['workModeEnabled'],
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
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userInfoId;

  DateTime? dataGatheringSince;

  bool workModeEnabled;

  double alwaysChargePriceThreshold;

  double? minSellPriceThreshold;

  double? batteryCapacityKwh;

  double? batteryCost;

  int? batteryLifecycles;

  double? minSocPercentage;

  /// Returns a shallow copy of this [AppConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppConfig copyWith({
    int? id,
    int? userInfoId,
    DateTime? dataGatheringSince,
    bool? workModeEnabled,
    double? alwaysChargePriceThreshold,
    double? minSellPriceThreshold,
    double? batteryCapacityKwh,
    double? batteryCost,
    int? batteryLifecycles,
    double? minSocPercentage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppConfig',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      if (dataGatheringSince != null)
        'dataGatheringSince': dataGatheringSince?.toJson(),
      'workModeEnabled': workModeEnabled,
      'alwaysChargePriceThreshold': alwaysChargePriceThreshold,
      if (minSellPriceThreshold != null)
        'minSellPriceThreshold': minSellPriceThreshold,
      if (batteryCapacityKwh != null) 'batteryCapacityKwh': batteryCapacityKwh,
      if (batteryCost != null) 'batteryCost': batteryCost,
      if (batteryLifecycles != null) 'batteryLifecycles': batteryLifecycles,
      if (minSocPercentage != null) 'minSocPercentage': minSocPercentage,
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
    required bool workModeEnabled,
    required double alwaysChargePriceThreshold,
    double? minSellPriceThreshold,
    double? batteryCapacityKwh,
    double? batteryCost,
    int? batteryLifecycles,
    double? minSocPercentage,
  }) : super._(
         id: id,
         userInfoId: userInfoId,
         dataGatheringSince: dataGatheringSince,
         workModeEnabled: workModeEnabled,
         alwaysChargePriceThreshold: alwaysChargePriceThreshold,
         minSellPriceThreshold: minSellPriceThreshold,
         batteryCapacityKwh: batteryCapacityKwh,
         batteryCost: batteryCost,
         batteryLifecycles: batteryLifecycles,
         minSocPercentage: minSocPercentage,
       );

  /// Returns a shallow copy of this [AppConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppConfig copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    Object? dataGatheringSince = _Undefined,
    bool? workModeEnabled,
    double? alwaysChargePriceThreshold,
    Object? minSellPriceThreshold = _Undefined,
    Object? batteryCapacityKwh = _Undefined,
    Object? batteryCost = _Undefined,
    Object? batteryLifecycles = _Undefined,
    Object? minSocPercentage = _Undefined,
  }) {
    return AppConfig(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      dataGatheringSince: dataGatheringSince is DateTime?
          ? dataGatheringSince
          : this.dataGatheringSince,
      workModeEnabled: workModeEnabled ?? this.workModeEnabled,
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
    );
  }
}
