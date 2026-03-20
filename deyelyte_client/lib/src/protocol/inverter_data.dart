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

abstract class InverterData implements _i1.SerializableModel {
  InverterData._({
    this.id,
    required this.userInfoId,
    required this.timestamp,
    required this.pvPower,
    required this.batteryLevel,
    required this.gridPower,
    required this.loadPower,
  });

  factory InverterData({
    int? id,
    required int userInfoId,
    required DateTime timestamp,
    required double pvPower,
    required double batteryLevel,
    required double gridPower,
    required double loadPower,
  }) = _InverterDataImpl;

  factory InverterData.fromJson(Map<String, dynamic> jsonSerialization) {
    return InverterData(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      pvPower: (jsonSerialization['pvPower'] as num).toDouble(),
      batteryLevel: (jsonSerialization['batteryLevel'] as num).toDouble(),
      gridPower: (jsonSerialization['gridPower'] as num).toDouble(),
      loadPower: (jsonSerialization['loadPower'] as num).toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userInfoId;

  DateTime timestamp;

  double pvPower;

  double batteryLevel;

  double gridPower;

  double loadPower;

  /// Returns a shallow copy of this [InverterData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  InverterData copyWith({
    int? id,
    int? userInfoId,
    DateTime? timestamp,
    double? pvPower,
    double? batteryLevel,
    double? gridPower,
    double? loadPower,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InverterData',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'timestamp': timestamp.toJson(),
      'pvPower': pvPower,
      'batteryLevel': batteryLevel,
      'gridPower': gridPower,
      'loadPower': loadPower,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InverterDataImpl extends InverterData {
  _InverterDataImpl({
    int? id,
    required int userInfoId,
    required DateTime timestamp,
    required double pvPower,
    required double batteryLevel,
    required double gridPower,
    required double loadPower,
  }) : super._(
         id: id,
         userInfoId: userInfoId,
         timestamp: timestamp,
         pvPower: pvPower,
         batteryLevel: batteryLevel,
         gridPower: gridPower,
         loadPower: loadPower,
       );

  /// Returns a shallow copy of this [InverterData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  InverterData copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    DateTime? timestamp,
    double? pvPower,
    double? batteryLevel,
    double? gridPower,
    double? loadPower,
  }) {
    return InverterData(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      timestamp: timestamp ?? this.timestamp,
      pvPower: pvPower ?? this.pvPower,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      gridPower: gridPower ?? this.gridPower,
      loadPower: loadPower ?? this.loadPower,
    );
  }
}
