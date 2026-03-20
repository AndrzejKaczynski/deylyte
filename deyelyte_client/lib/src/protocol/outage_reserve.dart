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

abstract class OutageReserve implements _i1.SerializableModel {
  OutageReserve._({
    this.id,
    required this.userInfoId,
    required this.date,
    this.note,
  });

  factory OutageReserve({
    int? id,
    required int userInfoId,
    required DateTime date,
    String? note,
  }) = _OutageReserveImpl;

  factory OutageReserve.fromJson(Map<String, dynamic> jsonSerialization) {
    return OutageReserve(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      note: jsonSerialization['note'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userInfoId;

  DateTime date;

  String? note;

  /// Returns a shallow copy of this [OutageReserve]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OutageReserve copyWith({
    int? id,
    int? userInfoId,
    DateTime? date,
    String? note,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OutageReserve',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'date': date.toJson(),
      if (note != null) 'note': note,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OutageReserveImpl extends OutageReserve {
  _OutageReserveImpl({
    int? id,
    required int userInfoId,
    required DateTime date,
    String? note,
  }) : super._(
         id: id,
         userInfoId: userInfoId,
         date: date,
         note: note,
       );

  /// Returns a shallow copy of this [OutageReserve]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OutageReserve copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    DateTime? date,
    Object? note = _Undefined,
  }) {
    return OutageReserve(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      date: date ?? this.date,
      note: note is String? ? note : this.note,
    );
  }
}
