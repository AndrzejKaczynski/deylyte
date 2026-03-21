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

abstract class LicenseKey implements _i1.SerializableModel {
  LicenseKey._({
    this.id,
    required this.licenseKey,
    required this.userId,
    required this.tier,
    this.stripeSubscriptionId,
    required this.isActive,
    required this.createdAt,
    this.expiresAt,
    this.lastSeenAt,
  });

  factory LicenseKey({
    int? id,
    required String licenseKey,
    required int userId,
    required String tier,
    String? stripeSubscriptionId,
    required bool isActive,
    required DateTime createdAt,
    DateTime? expiresAt,
    DateTime? lastSeenAt,
  }) = _LicenseKeyImpl;

  factory LicenseKey.fromJson(Map<String, dynamic> jsonSerialization) {
    return LicenseKey(
      id: jsonSerialization['id'] as int?,
      licenseKey: jsonSerialization['licenseKey'] as String,
      userId: jsonSerialization['userId'] as int,
      tier: jsonSerialization['tier'] as String,
      stripeSubscriptionId:
          jsonSerialization['stripeSubscriptionId'] as String?,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      lastSeenAt: jsonSerialization['lastSeenAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastSeenAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String licenseKey;

  int userId;

  String tier;

  String? stripeSubscriptionId;

  bool isActive;

  DateTime createdAt;

  DateTime? expiresAt;

  DateTime? lastSeenAt;

  /// Returns a shallow copy of this [LicenseKey]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LicenseKey copyWith({
    int? id,
    String? licenseKey,
    int? userId,
    String? tier,
    String? stripeSubscriptionId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? expiresAt,
    DateTime? lastSeenAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LicenseKey',
      if (id != null) 'id': id,
      'licenseKey': licenseKey,
      'userId': userId,
      'tier': tier,
      if (stripeSubscriptionId != null)
        'stripeSubscriptionId': stripeSubscriptionId,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LicenseKeyImpl extends LicenseKey {
  _LicenseKeyImpl({
    int? id,
    required String licenseKey,
    required int userId,
    required String tier,
    String? stripeSubscriptionId,
    required bool isActive,
    required DateTime createdAt,
    DateTime? expiresAt,
    DateTime? lastSeenAt,
  }) : super._(
         id: id,
         licenseKey: licenseKey,
         userId: userId,
         tier: tier,
         stripeSubscriptionId: stripeSubscriptionId,
         isActive: isActive,
         createdAt: createdAt,
         expiresAt: expiresAt,
         lastSeenAt: lastSeenAt,
       );

  /// Returns a shallow copy of this [LicenseKey]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LicenseKey copyWith({
    Object? id = _Undefined,
    String? licenseKey,
    int? userId,
    String? tier,
    Object? stripeSubscriptionId = _Undefined,
    bool? isActive,
    DateTime? createdAt,
    Object? expiresAt = _Undefined,
    Object? lastSeenAt = _Undefined,
  }) {
    return LicenseKey(
      id: id is int? ? id : this.id,
      licenseKey: licenseKey ?? this.licenseKey,
      userId: userId ?? this.userId,
      tier: tier ?? this.tier,
      stripeSubscriptionId: stripeSubscriptionId is String?
          ? stripeSubscriptionId
          : this.stripeSubscriptionId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      lastSeenAt: lastSeenAt is DateTime? ? lastSeenAt : this.lastSeenAt,
    );
  }
}
