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

abstract class DeviceTelemetry implements _i1.SerializableModel {
  DeviceTelemetry._({
    this.id,
    required this.deviceId,
    required this.userId,
    required this.timestamp,
    required this.batterySOC,
    required this.gridPowerW,
    required this.pvPowerW,
    required this.loadPowerW,
    required this.batteryPowerW,
  });

  factory DeviceTelemetry({
    int? id,
    required String deviceId,
    required int userId,
    required DateTime timestamp,
    required double batterySOC,
    required double gridPowerW,
    required double pvPowerW,
    required double loadPowerW,
    required double batteryPowerW,
  }) = _DeviceTelemetryImpl;

  factory DeviceTelemetry.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceTelemetry(
      id: jsonSerialization['id'] as int?,
      deviceId: jsonSerialization['deviceId'] as String,
      userId: jsonSerialization['userId'] as int,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      batterySOC: (jsonSerialization['batterySOC'] as num).toDouble(),
      gridPowerW: (jsonSerialization['gridPowerW'] as num).toDouble(),
      pvPowerW: (jsonSerialization['pvPowerW'] as num).toDouble(),
      loadPowerW: (jsonSerialization['loadPowerW'] as num).toDouble(),
      batteryPowerW: (jsonSerialization['batteryPowerW'] as num).toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String deviceId;

  int userId;

  DateTime timestamp;

  double batterySOC;

  double gridPowerW;

  double pvPowerW;

  double loadPowerW;

  double batteryPowerW;

  /// Returns a shallow copy of this [DeviceTelemetry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeviceTelemetry copyWith({
    int? id,
    String? deviceId,
    int? userId,
    DateTime? timestamp,
    double? batterySOC,
    double? gridPowerW,
    double? pvPowerW,
    double? loadPowerW,
    double? batteryPowerW,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceTelemetry',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      'userId': userId,
      'timestamp': timestamp.toJson(),
      'batterySOC': batterySOC,
      'gridPowerW': gridPowerW,
      'pvPowerW': pvPowerW,
      'loadPowerW': loadPowerW,
      'batteryPowerW': batteryPowerW,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceTelemetryImpl extends DeviceTelemetry {
  _DeviceTelemetryImpl({
    int? id,
    required String deviceId,
    required int userId,
    required DateTime timestamp,
    required double batterySOC,
    required double gridPowerW,
    required double pvPowerW,
    required double loadPowerW,
    required double batteryPowerW,
  }) : super._(
         id: id,
         deviceId: deviceId,
         userId: userId,
         timestamp: timestamp,
         batterySOC: batterySOC,
         gridPowerW: gridPowerW,
         pvPowerW: pvPowerW,
         loadPowerW: loadPowerW,
         batteryPowerW: batteryPowerW,
       );

  /// Returns a shallow copy of this [DeviceTelemetry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeviceTelemetry copyWith({
    Object? id = _Undefined,
    String? deviceId,
    int? userId,
    DateTime? timestamp,
    double? batterySOC,
    double? gridPowerW,
    double? pvPowerW,
    double? loadPowerW,
    double? batteryPowerW,
  }) {
    return DeviceTelemetry(
      id: id is int? ? id : this.id,
      deviceId: deviceId ?? this.deviceId,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      batterySOC: batterySOC ?? this.batterySOC,
      gridPowerW: gridPowerW ?? this.gridPowerW,
      pvPowerW: pvPowerW ?? this.pvPowerW,
      loadPowerW: loadPowerW ?? this.loadPowerW,
      batteryPowerW: batteryPowerW ?? this.batteryPowerW,
    );
  }
}
