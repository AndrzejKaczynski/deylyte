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

abstract class OptimizationFrame
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  OptimizationFrame._({
    this.id,
    required this.userInfoId,
    required this.generatedAt,
    required this.hour,
    required this.command,
    this.targetSocPercent,
    required this.reason,
    required this.estimatedSocAtStart,
    required this.expectedNetLoadW,
    required this.expectedPvW,
  });

  factory OptimizationFrame({
    int? id,
    required int userInfoId,
    required DateTime generatedAt,
    required DateTime hour,
    required String command,
    double? targetSocPercent,
    required String reason,
    required double estimatedSocAtStart,
    required double expectedNetLoadW,
    required double expectedPvW,
  }) = _OptimizationFrameImpl;

  factory OptimizationFrame.fromJson(Map<String, dynamic> jsonSerialization) {
    return OptimizationFrame(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      generatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['generatedAt'],
      ),
      hour: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['hour']),
      command: jsonSerialization['command'] as String,
      targetSocPercent: (jsonSerialization['targetSocPercent'] as num?)
          ?.toDouble(),
      reason: jsonSerialization['reason'] as String,
      estimatedSocAtStart: (jsonSerialization['estimatedSocAtStart'] as num)
          .toDouble(),
      expectedNetLoadW: (jsonSerialization['expectedNetLoadW'] as num)
          .toDouble(),
      expectedPvW: (jsonSerialization['expectedPvW'] as num).toDouble(),
    );
  }

  static final t = OptimizationFrameTable();

  static const db = OptimizationFrameRepository._();

  @override
  int? id;

  int userInfoId;

  DateTime generatedAt;

  DateTime hour;

  String command;

  double? targetSocPercent;

  String reason;

  double estimatedSocAtStart;

  double expectedNetLoadW;

  double expectedPvW;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [OptimizationFrame]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OptimizationFrame copyWith({
    int? id,
    int? userInfoId,
    DateTime? generatedAt,
    DateTime? hour,
    String? command,
    double? targetSocPercent,
    String? reason,
    double? estimatedSocAtStart,
    double? expectedNetLoadW,
    double? expectedPvW,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OptimizationFrame',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'generatedAt': generatedAt.toJson(),
      'hour': hour.toJson(),
      'command': command,
      if (targetSocPercent != null) 'targetSocPercent': targetSocPercent,
      'reason': reason,
      'estimatedSocAtStart': estimatedSocAtStart,
      'expectedNetLoadW': expectedNetLoadW,
      'expectedPvW': expectedPvW,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OptimizationFrame',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'generatedAt': generatedAt.toJson(),
      'hour': hour.toJson(),
      'command': command,
      if (targetSocPercent != null) 'targetSocPercent': targetSocPercent,
      'reason': reason,
      'estimatedSocAtStart': estimatedSocAtStart,
      'expectedNetLoadW': expectedNetLoadW,
      'expectedPvW': expectedPvW,
    };
  }

  static OptimizationFrameInclude include() {
    return OptimizationFrameInclude._();
  }

  static OptimizationFrameIncludeList includeList({
    _i1.WhereExpressionBuilder<OptimizationFrameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OptimizationFrameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OptimizationFrameTable>? orderByList,
    OptimizationFrameInclude? include,
  }) {
    return OptimizationFrameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OptimizationFrame.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(OptimizationFrame.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OptimizationFrameImpl extends OptimizationFrame {
  _OptimizationFrameImpl({
    int? id,
    required int userInfoId,
    required DateTime generatedAt,
    required DateTime hour,
    required String command,
    double? targetSocPercent,
    required String reason,
    required double estimatedSocAtStart,
    required double expectedNetLoadW,
    required double expectedPvW,
  }) : super._(
         id: id,
         userInfoId: userInfoId,
         generatedAt: generatedAt,
         hour: hour,
         command: command,
         targetSocPercent: targetSocPercent,
         reason: reason,
         estimatedSocAtStart: estimatedSocAtStart,
         expectedNetLoadW: expectedNetLoadW,
         expectedPvW: expectedPvW,
       );

  /// Returns a shallow copy of this [OptimizationFrame]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OptimizationFrame copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    DateTime? generatedAt,
    DateTime? hour,
    String? command,
    Object? targetSocPercent = _Undefined,
    String? reason,
    double? estimatedSocAtStart,
    double? expectedNetLoadW,
    double? expectedPvW,
  }) {
    return OptimizationFrame(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      generatedAt: generatedAt ?? this.generatedAt,
      hour: hour ?? this.hour,
      command: command ?? this.command,
      targetSocPercent: targetSocPercent is double?
          ? targetSocPercent
          : this.targetSocPercent,
      reason: reason ?? this.reason,
      estimatedSocAtStart: estimatedSocAtStart ?? this.estimatedSocAtStart,
      expectedNetLoadW: expectedNetLoadW ?? this.expectedNetLoadW,
      expectedPvW: expectedPvW ?? this.expectedPvW,
    );
  }
}

class OptimizationFrameUpdateTable
    extends _i1.UpdateTable<OptimizationFrameTable> {
  OptimizationFrameUpdateTable(super.table);

  _i1.ColumnValue<int, int> userInfoId(int value) => _i1.ColumnValue(
    table.userInfoId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> generatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.generatedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> hour(DateTime value) => _i1.ColumnValue(
    table.hour,
    value,
  );

  _i1.ColumnValue<String, String> command(String value) => _i1.ColumnValue(
    table.command,
    value,
  );

  _i1.ColumnValue<double, double> targetSocPercent(double? value) =>
      _i1.ColumnValue(
        table.targetSocPercent,
        value,
      );

  _i1.ColumnValue<String, String> reason(String value) => _i1.ColumnValue(
    table.reason,
    value,
  );

  _i1.ColumnValue<double, double> estimatedSocAtStart(double value) =>
      _i1.ColumnValue(
        table.estimatedSocAtStart,
        value,
      );

  _i1.ColumnValue<double, double> expectedNetLoadW(double value) =>
      _i1.ColumnValue(
        table.expectedNetLoadW,
        value,
      );

  _i1.ColumnValue<double, double> expectedPvW(double value) => _i1.ColumnValue(
    table.expectedPvW,
    value,
  );
}

class OptimizationFrameTable extends _i1.Table<int?> {
  OptimizationFrameTable({super.tableRelation})
    : super(tableName: 'optimization_frames') {
    updateTable = OptimizationFrameUpdateTable(this);
    userInfoId = _i1.ColumnInt(
      'userInfoId',
      this,
    );
    generatedAt = _i1.ColumnDateTime(
      'generatedAt',
      this,
    );
    hour = _i1.ColumnDateTime(
      'hour',
      this,
    );
    command = _i1.ColumnString(
      'command',
      this,
    );
    targetSocPercent = _i1.ColumnDouble(
      'targetSocPercent',
      this,
    );
    reason = _i1.ColumnString(
      'reason',
      this,
    );
    estimatedSocAtStart = _i1.ColumnDouble(
      'estimatedSocAtStart',
      this,
    );
    expectedNetLoadW = _i1.ColumnDouble(
      'expectedNetLoadW',
      this,
    );
    expectedPvW = _i1.ColumnDouble(
      'expectedPvW',
      this,
    );
  }

  late final OptimizationFrameUpdateTable updateTable;

  late final _i1.ColumnInt userInfoId;

  late final _i1.ColumnDateTime generatedAt;

  late final _i1.ColumnDateTime hour;

  late final _i1.ColumnString command;

  late final _i1.ColumnDouble targetSocPercent;

  late final _i1.ColumnString reason;

  late final _i1.ColumnDouble estimatedSocAtStart;

  late final _i1.ColumnDouble expectedNetLoadW;

  late final _i1.ColumnDouble expectedPvW;

  @override
  List<_i1.Column> get columns => [
    id,
    userInfoId,
    generatedAt,
    hour,
    command,
    targetSocPercent,
    reason,
    estimatedSocAtStart,
    expectedNetLoadW,
    expectedPvW,
  ];
}

class OptimizationFrameInclude extends _i1.IncludeObject {
  OptimizationFrameInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => OptimizationFrame.t;
}

class OptimizationFrameIncludeList extends _i1.IncludeList {
  OptimizationFrameIncludeList._({
    _i1.WhereExpressionBuilder<OptimizationFrameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OptimizationFrame.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => OptimizationFrame.t;
}

class OptimizationFrameRepository {
  const OptimizationFrameRepository._();

  /// Returns a list of [OptimizationFrame]s matching the given query parameters.
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
  Future<List<OptimizationFrame>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OptimizationFrameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OptimizationFrameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OptimizationFrameTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OptimizationFrame>(
      where: where?.call(OptimizationFrame.t),
      orderBy: orderBy?.call(OptimizationFrame.t),
      orderByList: orderByList?.call(OptimizationFrame.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OptimizationFrame] matching the given query parameters.
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
  Future<OptimizationFrame?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OptimizationFrameTable>? where,
    int? offset,
    _i1.OrderByBuilder<OptimizationFrameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OptimizationFrameTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OptimizationFrame>(
      where: where?.call(OptimizationFrame.t),
      orderBy: orderBy?.call(OptimizationFrame.t),
      orderByList: orderByList?.call(OptimizationFrame.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OptimizationFrame] by its [id] or null if no such row exists.
  Future<OptimizationFrame?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OptimizationFrame>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OptimizationFrame]s in the list and returns the inserted rows.
  ///
  /// The returned [OptimizationFrame]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<OptimizationFrame>> insert(
    _i1.DatabaseSession session,
    List<OptimizationFrame> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<OptimizationFrame>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [OptimizationFrame] and returns the inserted row.
  ///
  /// The returned [OptimizationFrame] will have its `id` field set.
  Future<OptimizationFrame> insertRow(
    _i1.DatabaseSession session,
    OptimizationFrame row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<OptimizationFrame>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [OptimizationFrame]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<OptimizationFrame>> update(
    _i1.DatabaseSession session,
    List<OptimizationFrame> rows, {
    _i1.ColumnSelections<OptimizationFrameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<OptimizationFrame>(
      rows,
      columns: columns?.call(OptimizationFrame.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OptimizationFrame]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OptimizationFrame> updateRow(
    _i1.DatabaseSession session,
    OptimizationFrame row, {
    _i1.ColumnSelections<OptimizationFrameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<OptimizationFrame>(
      row,
      columns: columns?.call(OptimizationFrame.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OptimizationFrame] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OptimizationFrame?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<OptimizationFrameUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<OptimizationFrame>(
      id,
      columnValues: columnValues(OptimizationFrame.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OptimizationFrame]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<OptimizationFrame>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<OptimizationFrameUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<OptimizationFrameTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OptimizationFrameTable>? orderBy,
    _i1.OrderByListBuilder<OptimizationFrameTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<OptimizationFrame>(
      columnValues: columnValues(OptimizationFrame.t.updateTable),
      where: where(OptimizationFrame.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OptimizationFrame.t),
      orderByList: orderByList?.call(OptimizationFrame.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [OptimizationFrame]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<OptimizationFrame>> delete(
    _i1.DatabaseSession session,
    List<OptimizationFrame> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<OptimizationFrame>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [OptimizationFrame].
  Future<OptimizationFrame> deleteRow(
    _i1.DatabaseSession session,
    OptimizationFrame row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OptimizationFrame>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<OptimizationFrame>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OptimizationFrameTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<OptimizationFrame>(
      where: where(OptimizationFrame.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OptimizationFrameTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<OptimizationFrame>(
      where: where?.call(OptimizationFrame.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OptimizationFrame] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OptimizationFrameTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OptimizationFrame>(
      where: where(OptimizationFrame.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
