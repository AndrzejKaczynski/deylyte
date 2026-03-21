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

abstract class PriceTimeRange
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PriceTimeRange._({
    this.id,
    required this.userInfoId,
    required this.hourStart,
    required this.hourEnd,
    required this.ratePln,
    this.sellRatePln,
  });

  factory PriceTimeRange({
    int? id,
    required int userInfoId,
    required int hourStart,
    required int hourEnd,
    required double ratePln,
    double? sellRatePln,
  }) = _PriceTimeRangeImpl;

  factory PriceTimeRange.fromJson(Map<String, dynamic> jsonSerialization) {
    return PriceTimeRange(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      hourStart: jsonSerialization['hourStart'] as int,
      hourEnd: jsonSerialization['hourEnd'] as int,
      ratePln: (jsonSerialization['ratePln'] as num).toDouble(),
      sellRatePln: (jsonSerialization['sellRatePln'] as num?)?.toDouble(),
    );
  }

  static final t = PriceTimeRangeTable();

  static const db = PriceTimeRangeRepository._();

  @override
  int? id;

  int userInfoId;

  int hourStart;

  int hourEnd;

  double ratePln;

  double? sellRatePln;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PriceTimeRange]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PriceTimeRange copyWith({
    int? id,
    int? userInfoId,
    int? hourStart,
    int? hourEnd,
    double? ratePln,
    double? sellRatePln,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PriceTimeRange',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'hourStart': hourStart,
      'hourEnd': hourEnd,
      'ratePln': ratePln,
      if (sellRatePln != null) 'sellRatePln': sellRatePln,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PriceTimeRange',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'hourStart': hourStart,
      'hourEnd': hourEnd,
      'ratePln': ratePln,
      if (sellRatePln != null) 'sellRatePln': sellRatePln,
    };
  }

  static PriceTimeRangeInclude include() {
    return PriceTimeRangeInclude._();
  }

  static PriceTimeRangeIncludeList includeList({
    _i1.WhereExpressionBuilder<PriceTimeRangeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PriceTimeRangeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PriceTimeRangeTable>? orderByList,
    PriceTimeRangeInclude? include,
  }) {
    return PriceTimeRangeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PriceTimeRange.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PriceTimeRange.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PriceTimeRangeImpl extends PriceTimeRange {
  _PriceTimeRangeImpl({
    int? id,
    required int userInfoId,
    required int hourStart,
    required int hourEnd,
    required double ratePln,
    double? sellRatePln,
  }) : super._(
         id: id,
         userInfoId: userInfoId,
         hourStart: hourStart,
         hourEnd: hourEnd,
         ratePln: ratePln,
         sellRatePln: sellRatePln,
       );

  /// Returns a shallow copy of this [PriceTimeRange]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PriceTimeRange copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    int? hourStart,
    int? hourEnd,
    double? ratePln,
    Object? sellRatePln = _Undefined,
  }) {
    return PriceTimeRange(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      hourStart: hourStart ?? this.hourStart,
      hourEnd: hourEnd ?? this.hourEnd,
      ratePln: ratePln ?? this.ratePln,
      sellRatePln: sellRatePln is double? ? sellRatePln : this.sellRatePln,
    );
  }
}

class PriceTimeRangeUpdateTable extends _i1.UpdateTable<PriceTimeRangeTable> {
  PriceTimeRangeUpdateTable(super.table);

  _i1.ColumnValue<int, int> userInfoId(int value) => _i1.ColumnValue(
    table.userInfoId,
    value,
  );

  _i1.ColumnValue<int, int> hourStart(int value) => _i1.ColumnValue(
    table.hourStart,
    value,
  );

  _i1.ColumnValue<int, int> hourEnd(int value) => _i1.ColumnValue(
    table.hourEnd,
    value,
  );

  _i1.ColumnValue<double, double> ratePln(double value) => _i1.ColumnValue(
    table.ratePln,
    value,
  );

  _i1.ColumnValue<double, double> sellRatePln(double? value) => _i1.ColumnValue(
    table.sellRatePln,
    value,
  );
}

class PriceTimeRangeTable extends _i1.Table<int?> {
  PriceTimeRangeTable({super.tableRelation})
    : super(tableName: 'price_time_range') {
    updateTable = PriceTimeRangeUpdateTable(this);
    userInfoId = _i1.ColumnInt(
      'userInfoId',
      this,
    );
    hourStart = _i1.ColumnInt(
      'hourStart',
      this,
    );
    hourEnd = _i1.ColumnInt(
      'hourEnd',
      this,
    );
    ratePln = _i1.ColumnDouble(
      'ratePln',
      this,
    );
    sellRatePln = _i1.ColumnDouble(
      'sellRatePln',
      this,
    );
  }

  late final PriceTimeRangeUpdateTable updateTable;

  late final _i1.ColumnInt userInfoId;

  late final _i1.ColumnInt hourStart;

  late final _i1.ColumnInt hourEnd;

  late final _i1.ColumnDouble ratePln;

  late final _i1.ColumnDouble sellRatePln;

  @override
  List<_i1.Column> get columns => [
    id,
    userInfoId,
    hourStart,
    hourEnd,
    ratePln,
    sellRatePln,
  ];
}

class PriceTimeRangeInclude extends _i1.IncludeObject {
  PriceTimeRangeInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PriceTimeRange.t;
}

class PriceTimeRangeIncludeList extends _i1.IncludeList {
  PriceTimeRangeIncludeList._({
    _i1.WhereExpressionBuilder<PriceTimeRangeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PriceTimeRange.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PriceTimeRange.t;
}

class PriceTimeRangeRepository {
  const PriceTimeRangeRepository._();

  /// Returns a list of [PriceTimeRange]s matching the given query parameters.
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
  Future<List<PriceTimeRange>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PriceTimeRangeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PriceTimeRangeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PriceTimeRangeTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PriceTimeRange>(
      where: where?.call(PriceTimeRange.t),
      orderBy: orderBy?.call(PriceTimeRange.t),
      orderByList: orderByList?.call(PriceTimeRange.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PriceTimeRange] matching the given query parameters.
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
  Future<PriceTimeRange?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PriceTimeRangeTable>? where,
    int? offset,
    _i1.OrderByBuilder<PriceTimeRangeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PriceTimeRangeTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PriceTimeRange>(
      where: where?.call(PriceTimeRange.t),
      orderBy: orderBy?.call(PriceTimeRange.t),
      orderByList: orderByList?.call(PriceTimeRange.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PriceTimeRange] by its [id] or null if no such row exists.
  Future<PriceTimeRange?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PriceTimeRange>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PriceTimeRange]s in the list and returns the inserted rows.
  ///
  /// The returned [PriceTimeRange]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<PriceTimeRange>> insert(
    _i1.DatabaseSession session,
    List<PriceTimeRange> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<PriceTimeRange>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [PriceTimeRange] and returns the inserted row.
  ///
  /// The returned [PriceTimeRange] will have its `id` field set.
  Future<PriceTimeRange> insertRow(
    _i1.DatabaseSession session,
    PriceTimeRange row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PriceTimeRange>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PriceTimeRange]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PriceTimeRange>> update(
    _i1.DatabaseSession session,
    List<PriceTimeRange> rows, {
    _i1.ColumnSelections<PriceTimeRangeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PriceTimeRange>(
      rows,
      columns: columns?.call(PriceTimeRange.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PriceTimeRange]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PriceTimeRange> updateRow(
    _i1.DatabaseSession session,
    PriceTimeRange row, {
    _i1.ColumnSelections<PriceTimeRangeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PriceTimeRange>(
      row,
      columns: columns?.call(PriceTimeRange.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PriceTimeRange] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PriceTimeRange?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<PriceTimeRangeUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PriceTimeRange>(
      id,
      columnValues: columnValues(PriceTimeRange.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PriceTimeRange]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PriceTimeRange>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<PriceTimeRangeUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PriceTimeRangeTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PriceTimeRangeTable>? orderBy,
    _i1.OrderByListBuilder<PriceTimeRangeTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PriceTimeRange>(
      columnValues: columnValues(PriceTimeRange.t.updateTable),
      where: where(PriceTimeRange.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PriceTimeRange.t),
      orderByList: orderByList?.call(PriceTimeRange.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PriceTimeRange]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PriceTimeRange>> delete(
    _i1.DatabaseSession session,
    List<PriceTimeRange> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PriceTimeRange>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PriceTimeRange].
  Future<PriceTimeRange> deleteRow(
    _i1.DatabaseSession session,
    PriceTimeRange row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PriceTimeRange>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PriceTimeRange>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PriceTimeRangeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PriceTimeRange>(
      where: where(PriceTimeRange.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PriceTimeRangeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PriceTimeRange>(
      where: where?.call(PriceTimeRange.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PriceTimeRange] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PriceTimeRangeTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PriceTimeRange>(
      where: where(PriceTimeRange.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
