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
import 'package:serverpod/serverpod.dart' as _i1;

abstract class DailyEnergyAggregate
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  DailyEnergyAggregate._({
    required this.date,
    required this.avgPvPowerW,
    required this.avgLoadPowerW,
    required this.avgGridPowerW,
    required this.avgBatteryPowerW,
    required this.avgBatterySOC,
    required this.sampleCount,
  });

  factory DailyEnergyAggregate({
    required DateTime date,
    required double avgPvPowerW,
    required double avgLoadPowerW,
    required double avgGridPowerW,
    required double avgBatteryPowerW,
    required double avgBatterySOC,
    required int sampleCount,
  }) = _DailyEnergyAggregateImpl;

  factory DailyEnergyAggregate.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DailyEnergyAggregate(
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      avgPvPowerW: (jsonSerialization['avgPvPowerW'] as num).toDouble(),
      avgLoadPowerW: (jsonSerialization['avgLoadPowerW'] as num).toDouble(),
      avgGridPowerW: (jsonSerialization['avgGridPowerW'] as num).toDouble(),
      avgBatteryPowerW: (jsonSerialization['avgBatteryPowerW'] as num)
          .toDouble(),
      avgBatterySOC: (jsonSerialization['avgBatterySOC'] as num).toDouble(),
      sampleCount: jsonSerialization['sampleCount'] as int,
    );
  }

  DateTime date;

  double avgPvPowerW;

  double avgLoadPowerW;

  double avgGridPowerW;

  double avgBatteryPowerW;

  double avgBatterySOC;

  int sampleCount;

  /// Returns a shallow copy of this [DailyEnergyAggregate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DailyEnergyAggregate copyWith({
    DateTime? date,
    double? avgPvPowerW,
    double? avgLoadPowerW,
    double? avgGridPowerW,
    double? avgBatteryPowerW,
    double? avgBatterySOC,
    int? sampleCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DailyEnergyAggregate',
      'date': date.toJson(),
      'avgPvPowerW': avgPvPowerW,
      'avgLoadPowerW': avgLoadPowerW,
      'avgGridPowerW': avgGridPowerW,
      'avgBatteryPowerW': avgBatteryPowerW,
      'avgBatterySOC': avgBatterySOC,
      'sampleCount': sampleCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DailyEnergyAggregate',
      'date': date.toJson(),
      'avgPvPowerW': avgPvPowerW,
      'avgLoadPowerW': avgLoadPowerW,
      'avgGridPowerW': avgGridPowerW,
      'avgBatteryPowerW': avgBatteryPowerW,
      'avgBatterySOC': avgBatterySOC,
      'sampleCount': sampleCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _DailyEnergyAggregateImpl extends DailyEnergyAggregate {
  _DailyEnergyAggregateImpl({
    required DateTime date,
    required double avgPvPowerW,
    required double avgLoadPowerW,
    required double avgGridPowerW,
    required double avgBatteryPowerW,
    required double avgBatterySOC,
    required int sampleCount,
  }) : super._(
         date: date,
         avgPvPowerW: avgPvPowerW,
         avgLoadPowerW: avgLoadPowerW,
         avgGridPowerW: avgGridPowerW,
         avgBatteryPowerW: avgBatteryPowerW,
         avgBatterySOC: avgBatterySOC,
         sampleCount: sampleCount,
       );

  /// Returns a shallow copy of this [DailyEnergyAggregate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DailyEnergyAggregate copyWith({
    DateTime? date,
    double? avgPvPowerW,
    double? avgLoadPowerW,
    double? avgGridPowerW,
    double? avgBatteryPowerW,
    double? avgBatterySOC,
    int? sampleCount,
  }) {
    return DailyEnergyAggregate(
      date: date ?? this.date,
      avgPvPowerW: avgPvPowerW ?? this.avgPvPowerW,
      avgLoadPowerW: avgLoadPowerW ?? this.avgLoadPowerW,
      avgGridPowerW: avgGridPowerW ?? this.avgGridPowerW,
      avgBatteryPowerW: avgBatteryPowerW ?? this.avgBatteryPowerW,
      avgBatterySOC: avgBatterySOC ?? this.avgBatterySOC,
      sampleCount: sampleCount ?? this.sampleCount,
    );
  }
}
