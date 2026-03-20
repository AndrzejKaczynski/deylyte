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

abstract class IntegrationCredentials
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  IntegrationCredentials._({
    this.id,
    required this.userInfoId,
    this.deyeUsername,
    this.deyePasswordHash,
    this.deyeAppId,
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
      solcastApiKey: jsonSerialization['solcastApiKey'] as String?,
      solcastSiteId: jsonSerialization['solcastSiteId'] as String?,
      pstrykToken: jsonSerialization['pstrykToken'] as String?,
    );
  }

  static final t = IntegrationCredentialsTable();

  static const db = IntegrationCredentialsRepository._();

  @override
  int? id;

  int userInfoId;

  String? deyeUsername;

  String? deyePasswordHash;

  String? deyeAppId;

  String? solcastApiKey;

  String? solcastSiteId;

  String? pstrykToken;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [IntegrationCredentials]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IntegrationCredentials copyWith({
    int? id,
    int? userInfoId,
    String? deyeUsername,
    String? deyePasswordHash,
    String? deyeAppId,
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
      if (solcastApiKey != null) 'solcastApiKey': solcastApiKey,
      if (solcastSiteId != null) 'solcastSiteId': solcastSiteId,
      if (pstrykToken != null) 'pstrykToken': pstrykToken,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IntegrationCredentials',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      if (deyeUsername != null) 'deyeUsername': deyeUsername,
      if (deyePasswordHash != null) 'deyePasswordHash': deyePasswordHash,
      if (deyeAppId != null) 'deyeAppId': deyeAppId,
      if (solcastApiKey != null) 'solcastApiKey': solcastApiKey,
      if (solcastSiteId != null) 'solcastSiteId': solcastSiteId,
      if (pstrykToken != null) 'pstrykToken': pstrykToken,
    };
  }

  static IntegrationCredentialsInclude include() {
    return IntegrationCredentialsInclude._();
  }

  static IntegrationCredentialsIncludeList includeList({
    _i1.WhereExpressionBuilder<IntegrationCredentialsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IntegrationCredentialsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IntegrationCredentialsTable>? orderByList,
    IntegrationCredentialsInclude? include,
  }) {
    return IntegrationCredentialsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IntegrationCredentials.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(IntegrationCredentials.t),
      include: include,
    );
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
    String? solcastApiKey,
    String? solcastSiteId,
    String? pstrykToken,
  }) : super._(
         id: id,
         userInfoId: userInfoId,
         deyeUsername: deyeUsername,
         deyePasswordHash: deyePasswordHash,
         deyeAppId: deyeAppId,
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

class IntegrationCredentialsUpdateTable
    extends _i1.UpdateTable<IntegrationCredentialsTable> {
  IntegrationCredentialsUpdateTable(super.table);

  _i1.ColumnValue<int, int> userInfoId(int value) => _i1.ColumnValue(
    table.userInfoId,
    value,
  );

  _i1.ColumnValue<String, String> deyeUsername(String? value) =>
      _i1.ColumnValue(
        table.deyeUsername,
        value,
      );

  _i1.ColumnValue<String, String> deyePasswordHash(String? value) =>
      _i1.ColumnValue(
        table.deyePasswordHash,
        value,
      );

  _i1.ColumnValue<String, String> deyeAppId(String? value) => _i1.ColumnValue(
    table.deyeAppId,
    value,
  );

  _i1.ColumnValue<String, String> solcastApiKey(String? value) =>
      _i1.ColumnValue(
        table.solcastApiKey,
        value,
      );

  _i1.ColumnValue<String, String> solcastSiteId(String? value) =>
      _i1.ColumnValue(
        table.solcastSiteId,
        value,
      );

  _i1.ColumnValue<String, String> pstrykToken(String? value) => _i1.ColumnValue(
    table.pstrykToken,
    value,
  );
}

class IntegrationCredentialsTable extends _i1.Table<int?> {
  IntegrationCredentialsTable({super.tableRelation})
    : super(tableName: 'integration_credentials') {
    updateTable = IntegrationCredentialsUpdateTable(this);
    userInfoId = _i1.ColumnInt(
      'userInfoId',
      this,
    );
    deyeUsername = _i1.ColumnString(
      'deyeUsername',
      this,
    );
    deyePasswordHash = _i1.ColumnString(
      'deyePasswordHash',
      this,
    );
    deyeAppId = _i1.ColumnString(
      'deyeAppId',
      this,
    );
    solcastApiKey = _i1.ColumnString(
      'solcastApiKey',
      this,
    );
    solcastSiteId = _i1.ColumnString(
      'solcastSiteId',
      this,
    );
    pstrykToken = _i1.ColumnString(
      'pstrykToken',
      this,
    );
  }

  late final IntegrationCredentialsUpdateTable updateTable;

  late final _i1.ColumnInt userInfoId;

  late final _i1.ColumnString deyeUsername;

  late final _i1.ColumnString deyePasswordHash;

  late final _i1.ColumnString deyeAppId;

  late final _i1.ColumnString solcastApiKey;

  late final _i1.ColumnString solcastSiteId;

  late final _i1.ColumnString pstrykToken;

  @override
  List<_i1.Column> get columns => [
    id,
    userInfoId,
    deyeUsername,
    deyePasswordHash,
    deyeAppId,
    solcastApiKey,
    solcastSiteId,
    pstrykToken,
  ];
}

class IntegrationCredentialsInclude extends _i1.IncludeObject {
  IntegrationCredentialsInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => IntegrationCredentials.t;
}

class IntegrationCredentialsIncludeList extends _i1.IncludeList {
  IntegrationCredentialsIncludeList._({
    _i1.WhereExpressionBuilder<IntegrationCredentialsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(IntegrationCredentials.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => IntegrationCredentials.t;
}

class IntegrationCredentialsRepository {
  const IntegrationCredentialsRepository._();

  /// Returns a list of [IntegrationCredentials]s matching the given query parameters.
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
  Future<List<IntegrationCredentials>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<IntegrationCredentialsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IntegrationCredentialsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IntegrationCredentialsTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<IntegrationCredentials>(
      where: where?.call(IntegrationCredentials.t),
      orderBy: orderBy?.call(IntegrationCredentials.t),
      orderByList: orderByList?.call(IntegrationCredentials.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [IntegrationCredentials] matching the given query parameters.
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
  Future<IntegrationCredentials?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<IntegrationCredentialsTable>? where,
    int? offset,
    _i1.OrderByBuilder<IntegrationCredentialsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<IntegrationCredentialsTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<IntegrationCredentials>(
      where: where?.call(IntegrationCredentials.t),
      orderBy: orderBy?.call(IntegrationCredentials.t),
      orderByList: orderByList?.call(IntegrationCredentials.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [IntegrationCredentials] by its [id] or null if no such row exists.
  Future<IntegrationCredentials?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<IntegrationCredentials>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [IntegrationCredentials]s in the list and returns the inserted rows.
  ///
  /// The returned [IntegrationCredentials]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<IntegrationCredentials>> insert(
    _i1.DatabaseSession session,
    List<IntegrationCredentials> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<IntegrationCredentials>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [IntegrationCredentials] and returns the inserted row.
  ///
  /// The returned [IntegrationCredentials] will have its `id` field set.
  Future<IntegrationCredentials> insertRow(
    _i1.DatabaseSession session,
    IntegrationCredentials row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<IntegrationCredentials>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [IntegrationCredentials]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<IntegrationCredentials>> update(
    _i1.DatabaseSession session,
    List<IntegrationCredentials> rows, {
    _i1.ColumnSelections<IntegrationCredentialsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<IntegrationCredentials>(
      rows,
      columns: columns?.call(IntegrationCredentials.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IntegrationCredentials]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<IntegrationCredentials> updateRow(
    _i1.DatabaseSession session,
    IntegrationCredentials row, {
    _i1.ColumnSelections<IntegrationCredentialsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<IntegrationCredentials>(
      row,
      columns: columns?.call(IntegrationCredentials.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IntegrationCredentials] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<IntegrationCredentials?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<IntegrationCredentialsUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<IntegrationCredentials>(
      id,
      columnValues: columnValues(IntegrationCredentials.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [IntegrationCredentials]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<IntegrationCredentials>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<IntegrationCredentialsUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<IntegrationCredentialsTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<IntegrationCredentialsTable>? orderBy,
    _i1.OrderByListBuilder<IntegrationCredentialsTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<IntegrationCredentials>(
      columnValues: columnValues(IntegrationCredentials.t.updateTable),
      where: where(IntegrationCredentials.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IntegrationCredentials.t),
      orderByList: orderByList?.call(IntegrationCredentials.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [IntegrationCredentials]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<IntegrationCredentials>> delete(
    _i1.DatabaseSession session,
    List<IntegrationCredentials> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<IntegrationCredentials>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [IntegrationCredentials].
  Future<IntegrationCredentials> deleteRow(
    _i1.DatabaseSession session,
    IntegrationCredentials row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<IntegrationCredentials>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<IntegrationCredentials>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<IntegrationCredentialsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<IntegrationCredentials>(
      where: where(IntegrationCredentials.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<IntegrationCredentialsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<IntegrationCredentials>(
      where: where?.call(IntegrationCredentials.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [IntegrationCredentials] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<IntegrationCredentialsTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<IntegrationCredentials>(
      where: where(IntegrationCredentials.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
