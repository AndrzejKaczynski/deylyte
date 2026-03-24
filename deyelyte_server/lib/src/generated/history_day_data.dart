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
import 'device_telemetry.dart' as _i2;
import 'energy_price.dart' as _i3;
import 'optimization_frame.dart' as _i4;
import 'package:deyelyte_server/src/generated/protocol.dart' as _i5;

abstract class HistoryDayData
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  HistoryDayData._({
    required this.date,
    required this.telemetry,
    required this.prices,
    required this.frames,
  });

  factory HistoryDayData({
    required DateTime date,
    required List<_i2.DeviceTelemetry> telemetry,
    required List<_i3.EnergyPrice> prices,
    required List<_i4.OptimizationFrame> frames,
  }) = _HistoryDayDataImpl;

  factory HistoryDayData.fromJson(Map<String, dynamic> jsonSerialization) {
    return HistoryDayData(
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      telemetry: _i5.Protocol().deserialize<List<_i2.DeviceTelemetry>>(
        jsonSerialization['telemetry'],
      ),
      prices: _i5.Protocol().deserialize<List<_i3.EnergyPrice>>(
        jsonSerialization['prices'],
      ),
      frames: _i5.Protocol().deserialize<List<_i4.OptimizationFrame>>(
        jsonSerialization['frames'],
      ),
    );
  }

  DateTime date;

  List<_i2.DeviceTelemetry> telemetry;

  List<_i3.EnergyPrice> prices;

  List<_i4.OptimizationFrame> frames;

  /// Returns a shallow copy of this [HistoryDayData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  HistoryDayData copyWith({
    DateTime? date,
    List<_i2.DeviceTelemetry>? telemetry,
    List<_i3.EnergyPrice>? prices,
    List<_i4.OptimizationFrame>? frames,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HistoryDayData',
      'date': date.toJson(),
      'telemetry': telemetry.toJson(valueToJson: (v) => v.toJson()),
      'prices': prices.toJson(valueToJson: (v) => v.toJson()),
      'frames': frames.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HistoryDayData',
      'date': date.toJson(),
      'telemetry': telemetry.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'prices': prices.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'frames': frames.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _HistoryDayDataImpl extends HistoryDayData {
  _HistoryDayDataImpl({
    required DateTime date,
    required List<_i2.DeviceTelemetry> telemetry,
    required List<_i3.EnergyPrice> prices,
    required List<_i4.OptimizationFrame> frames,
  }) : super._(
         date: date,
         telemetry: telemetry,
         prices: prices,
         frames: frames,
       );

  /// Returns a shallow copy of this [HistoryDayData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  HistoryDayData copyWith({
    DateTime? date,
    List<_i2.DeviceTelemetry>? telemetry,
    List<_i3.EnergyPrice>? prices,
    List<_i4.OptimizationFrame>? frames,
  }) {
    return HistoryDayData(
      date: date ?? this.date,
      telemetry:
          telemetry ?? this.telemetry.map((e0) => e0.copyWith()).toList(),
      prices: prices ?? this.prices.map((e0) => e0.copyWith()).toList(),
      frames: frames ?? this.frames.map((e0) => e0.copyWith()).toList(),
    );
  }
}
