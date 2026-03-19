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

abstract class InverterData
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  InverterData._({
    this.id,
    required this.userInfoId,
    required this.timestamp,
    required this.pvPower,
    required this.batteryLevel,
    required this.gridPower,
    required this.loadPower,
  });

  factory InverterData({
    int? id,
    required int userInfoId,
    required DateTime timestamp,
    required double pvPower,
    required double batteryLevel,
    required double gridPower,
    required double loadPower,
  }) = _InverterDataImpl;

  factory InverterData.fromJson(Map<String, dynamic> jsonSerialization) {
    return InverterData(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      pvPower: (jsonSerialization['pvPower'] as num).toDouble(),
      batteryLevel: (jsonSerialization['batteryLevel'] as num).toDouble(),
      gridPower: (jsonSerialization['gridPower'] as num).toDouble(),
      loadPower: (jsonSerialization['loadPower'] as num).toDouble(),
    );
  }

  static final t = InverterDataTable();

  static const db = InverterDataRepository._();

  @override
  int? id;

  int userInfoId;

  DateTime timestamp;

  double pvPower;

  double batteryLevel;

  double gridPower;

  double loadPower;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [InverterData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  InverterData copyWith({
    int? id,
    int? userInfoId,
    DateTime? timestamp,
    double? pvPower,
    double? batteryLevel,
    double? gridPower,
    double? loadPower,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InverterData',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'timestamp': timestamp.toJson(),
      'pvPower': pvPower,
      'batteryLevel': batteryLevel,
      'gridPower': gridPower,
      'loadPower': loadPower,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InverterData',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'timestamp': timestamp.toJson(),
      'pvPower': pvPower,
      'batteryLevel': batteryLevel,
      'gridPower': gridPower,
      'loadPower': loadPower,
    };
  }

  static InverterDataInclude include() {
    return InverterDataInclude._();
  }

  static InverterDataIncludeList includeList({
    _i1.WhereExpressionBuilder<InverterDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<InverterDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<InverterDataTable>? orderByList,
    InverterDataInclude? include,
  }) {
    return InverterDataIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(InverterData.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(InverterData.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InverterDataImpl extends InverterData {
  _InverterDataImpl({
    int? id,
    required int userInfoId,
    required DateTime timestamp,
    required double pvPower,
    required double batteryLevel,
    required double gridPower,
    required double loadPower,
  }) : super._(
         id: id,
         userInfoId: userInfoId,
         timestamp: timestamp,
         pvPower: pvPower,
         batteryLevel: batteryLevel,
         gridPower: gridPower,
         loadPower: loadPower,
       );

  /// Returns a shallow copy of this [InverterData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  InverterData copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    DateTime? timestamp,
    double? pvPower,
    double? batteryLevel,
    double? gridPower,
    double? loadPower,
  }) {
    return InverterData(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      timestamp: timestamp ?? this.timestamp,
      pvPower: pvPower ?? this.pvPower,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      gridPower: gridPower ?? this.gridPower,
      loadPower: loadPower ?? this.loadPower,
    );
  }
}

class InverterDataUpdateTable extends _i1.UpdateTable<InverterDataTable> {
  InverterDataUpdateTable(super.table);

  _i1.ColumnValue<int, int> userInfoId(int value) => _i1.ColumnValue(
    table.userInfoId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> timestamp(DateTime value) =>
      _i1.ColumnValue(
        table.timestamp,
        value,
      );

  _i1.ColumnValue<double, double> pvPower(double value) => _i1.ColumnValue(
    table.pvPower,
    value,
  );

  _i1.ColumnValue<double, double> batteryLevel(double value) => _i1.ColumnValue(
    table.batteryLevel,
    value,
  );

  _i1.ColumnValue<double, double> gridPower(double value) => _i1.ColumnValue(
    table.gridPower,
    value,
  );

  _i1.ColumnValue<double, double> loadPower(double value) => _i1.ColumnValue(
    table.loadPower,
    value,
  );
}

class InverterDataTable extends _i1.Table<int?> {
  InverterDataTable({super.tableRelation}) : super(tableName: 'inverter_data') {
    updateTable = InverterDataUpdateTable(this);
    userInfoId = _i1.ColumnInt(
      'userInfoId',
      this,
    );
    timestamp = _i1.ColumnDateTime(
      'timestamp',
      this,
    );
    pvPower = _i1.ColumnDouble(
      'pvPower',
      this,
    );
    batteryLevel = _i1.ColumnDouble(
      'batteryLevel',
      this,
    );
    gridPower = _i1.ColumnDouble(
      'gridPower',
      this,
    );
    loadPower = _i1.ColumnDouble(
      'loadPower',
      this,
    );
  }

  late final InverterDataUpdateTable updateTable;

  late final _i1.ColumnInt userInfoId;

  late final _i1.ColumnDateTime timestamp;

  late final _i1.ColumnDouble pvPower;

  late final _i1.ColumnDouble batteryLevel;

  late final _i1.ColumnDouble gridPower;

  late final _i1.ColumnDouble loadPower;

  @override
  List<_i1.Column> get columns => [
    id,
    userInfoId,
    timestamp,
    pvPower,
    batteryLevel,
    gridPower,
    loadPower,
  ];
}

class InverterDataInclude extends _i1.IncludeObject {
  InverterDataInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => InverterData.t;
}

class InverterDataIncludeList extends _i1.IncludeList {
  InverterDataIncludeList._({
    _i1.WhereExpressionBuilder<InverterDataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(InverterData.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => InverterData.t;
}

class InverterDataRepository {
  const InverterDataRepository._();

  /// Returns a list of [InverterData]s matching the given query parameters.
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
  Future<List<InverterData>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<InverterDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<InverterDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<InverterDataTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<InverterData>(
      where: where?.call(InverterData.t),
      orderBy: orderBy?.call(InverterData.t),
      orderByList: orderByList?.call(InverterData.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [InverterData] matching the given query parameters.
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
  Future<InverterData?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<InverterDataTable>? where,
    int? offset,
    _i1.OrderByBuilder<InverterDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<InverterDataTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<InverterData>(
      where: where?.call(InverterData.t),
      orderBy: orderBy?.call(InverterData.t),
      orderByList: orderByList?.call(InverterData.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [InverterData] by its [id] or null if no such row exists.
  Future<InverterData?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<InverterData>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [InverterData]s in the list and returns the inserted rows.
  ///
  /// The returned [InverterData]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<InverterData>> insert(
    _i1.DatabaseSession session,
    List<InverterData> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<InverterData>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [InverterData] and returns the inserted row.
  ///
  /// The returned [InverterData] will have its `id` field set.
  Future<InverterData> insertRow(
    _i1.DatabaseSession session,
    InverterData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<InverterData>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [InverterData]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<InverterData>> update(
    _i1.DatabaseSession session,
    List<InverterData> rows, {
    _i1.ColumnSelections<InverterDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<InverterData>(
      rows,
      columns: columns?.call(InverterData.t),
      transaction: transaction,
    );
  }

  /// Updates a single [InverterData]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<InverterData> updateRow(
    _i1.DatabaseSession session,
    InverterData row, {
    _i1.ColumnSelections<InverterDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<InverterData>(
      row,
      columns: columns?.call(InverterData.t),
      transaction: transaction,
    );
  }

  /// Updates a single [InverterData] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<InverterData?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<InverterDataUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<InverterData>(
      id,
      columnValues: columnValues(InverterData.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [InverterData]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<InverterData>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<InverterDataUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<InverterDataTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<InverterDataTable>? orderBy,
    _i1.OrderByListBuilder<InverterDataTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<InverterData>(
      columnValues: columnValues(InverterData.t.updateTable),
      where: where(InverterData.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(InverterData.t),
      orderByList: orderByList?.call(InverterData.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [InverterData]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<InverterData>> delete(
    _i1.DatabaseSession session,
    List<InverterData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<InverterData>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [InverterData].
  Future<InverterData> deleteRow(
    _i1.DatabaseSession session,
    InverterData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<InverterData>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<InverterData>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<InverterDataTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<InverterData>(
      where: where(InverterData.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<InverterDataTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<InverterData>(
      where: where?.call(InverterData.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [InverterData] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<InverterDataTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<InverterData>(
      where: where(InverterData.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
