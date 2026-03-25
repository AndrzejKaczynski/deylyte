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

abstract class AuthKeyMetadata implements _i1.SerializableModel {
  AuthKeyMetadata._({
    this.id,
    required this.keyId,
    required this.createdAt,
  });

  factory AuthKeyMetadata({
    int? id,
    required int keyId,
    required DateTime createdAt,
  }) = _AuthKeyMetadataImpl;

  factory AuthKeyMetadata.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthKeyMetadata(
      id: jsonSerialization['id'] as int?,
      keyId: jsonSerialization['keyId'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int keyId;

  DateTime createdAt;

  /// Returns a shallow copy of this [AuthKeyMetadata]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuthKeyMetadata copyWith({
    int? id,
    int? keyId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuthKeyMetadata',
      if (id != null) 'id': id,
      'keyId': keyId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthKeyMetadataImpl extends AuthKeyMetadata {
  _AuthKeyMetadataImpl({
    int? id,
    required int keyId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         keyId: keyId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AuthKeyMetadata]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuthKeyMetadata copyWith({
    Object? id = _Undefined,
    int? keyId,
    DateTime? createdAt,
  }) {
    return AuthKeyMetadata(
      id: id is int? ? id : this.id,
      keyId: keyId ?? this.keyId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
