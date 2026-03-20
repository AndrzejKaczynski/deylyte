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

abstract class PvForecast implements _i1.SerializableModel {
  PvForecast._({
    this.id,
    required this.userInfoId,
    required this.timestamp,
    required this.expectedYieldWatts,
  });

  factory PvForecast({
    int? id,
    required int userInfoId,
    required DateTime timestamp,
    required double expectedYieldWatts,
  }) = _PvForecastImpl;

  factory PvForecast.fromJson(Map<String, dynamic> jsonSerialization) {
    return PvForecast(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      expectedYieldWatts: (jsonSerialization['expectedYieldWatts'] as num)
          .toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userInfoId;

  DateTime timestamp;

  double expectedYieldWatts;

  /// Returns a shallow copy of this [PvForecast]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PvForecast copyWith({
    int? id,
    int? userInfoId,
    DateTime? timestamp,
    double? expectedYieldWatts,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PvForecast',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'timestamp': timestamp.toJson(),
      'expectedYieldWatts': expectedYieldWatts,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PvForecastImpl extends PvForecast {
  _PvForecastImpl({
    int? id,
    required int userInfoId,
    required DateTime timestamp,
    required double expectedYieldWatts,
  }) : super._(
         id: id,
         userInfoId: userInfoId,
         timestamp: timestamp,
         expectedYieldWatts: expectedYieldWatts,
       );

  /// Returns a shallow copy of this [PvForecast]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PvForecast copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    DateTime? timestamp,
    double? expectedYieldWatts,
  }) {
    return PvForecast(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      timestamp: timestamp ?? this.timestamp,
      expectedYieldWatts: expectedYieldWatts ?? this.expectedYieldWatts,
    );
  }
}
