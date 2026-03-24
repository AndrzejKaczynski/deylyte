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
import 'daily_energy_aggregate.dart' as _i2;
import 'daily_avg_price.dart' as _i3;
import 'optimization_frame.dart' as _i4;
import 'package:deyelyte_client/src/protocol/protocol.dart' as _i5;

abstract class HistoryPeriodData implements _i1.SerializableModel {
  HistoryPeriodData._({
    required this.fromDate,
    required this.toDate,
    required this.aggregates,
    required this.dailyAvgPrices,
    required this.frames,
  });

  factory HistoryPeriodData({
    required DateTime fromDate,
    required DateTime toDate,
    required List<_i2.DailyEnergyAggregate> aggregates,
    required List<_i3.DailyAvgPrice> dailyAvgPrices,
    required List<_i4.OptimizationFrame> frames,
  }) = _HistoryPeriodDataImpl;

  factory HistoryPeriodData.fromJson(Map<String, dynamic> jsonSerialization) {
    return HistoryPeriodData(
      fromDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['fromDate'],
      ),
      toDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['toDate']),
      aggregates: _i5.Protocol().deserialize<List<_i2.DailyEnergyAggregate>>(
        jsonSerialization['aggregates'],
      ),
      dailyAvgPrices: _i5.Protocol().deserialize<List<_i3.DailyAvgPrice>>(
        jsonSerialization['dailyAvgPrices'],
      ),
      frames: _i5.Protocol().deserialize<List<_i4.OptimizationFrame>>(
        jsonSerialization['frames'],
      ),
    );
  }

  DateTime fromDate;

  DateTime toDate;

  List<_i2.DailyEnergyAggregate> aggregates;

  List<_i3.DailyAvgPrice> dailyAvgPrices;

  List<_i4.OptimizationFrame> frames;

  /// Returns a shallow copy of this [HistoryPeriodData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  HistoryPeriodData copyWith({
    DateTime? fromDate,
    DateTime? toDate,
    List<_i2.DailyEnergyAggregate>? aggregates,
    List<_i3.DailyAvgPrice>? dailyAvgPrices,
    List<_i4.OptimizationFrame>? frames,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HistoryPeriodData',
      'fromDate': fromDate.toJson(),
      'toDate': toDate.toJson(),
      'aggregates': aggregates.toJson(valueToJson: (v) => v.toJson()),
      'dailyAvgPrices': dailyAvgPrices.toJson(valueToJson: (v) => v.toJson()),
      'frames': frames.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _HistoryPeriodDataImpl extends HistoryPeriodData {
  _HistoryPeriodDataImpl({
    required DateTime fromDate,
    required DateTime toDate,
    required List<_i2.DailyEnergyAggregate> aggregates,
    required List<_i3.DailyAvgPrice> dailyAvgPrices,
    required List<_i4.OptimizationFrame> frames,
  }) : super._(
         fromDate: fromDate,
         toDate: toDate,
         aggregates: aggregates,
         dailyAvgPrices: dailyAvgPrices,
         frames: frames,
       );

  /// Returns a shallow copy of this [HistoryPeriodData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  HistoryPeriodData copyWith({
    DateTime? fromDate,
    DateTime? toDate,
    List<_i2.DailyEnergyAggregate>? aggregates,
    List<_i3.DailyAvgPrice>? dailyAvgPrices,
    List<_i4.OptimizationFrame>? frames,
  }) {
    return HistoryPeriodData(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      aggregates:
          aggregates ?? this.aggregates.map((e0) => e0.copyWith()).toList(),
      dailyAvgPrices:
          dailyAvgPrices ??
          this.dailyAvgPrices.map((e0) => e0.copyWith()).toList(),
      frames: frames ?? this.frames.map((e0) => e0.copyWith()).toList(),
    );
  }
}
