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

abstract class TierSyncConfig implements _i1.SerializableModel {
  TierSyncConfig._({
    this.id,
    required this.tier,
    required this.syncIntervalSeconds,
    required this.historyDurationDays,
  });

  factory TierSyncConfig({
    int? id,
    required String tier,
    required int syncIntervalSeconds,
    required int historyDurationDays,
  }) = _TierSyncConfigImpl;

  factory TierSyncConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return TierSyncConfig(
      id: jsonSerialization['id'] as int?,
      tier: jsonSerialization['tier'] as String,
      syncIntervalSeconds: jsonSerialization['syncIntervalSeconds'] as int,
      historyDurationDays: jsonSerialization['historyDurationDays'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String tier;

  int syncIntervalSeconds;

  int historyDurationDays;

  /// Returns a shallow copy of this [TierSyncConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TierSyncConfig copyWith({
    int? id,
    String? tier,
    int? syncIntervalSeconds,
    int? historyDurationDays,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TierSyncConfig',
      if (id != null) 'id': id,
      'tier': tier,
      'syncIntervalSeconds': syncIntervalSeconds,
      'historyDurationDays': historyDurationDays,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TierSyncConfigImpl extends TierSyncConfig {
  _TierSyncConfigImpl({
    int? id,
    required String tier,
    required int syncIntervalSeconds,
    required int historyDurationDays,
  }) : super._(
         id: id,
         tier: tier,
         syncIntervalSeconds: syncIntervalSeconds,
         historyDurationDays: historyDurationDays,
       );

  /// Returns a shallow copy of this [TierSyncConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TierSyncConfig copyWith({
    Object? id = _Undefined,
    String? tier,
    int? syncIntervalSeconds,
    int? historyDurationDays,
  }) {
    return TierSyncConfig(
      id: id is int? ? id : this.id,
      tier: tier ?? this.tier,
      syncIntervalSeconds: syncIntervalSeconds ?? this.syncIntervalSeconds,
      historyDurationDays: historyDurationDays ?? this.historyDurationDays,
    );
  }
}
