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

abstract class InverterModel implements _i1.SerializableModel {
  InverterModel._({
    this.id,
    required this.modelId,
    required this.displayName,
    required this.registerMapJson,
  });

  factory InverterModel({
    int? id,
    required String modelId,
    required String displayName,
    required String registerMapJson,
  }) = _InverterModelImpl;

  factory InverterModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return InverterModel(
      id: jsonSerialization['id'] as int?,
      modelId: jsonSerialization['modelId'] as String,
      displayName: jsonSerialization['displayName'] as String,
      registerMapJson: jsonSerialization['registerMapJson'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String modelId;

  String displayName;

  String registerMapJson;

  /// Returns a shallow copy of this [InverterModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  InverterModel copyWith({
    int? id,
    String? modelId,
    String? displayName,
    String? registerMapJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InverterModel',
      if (id != null) 'id': id,
      'modelId': modelId,
      'displayName': displayName,
      'registerMapJson': registerMapJson,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InverterModelImpl extends InverterModel {
  _InverterModelImpl({
    int? id,
    required String modelId,
    required String displayName,
    required String registerMapJson,
  }) : super._(
         id: id,
         modelId: modelId,
         displayName: displayName,
         registerMapJson: registerMapJson,
       );

  /// Returns a shallow copy of this [InverterModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  InverterModel copyWith({
    Object? id = _Undefined,
    String? modelId,
    String? displayName,
    String? registerMapJson,
  }) {
    return InverterModel(
      id: id is int? ? id : this.id,
      modelId: modelId ?? this.modelId,
      displayName: displayName ?? this.displayName,
      registerMapJson: registerMapJson ?? this.registerMapJson,
    );
  }
}
