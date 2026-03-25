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
import 'package:serverpod/serverpod.dart' as _i1;

abstract class AuthKeyMetadata
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = AuthKeyMetadataTable();

  static const db = AuthKeyMetadataRepository._();

  @override
  int? id;

  int keyId;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuthKeyMetadata',
      if (id != null) 'id': id,
      'keyId': keyId,
      'createdAt': createdAt.toJson(),
    };
  }

  static AuthKeyMetadataInclude include() {
    return AuthKeyMetadataInclude._();
  }

  static AuthKeyMetadataIncludeList includeList({
    _i1.WhereExpressionBuilder<AuthKeyMetadataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthKeyMetadataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthKeyMetadataTable>? orderByList,
    AuthKeyMetadataInclude? include,
  }) {
    return AuthKeyMetadataIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuthKeyMetadata.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AuthKeyMetadata.t),
      include: include,
    );
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

class AuthKeyMetadataUpdateTable extends _i1.UpdateTable<AuthKeyMetadataTable> {
  AuthKeyMetadataUpdateTable(super.table);

  _i1.ColumnValue<int, int> keyId(int value) => _i1.ColumnValue(
    table.keyId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class AuthKeyMetadataTable extends _i1.Table<int?> {
  AuthKeyMetadataTable({super.tableRelation})
    : super(tableName: 'auth_key_metadata') {
    updateTable = AuthKeyMetadataUpdateTable(this);
    keyId = _i1.ColumnInt(
      'keyId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final AuthKeyMetadataUpdateTable updateTable;

  late final _i1.ColumnInt keyId;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    keyId,
    createdAt,
  ];
}

class AuthKeyMetadataInclude extends _i1.IncludeObject {
  AuthKeyMetadataInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AuthKeyMetadata.t;
}

class AuthKeyMetadataIncludeList extends _i1.IncludeList {
  AuthKeyMetadataIncludeList._({
    _i1.WhereExpressionBuilder<AuthKeyMetadataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AuthKeyMetadata.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AuthKeyMetadata.t;
}

class AuthKeyMetadataRepository {
  const AuthKeyMetadataRepository._();

  /// Returns a list of [AuthKeyMetadata]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<AuthKeyMetadata>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AuthKeyMetadataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthKeyMetadataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthKeyMetadataTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AuthKeyMetadata>(
      where: where?.call(AuthKeyMetadata.t),
      orderBy: orderBy?.call(AuthKeyMetadata.t),
      orderByList: orderByList?.call(AuthKeyMetadata.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AuthKeyMetadata] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<AuthKeyMetadata?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AuthKeyMetadataTable>? where,
    int? offset,
    _i1.OrderByBuilder<AuthKeyMetadataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AuthKeyMetadataTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AuthKeyMetadata>(
      where: where?.call(AuthKeyMetadata.t),
      orderBy: orderBy?.call(AuthKeyMetadata.t),
      orderByList: orderByList?.call(AuthKeyMetadata.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AuthKeyMetadata] by its [id] or null if no such row exists.
  Future<AuthKeyMetadata?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AuthKeyMetadata>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AuthKeyMetadata]s in the list and returns the inserted rows.
  ///
  /// The returned [AuthKeyMetadata]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AuthKeyMetadata>> insert(
    _i1.DatabaseSession session,
    List<AuthKeyMetadata> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AuthKeyMetadata>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AuthKeyMetadata] and returns the inserted row.
  ///
  /// The returned [AuthKeyMetadata] will have its `id` field set.
  Future<AuthKeyMetadata> insertRow(
    _i1.DatabaseSession session,
    AuthKeyMetadata row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AuthKeyMetadata>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AuthKeyMetadata]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AuthKeyMetadata>> update(
    _i1.DatabaseSession session,
    List<AuthKeyMetadata> rows, {
    _i1.ColumnSelections<AuthKeyMetadataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AuthKeyMetadata>(
      rows,
      columns: columns?.call(AuthKeyMetadata.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuthKeyMetadata]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AuthKeyMetadata> updateRow(
    _i1.DatabaseSession session,
    AuthKeyMetadata row, {
    _i1.ColumnSelections<AuthKeyMetadataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AuthKeyMetadata>(
      row,
      columns: columns?.call(AuthKeyMetadata.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuthKeyMetadata] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AuthKeyMetadata?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AuthKeyMetadataUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AuthKeyMetadata>(
      id,
      columnValues: columnValues(AuthKeyMetadata.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AuthKeyMetadata]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AuthKeyMetadata>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AuthKeyMetadataUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AuthKeyMetadataTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AuthKeyMetadataTable>? orderBy,
    _i1.OrderByListBuilder<AuthKeyMetadataTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AuthKeyMetadata>(
      columnValues: columnValues(AuthKeyMetadata.t.updateTable),
      where: where(AuthKeyMetadata.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuthKeyMetadata.t),
      orderByList: orderByList?.call(AuthKeyMetadata.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AuthKeyMetadata]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AuthKeyMetadata>> delete(
    _i1.DatabaseSession session,
    List<AuthKeyMetadata> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AuthKeyMetadata>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AuthKeyMetadata].
  Future<AuthKeyMetadata> deleteRow(
    _i1.DatabaseSession session,
    AuthKeyMetadata row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AuthKeyMetadata>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AuthKeyMetadata>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AuthKeyMetadataTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AuthKeyMetadata>(
      where: where(AuthKeyMetadata.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AuthKeyMetadataTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AuthKeyMetadata>(
      where: where?.call(AuthKeyMetadata.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AuthKeyMetadata] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AuthKeyMetadataTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AuthKeyMetadata>(
      where: where(AuthKeyMetadata.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
