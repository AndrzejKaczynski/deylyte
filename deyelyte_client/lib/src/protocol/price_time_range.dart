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

abstract class PriceTimeRange implements _i1.SerializableModel {
  PriceTimeRange._({
    this.id,
    required this.userInfoId,
    required this.hourStart,
    required this.hourEnd,
    required this.ratePln,
    this.sellRatePln,
  });

  factory PriceTimeRange({
    int? id,
    required int userInfoId,
    required int hourStart,
    required int hourEnd,
    required double ratePln,
    double? sellRatePln,
  }) = _PriceTimeRangeImpl;

  factory PriceTimeRange.fromJson(Map<String, dynamic> jsonSerialization) {
    return PriceTimeRange(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      hourStart: jsonSerialization['hourStart'] as int,
      hourEnd: jsonSerialization['hourEnd'] as int,
      ratePln: (jsonSerialization['ratePln'] as num).toDouble(),
      sellRatePln: (jsonSerialization['sellRatePln'] as num?)?.toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userInfoId;

  int hourStart;

  int hourEnd;

  double ratePln;

  double? sellRatePln;

  /// Returns a shallow copy of this [PriceTimeRange]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PriceTimeRange copyWith({
    int? id,
    int? userInfoId,
    int? hourStart,
    int? hourEnd,
    double? ratePln,
    double? sellRatePln,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PriceTimeRange',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'hourStart': hourStart,
      'hourEnd': hourEnd,
      'ratePln': ratePln,
      if (sellRatePln != null) 'sellRatePln': sellRatePln,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PriceTimeRangeImpl extends PriceTimeRange {
  _PriceTimeRangeImpl({
    int? id,
    required int userInfoId,
    required int hourStart,
    required int hourEnd,
    required double ratePln,
    double? sellRatePln,
  }) : super._(
         id: id,
         userInfoId: userInfoId,
         hourStart: hourStart,
         hourEnd: hourEnd,
         ratePln: ratePln,
         sellRatePln: sellRatePln,
       );

  /// Returns a shallow copy of this [PriceTimeRange]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PriceTimeRange copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    int? hourStart,
    int? hourEnd,
    double? ratePln,
    Object? sellRatePln = _Undefined,
  }) {
    return PriceTimeRange(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      hourStart: hourStart ?? this.hourStart,
      hourEnd: hourEnd ?? this.hourEnd,
      ratePln: ratePln ?? this.ratePln,
      sellRatePln: sellRatePln is double? ? sellRatePln : this.sellRatePln,
    );
  }
}
