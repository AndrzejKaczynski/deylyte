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

abstract class PvForecast
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PvForecast._({
    this.id,
    required this.userInfoId,
    required this.timestamp,
    required this.expectedYieldWatts,
  });

  factory PvForecast({
    int? id,
    required int userInfoId,
    required DateTime timestamp,
    required double expectedYieldWatts,
  }) = _PvForecastImpl;

  factory PvForecast.fromJson(Map<String, dynamic> jsonSerialization) {
    return PvForecast(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      expectedYieldWatts: (jsonSerialization['expectedYieldWatts'] as num)
          .toDouble(),
    );
  }

  static final t = PvForecastTable();

  static const db = PvForecastRepository._();

  @override
  int? id;

  int userInfoId;

  DateTime timestamp;

  double expectedYieldWatts;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PvForecast]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PvForecast copyWith({
    int? id,
    int? userInfoId,
    DateTime? timestamp,
    double? expectedYieldWatts,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PvForecast',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'timestamp': timestamp.toJson(),
      'expectedYieldWatts': expectedYieldWatts,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PvForecast',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'timestamp': timestamp.toJson(),
      'expectedYieldWatts': expectedYieldWatts,
    };
  }

  static PvForecastInclude include() {
    return PvForecastInclude._();
  }

  static PvForecastIncludeList includeList({
    _i1.WhereExpressionBuilder<PvForecastTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PvForecastTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PvForecastTable>? orderByList,
    PvForecastInclude? include,
  }) {
    return PvForecastIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PvForecast.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PvForecast.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PvForecastImpl extends PvForecast {
  _PvForecastImpl({
    int? id,
    required int userInfoId,
    required DateTime timestamp,
    required double expectedYieldWatts,
  }) : super._(
         id: id,
         userInfoId: userInfoId,
         timestamp: timestamp,
         expectedYieldWatts: expectedYieldWatts,
       );

  /// Returns a shallow copy of this [PvForecast]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PvForecast copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    DateTime? timestamp,
    double? expectedYieldWatts,
  }) {
    return PvForecast(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      timestamp: timestamp ?? this.timestamp,
      expectedYieldWatts: expectedYieldWatts ?? this.expectedYieldWatts,
    );
  }
}

class PvForecastUpdateTable extends _i1.UpdateTable<PvForecastTable> {
  PvForecastUpdateTable(super.table);

  _i1.ColumnValue<int, int> userInfoId(int value) => _i1.ColumnValue(
    table.userInfoId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> timestamp(DateTime value) =>
      _i1.ColumnValue(
        table.timestamp,
        value,
      );

  _i1.ColumnValue<double, double> expectedYieldWatts(double value) =>
      _i1.ColumnValue(
        table.expectedYieldWatts,
        value,
      );
}

class PvForecastTable extends _i1.Table<int?> {
  PvForecastTable({super.tableRelation}) : super(tableName: 'pv_forecast') {
    updateTable = PvForecastUpdateTable(this);
    userInfoId = _i1.ColumnInt(
      'userInfoId',
      this,
    );
    timestamp = _i1.ColumnDateTime(
      'timestamp',
      this,
    );
    expectedYieldWatts = _i1.ColumnDouble(
      'expectedYieldWatts',
      this,
    );
  }

  late final PvForecastUpdateTable updateTable;

  late final _i1.ColumnInt userInfoId;

  late final _i1.ColumnDateTime timestamp;

  late final _i1.ColumnDouble expectedYieldWatts;

  @override
  List<_i1.Column> get columns => [
    id,
    userInfoId,
    timestamp,
    expectedYieldWatts,
  ];
}

class PvForecastInclude extends _i1.IncludeObject {
  PvForecastInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PvForecast.t;
}

class PvForecastIncludeList extends _i1.IncludeList {
  PvForecastIncludeList._({
    _i1.WhereExpressionBuilder<PvForecastTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PvForecast.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PvForecast.t;
}

class PvForecastRepository {
  const PvForecastRepository._();

  /// Returns a list of [PvForecast]s matching the given query parameters.
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
  Future<List<PvForecast>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PvForecastTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PvForecastTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PvForecastTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PvForecast>(
      where: where?.call(PvForecast.t),
      orderBy: orderBy?.call(PvForecast.t),
      orderByList: orderByList?.call(PvForecast.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PvForecast] matching the given query parameters.
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
  Future<PvForecast?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PvForecastTable>? where,
    int? offset,
    _i1.OrderByBuilder<PvForecastTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PvForecastTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PvForecast>(
      where: where?.call(PvForecast.t),
      orderBy: orderBy?.call(PvForecast.t),
      orderByList: orderByList?.call(PvForecast.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PvForecast] by its [id] or null if no such row exists.
  Future<PvForecast?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PvForecast>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PvForecast]s in the list and returns the inserted rows.
  ///
  /// The returned [PvForecast]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<PvForecast>> insert(
    _i1.DatabaseSession session,
    List<PvForecast> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<PvForecast>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [PvForecast] and returns the inserted row.
  ///
  /// The returned [PvForecast] will have its `id` field set.
  Future<PvForecast> insertRow(
    _i1.DatabaseSession session,
    PvForecast row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PvForecast>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PvForecast]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PvForecast>> update(
    _i1.DatabaseSession session,
    List<PvForecast> rows, {
    _i1.ColumnSelections<PvForecastTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PvForecast>(
      rows,
      columns: columns?.call(PvForecast.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PvForecast]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PvForecast> updateRow(
    _i1.DatabaseSession session,
    PvForecast row, {
    _i1.ColumnSelections<PvForecastTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PvForecast>(
      row,
      columns: columns?.call(PvForecast.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PvForecast] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PvForecast?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<PvForecastUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PvForecast>(
      id,
      columnValues: columnValues(PvForecast.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PvForecast]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PvForecast>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<PvForecastUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PvForecastTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PvForecastTable>? orderBy,
    _i1.OrderByListBuilder<PvForecastTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PvForecast>(
      columnValues: columnValues(PvForecast.t.updateTable),
      where: where(PvForecast.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PvForecast.t),
      orderByList: orderByList?.call(PvForecast.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PvForecast]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PvForecast>> delete(
    _i1.DatabaseSession session,
    List<PvForecast> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PvForecast>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PvForecast].
  Future<PvForecast> deleteRow(
    _i1.DatabaseSession session,
    PvForecast row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PvForecast>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PvForecast>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PvForecastTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PvForecast>(
      where: where(PvForecast.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PvForecastTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PvForecast>(
      where: where?.call(PvForecast.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PvForecast] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PvForecastTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PvForecast>(
      where: where(PvForecast.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
