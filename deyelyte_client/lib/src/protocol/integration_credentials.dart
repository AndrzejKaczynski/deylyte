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

abstract class IntegrationCredentials implements _i1.SerializableModel {
  IntegrationCredentials._({
    this.id,
    required this.userInfoId,
    this.deyeUsername,
    this.deyePasswordHash,
    this.deyeAppId,
    this.deyeAppSecret,
    this.deyeDeviceSn,
    this.solcastApiKey,
    this.solcastSiteId,
    this.pstrykToken,
  });

  factory IntegrationCredentials({
    int? id,
    required int userInfoId,
    String? deyeUsername,
    String? deyePasswordHash,
    String? deyeAppId,
    String? deyeAppSecret,
    String? deyeDeviceSn,
    String? solcastApiKey,
    String? solcastSiteId,
    String? pstrykToken,
  }) = _IntegrationCredentialsImpl;

  factory IntegrationCredentials.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return IntegrationCredentials(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      deyeUsername: jsonSerialization['deyeUsername'] as String?,
      deyePasswordHash: jsonSerialization['deyePasswordHash'] as String?,
      deyeAppId: jsonSerialization['deyeAppId'] as String?,
      deyeAppSecret: jsonSerialization['deyeAppSecret'] as String?,
      deyeDeviceSn: jsonSerialization['deyeDeviceSn'] as String?,
      solcastApiKey: jsonSerialization['solcastApiKey'] as String?,
      solcastSiteId: jsonSerialization['solcastSiteId'] as String?,
      pstrykToken: jsonSerialization['pstrykToken'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userInfoId;

  String? deyeUsername;

  String? deyePasswordHash;

  String? deyeAppId;

  String? deyeAppSecret;

  String? deyeDeviceSn;

  String? solcastApiKey;

  String? solcastSiteId;

  String? pstrykToken;

  /// Returns a shallow copy of this [IntegrationCredentials]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IntegrationCredentials copyWith({
    int? id,
    int? userInfoId,
    String? deyeUsername,
    String? deyePasswordHash,
    String? deyeAppId,
    String? deyeAppSecret,
    String? deyeDeviceSn,
    String? solcastApiKey,
    String? solcastSiteId,
    String? pstrykToken,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IntegrationCredentials',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      if (deyeUsername != null) 'deyeUsername': deyeUsername,
      if (deyePasswordHash != null) 'deyePasswordHash': deyePasswordHash,
      if (deyeAppId != null) 'deyeAppId': deyeAppId,
      if (deyeAppSecret != null) 'deyeAppSecret': deyeAppSecret,
      if (deyeDeviceSn != null) 'deyeDeviceSn': deyeDeviceSn,
      if (solcastApiKey != null) 'solcastApiKey': solcastApiKey,
      if (solcastSiteId != null) 'solcastSiteId': solcastSiteId,
      if (pstrykToken != null) 'pstrykToken': pstrykToken,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IntegrationCredentialsImpl extends IntegrationCredentials {
  _IntegrationCredentialsImpl({
    int? id,
    required int userInfoId,
    String? deyeUsername,
    String? deyePasswordHash,
    String? deyeAppId,
    String? deyeAppSecret,
    String? deyeDeviceSn,
    String? solcastApiKey,
    String? solcastSiteId,
    String? pstrykToken,
  }) : super._(
         id: id,
         userInfoId: userInfoId,
         deyeUsername: deyeUsername,
         deyePasswordHash: deyePasswordHash,
         deyeAppId: deyeAppId,
         deyeAppSecret: deyeAppSecret,
         deyeDeviceSn: deyeDeviceSn,
         solcastApiKey: solcastApiKey,
         solcastSiteId: solcastSiteId,
         pstrykToken: pstrykToken,
       );

  /// Returns a shallow copy of this [IntegrationCredentials]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IntegrationCredentials copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    Object? deyeUsername = _Undefined,
    Object? deyePasswordHash = _Undefined,
    Object? deyeAppId = _Undefined,
    Object? deyeAppSecret = _Undefined,
    Object? deyeDeviceSn = _Undefined,
    Object? solcastApiKey = _Undefined,
    Object? solcastSiteId = _Undefined,
    Object? pstrykToken = _Undefined,
  }) {
    return IntegrationCredentials(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      deyeUsername: deyeUsername is String? ? deyeUsername : this.deyeUsername,
      deyePasswordHash: deyePasswordHash is String?
          ? deyePasswordHash
          : this.deyePasswordHash,
      deyeAppId: deyeAppId is String? ? deyeAppId : this.deyeAppId,
      deyeAppSecret: deyeAppSecret is String?
          ? deyeAppSecret
          : this.deyeAppSecret,
      deyeDeviceSn: deyeDeviceSn is String? ? deyeDeviceSn : this.deyeDeviceSn,
      solcastApiKey: solcastApiKey is String?
          ? solcastApiKey
          : this.solcastApiKey,
      solcastSiteId: solcastSiteId is String?
          ? solcastSiteId
          : this.solcastSiteId,
      pstrykToken: pstrykToken is String? ? pstrykToken : this.pstrykToken,
    );
  }
}
