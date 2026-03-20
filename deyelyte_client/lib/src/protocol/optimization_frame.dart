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

abstract class OptimizationFrame implements _i1.SerializableModel {
  OptimizationFrame._({
    this.id,
    required this.userInfoId,
    required this.generatedAt,
    required this.hour,
    required this.command,
    this.targetSocPercent,
    required this.reason,
    required this.estimatedSocAtStart,
    required this.expectedNetLoadW,
    required this.expectedPvW,
  });

  factory OptimizationFrame({
    int? id,
    required int userInfoId,
    required DateTime generatedAt,
    required DateTime hour,
    required String command,
    double? targetSocPercent,
    required String reason,
    required double estimatedSocAtStart,
    required double expectedNetLoadW,
    required double expectedPvW,
  }) = _OptimizationFrameImpl;

  factory OptimizationFrame.fromJson(Map<String, dynamic> jsonSerialization) {
    return OptimizationFrame(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      generatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['generatedAt'],
      ),
      hour: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['hour']),
      command: jsonSerialization['command'] as String,
      targetSocPercent: (jsonSerialization['targetSocPercent'] as num?)
          ?.toDouble(),
      reason: jsonSerialization['reason'] as String,
      estimatedSocAtStart: (jsonSerialization['estimatedSocAtStart'] as num)
          .toDouble(),
      expectedNetLoadW: (jsonSerialization['expectedNetLoadW'] as num)
          .toDouble(),
      expectedPvW: (jsonSerialization['expectedPvW'] as num).toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userInfoId;

  DateTime generatedAt;

  DateTime hour;

  String command;

  double? targetSocPercent;

  String reason;

  double estimatedSocAtStart;

  double expectedNetLoadW;

  double expectedPvW;

  /// Returns a shallow copy of this [OptimizationFrame]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OptimizationFrame copyWith({
    int? id,
    int? userInfoId,
    DateTime? generatedAt,
    DateTime? hour,
    String? command,
    double? targetSocPercent,
    String? reason,
    double? estimatedSocAtStart,
    double? expectedNetLoadW,
    double? expectedPvW,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OptimizationFrame',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'generatedAt': generatedAt.toJson(),
      'hour': hour.toJson(),
      'command': command,
      if (targetSocPercent != null) 'targetSocPercent': targetSocPercent,
      'reason': reason,
      'estimatedSocAtStart': estimatedSocAtStart,
      'expectedNetLoadW': expectedNetLoadW,
      'expectedPvW': expectedPvW,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OptimizationFrameImpl extends OptimizationFrame {
  _OptimizationFrameImpl({
    int? id,
    required int userInfoId,
    required DateTime generatedAt,
    required DateTime hour,
    required String command,
    double? targetSocPercent,
    required String reason,
    required double estimatedSocAtStart,
    required double expectedNetLoadW,
    required double expectedPvW,
  }) : super._(
         id: id,
         userInfoId: userInfoId,
         generatedAt: generatedAt,
         hour: hour,
         command: command,
         targetSocPercent: targetSocPercent,
         reason: reason,
         estimatedSocAtStart: estimatedSocAtStart,
         expectedNetLoadW: expectedNetLoadW,
         expectedPvW: expectedPvW,
       );

  /// Returns a shallow copy of this [OptimizationFrame]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OptimizationFrame copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    DateTime? generatedAt,
    DateTime? hour,
    String? command,
    Object? targetSocPercent = _Undefined,
    String? reason,
    double? estimatedSocAtStart,
    double? expectedNetLoadW,
    double? expectedPvW,
  }) {
    return OptimizationFrame(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      generatedAt: generatedAt ?? this.generatedAt,
      hour: hour ?? this.hour,
      command: command ?? this.command,
      targetSocPercent: targetSocPercent is double?
          ? targetSocPercent
          : this.targetSocPercent,
      reason: reason ?? this.reason,
      estimatedSocAtStart: estimatedSocAtStart ?? this.estimatedSocAtStart,
      expectedNetLoadW: expectedNetLoadW ?? this.expectedNetLoadW,
      expectedPvW: expectedPvW ?? this.expectedPvW,
    );
  }
}
