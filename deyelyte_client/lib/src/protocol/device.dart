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

abstract class Device implements _i1.SerializableModel {
  Device._({
    this.id,
    required this.userId,
    required this.hashedSerial,
    required this.licenseKey,
    this.lastSeenAt,
    required this.lastInverterOk,
    this.syncIntervalSeconds,
    this.modelValidationStatus,
    required this.modelValidationAttempts,
    this.lastIngestAt,
    required this.createdAt,
  });

  factory Device({
    int? id,
    required int userId,
    required String hashedSerial,
    required String licenseKey,
    DateTime? lastSeenAt,
    required bool lastInverterOk,
    int? syncIntervalSeconds,
    String? modelValidationStatus,
    required int modelValidationAttempts,
    DateTime? lastIngestAt,
    required DateTime createdAt,
  }) = _DeviceImpl;

  factory Device.fromJson(Map<String, dynamic> jsonSerialization) {
    return Device(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      hashedSerial: jsonSerialization['hashedSerial'] as String,
      licenseKey: jsonSerialization['licenseKey'] as String,
      lastSeenAt: jsonSerialization['lastSeenAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastSeenAt']),
      lastInverterOk: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['lastInverterOk'],
      ),
      syncIntervalSeconds: jsonSerialization['syncIntervalSeconds'] as int?,
      modelValidationStatus:
          jsonSerialization['modelValidationStatus'] as String?,
      modelValidationAttempts:
          jsonSerialization['modelValidationAttempts'] as int,
      lastIngestAt: jsonSerialization['lastIngestAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastIngestAt'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  String hashedSerial;

  String licenseKey;

  DateTime? lastSeenAt;

  bool lastInverterOk;

  int? syncIntervalSeconds;

  String? modelValidationStatus;

  int modelValidationAttempts;

  DateTime? lastIngestAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [Device]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Device copyWith({
    int? id,
    int? userId,
    String? hashedSerial,
    String? licenseKey,
    DateTime? lastSeenAt,
    bool? lastInverterOk,
    int? syncIntervalSeconds,
    String? modelValidationStatus,
    int? modelValidationAttempts,
    DateTime? lastIngestAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Device',
      if (id != null) 'id': id,
      'userId': userId,
      'hashedSerial': hashedSerial,
      'licenseKey': licenseKey,
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
      'lastInverterOk': lastInverterOk,
      if (syncIntervalSeconds != null)
        'syncIntervalSeconds': syncIntervalSeconds,
      if (modelValidationStatus != null)
        'modelValidationStatus': modelValidationStatus,
      'modelValidationAttempts': modelValidationAttempts,
      if (lastIngestAt != null) 'lastIngestAt': lastIngestAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceImpl extends Device {
  _DeviceImpl({
    int? id,
    required int userId,
    required String hashedSerial,
    required String licenseKey,
    DateTime? lastSeenAt,
    required bool lastInverterOk,
    int? syncIntervalSeconds,
    String? modelValidationStatus,
    required int modelValidationAttempts,
    DateTime? lastIngestAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         hashedSerial: hashedSerial,
         licenseKey: licenseKey,
         lastSeenAt: lastSeenAt,
         lastInverterOk: lastInverterOk,
         syncIntervalSeconds: syncIntervalSeconds,
         modelValidationStatus: modelValidationStatus,
         modelValidationAttempts: modelValidationAttempts,
         lastIngestAt: lastIngestAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Device]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Device copyWith({
    Object? id = _Undefined,
    int? userId,
    String? hashedSerial,
    String? licenseKey,
    Object? lastSeenAt = _Undefined,
    bool? lastInverterOk,
    Object? syncIntervalSeconds = _Undefined,
    Object? modelValidationStatus = _Undefined,
    int? modelValidationAttempts,
    Object? lastIngestAt = _Undefined,
    DateTime? createdAt,
  }) {
    return Device(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      hashedSerial: hashedSerial ?? this.hashedSerial,
      licenseKey: licenseKey ?? this.licenseKey,
      lastSeenAt: lastSeenAt is DateTime? ? lastSeenAt : this.lastSeenAt,
      lastInverterOk: lastInverterOk ?? this.lastInverterOk,
      syncIntervalSeconds: syncIntervalSeconds is int?
          ? syncIntervalSeconds
          : this.syncIntervalSeconds,
      modelValidationStatus: modelValidationStatus is String?
          ? modelValidationStatus
          : this.modelValidationStatus,
      modelValidationAttempts:
          modelValidationAttempts ?? this.modelValidationAttempts,
      lastIngestAt: lastIngestAt is DateTime?
          ? lastIngestAt
          : this.lastIngestAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
