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

abstract class OutageReserve
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = OutageReserveTable();

  static const db = OutageReserveRepository._();

  @override
  int? id;

  int userInfoId;

  DateTime date;

  String? note;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OutageReserve',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'date': date.toJson(),
      if (note != null) 'note': note,
    };
  }

  static OutageReserveInclude include() {
    return OutageReserveInclude._();
  }

  static OutageReserveIncludeList includeList({
    _i1.WhereExpressionBuilder<OutageReserveTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OutageReserveTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OutageReserveTable>? orderByList,
    OutageReserveInclude? include,
  }) {
    return OutageReserveIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OutageReserve.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(OutageReserve.t),
      include: include,
    );
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

class OutageReserveUpdateTable extends _i1.UpdateTable<OutageReserveTable> {
  OutageReserveUpdateTable(super.table);

  _i1.ColumnValue<int, int> userInfoId(int value) => _i1.ColumnValue(
    table.userInfoId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> date(DateTime value) => _i1.ColumnValue(
    table.date,
    value,
  );

  _i1.ColumnValue<String, String> note(String? value) => _i1.ColumnValue(
    table.note,
    value,
  );
}

class OutageReserveTable extends _i1.Table<int?> {
  OutageReserveTable({super.tableRelation})
    : super(tableName: 'outage_reserves') {
    updateTable = OutageReserveUpdateTable(this);
    userInfoId = _i1.ColumnInt(
      'userInfoId',
      this,
    );
    date = _i1.ColumnDateTime(
      'date',
      this,
    );
    note = _i1.ColumnString(
      'note',
      this,
    );
  }

  late final OutageReserveUpdateTable updateTable;

  late final _i1.ColumnInt userInfoId;

  late final _i1.ColumnDateTime date;

  late final _i1.ColumnString note;

  @override
  List<_i1.Column> get columns => [
    id,
    userInfoId,
    date,
    note,
  ];
}

class OutageReserveInclude extends _i1.IncludeObject {
  OutageReserveInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => OutageReserve.t;
}

class OutageReserveIncludeList extends _i1.IncludeList {
  OutageReserveIncludeList._({
    _i1.WhereExpressionBuilder<OutageReserveTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OutageReserve.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => OutageReserve.t;
}

class OutageReserveRepository {
  const OutageReserveRepository._();

  /// Returns a list of [OutageReserve]s matching the given query parameters.
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
  Future<List<OutageReserve>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OutageReserveTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OutageReserveTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OutageReserveTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OutageReserve>(
      where: where?.call(OutageReserve.t),
      orderBy: orderBy?.call(OutageReserve.t),
      orderByList: orderByList?.call(OutageReserve.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OutageReserve] matching the given query parameters.
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
  Future<OutageReserve?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OutageReserveTable>? where,
    int? offset,
    _i1.OrderByBuilder<OutageReserveTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OutageReserveTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OutageReserve>(
      where: where?.call(OutageReserve.t),
      orderBy: orderBy?.call(OutageReserve.t),
      orderByList: orderByList?.call(OutageReserve.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OutageReserve] by its [id] or null if no such row exists.
  Future<OutageReserve?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OutageReserve>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OutageReserve]s in the list and returns the inserted rows.
  ///
  /// The returned [OutageReserve]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<OutageReserve>> insert(
    _i1.DatabaseSession session,
    List<OutageReserve> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<OutageReserve>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [OutageReserve] and returns the inserted row.
  ///
  /// The returned [OutageReserve] will have its `id` field set.
  Future<OutageReserve> insertRow(
    _i1.DatabaseSession session,
    OutageReserve row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<OutageReserve>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [OutageReserve]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<OutageReserve>> update(
    _i1.DatabaseSession session,
    List<OutageReserve> rows, {
    _i1.ColumnSelections<OutageReserveTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<OutageReserve>(
      rows,
      columns: columns?.call(OutageReserve.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OutageReserve]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OutageReserve> updateRow(
    _i1.DatabaseSession session,
    OutageReserve row, {
    _i1.ColumnSelections<OutageReserveTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<OutageReserve>(
      row,
      columns: columns?.call(OutageReserve.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OutageReserve] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OutageReserve?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<OutageReserveUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<OutageReserve>(
      id,
      columnValues: columnValues(OutageReserve.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OutageReserve]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<OutageReserve>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<OutageReserveUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<OutageReserveTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OutageReserveTable>? orderBy,
    _i1.OrderByListBuilder<OutageReserveTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<OutageReserve>(
      columnValues: columnValues(OutageReserve.t.updateTable),
      where: where(OutageReserve.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OutageReserve.t),
      orderByList: orderByList?.call(OutageReserve.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [OutageReserve]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<OutageReserve>> delete(
    _i1.DatabaseSession session,
    List<OutageReserve> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<OutageReserve>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [OutageReserve].
  Future<OutageReserve> deleteRow(
    _i1.DatabaseSession session,
    OutageReserve row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OutageReserve>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<OutageReserve>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OutageReserveTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<OutageReserve>(
      where: where(OutageReserve.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OutageReserveTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<OutageReserve>(
      where: where?.call(OutageReserve.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OutageReserve] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OutageReserveTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OutageReserve>(
      where: where(OutageReserve.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
