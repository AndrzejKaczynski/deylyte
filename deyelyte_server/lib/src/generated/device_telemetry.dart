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

abstract class DeviceTelemetry
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  DeviceTelemetry._({
    this.id,
    required this.deviceId,
    required this.userId,
    required this.timestamp,
    required this.batterySOC,
    required this.gridPowerW,
    required this.pvPowerW,
    required this.loadPowerW,
    required this.batteryPowerW,
  });

  factory DeviceTelemetry({
    int? id,
    required String deviceId,
    required int userId,
    required DateTime timestamp,
    required double batterySOC,
    required double gridPowerW,
    required double pvPowerW,
    required double loadPowerW,
    required double batteryPowerW,
  }) = _DeviceTelemetryImpl;

  factory DeviceTelemetry.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceTelemetry(
      id: jsonSerialization['id'] as int?,
      deviceId: jsonSerialization['deviceId'] as String,
      userId: jsonSerialization['userId'] as int,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      batterySOC: (jsonSerialization['batterySOC'] as num).toDouble(),
      gridPowerW: (jsonSerialization['gridPowerW'] as num).toDouble(),
      pvPowerW: (jsonSerialization['pvPowerW'] as num).toDouble(),
      loadPowerW: (jsonSerialization['loadPowerW'] as num).toDouble(),
      batteryPowerW: (jsonSerialization['batteryPowerW'] as num).toDouble(),
    );
  }

  static final t = DeviceTelemetryTable();

  static const db = DeviceTelemetryRepository._();

  @override
  int? id;

  String deviceId;

  int userId;

  DateTime timestamp;

  double batterySOC;

  double gridPowerW;

  double pvPowerW;

  double loadPowerW;

  double batteryPowerW;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [DeviceTelemetry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeviceTelemetry copyWith({
    int? id,
    String? deviceId,
    int? userId,
    DateTime? timestamp,
    double? batterySOC,
    double? gridPowerW,
    double? pvPowerW,
    double? loadPowerW,
    double? batteryPowerW,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceTelemetry',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      'userId': userId,
      'timestamp': timestamp.toJson(),
      'batterySOC': batterySOC,
      'gridPowerW': gridPowerW,
      'pvPowerW': pvPowerW,
      'loadPowerW': loadPowerW,
      'batteryPowerW': batteryPowerW,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceTelemetry',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      'userId': userId,
      'timestamp': timestamp.toJson(),
      'batterySOC': batterySOC,
      'gridPowerW': gridPowerW,
      'pvPowerW': pvPowerW,
      'loadPowerW': loadPowerW,
      'batteryPowerW': batteryPowerW,
    };
  }

  static DeviceTelemetryInclude include() {
    return DeviceTelemetryInclude._();
  }

  static DeviceTelemetryIncludeList includeList({
    _i1.WhereExpressionBuilder<DeviceTelemetryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeviceTelemetryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeviceTelemetryTable>? orderByList,
    DeviceTelemetryInclude? include,
  }) {
    return DeviceTelemetryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceTelemetry.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(DeviceTelemetry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceTelemetryImpl extends DeviceTelemetry {
  _DeviceTelemetryImpl({
    int? id,
    required String deviceId,
    required int userId,
    required DateTime timestamp,
    required double batterySOC,
    required double gridPowerW,
    required double pvPowerW,
    required double loadPowerW,
    required double batteryPowerW,
  }) : super._(
         id: id,
         deviceId: deviceId,
         userId: userId,
         timestamp: timestamp,
         batterySOC: batterySOC,
         gridPowerW: gridPowerW,
         pvPowerW: pvPowerW,
         loadPowerW: loadPowerW,
         batteryPowerW: batteryPowerW,
       );

  /// Returns a shallow copy of this [DeviceTelemetry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeviceTelemetry copyWith({
    Object? id = _Undefined,
    String? deviceId,
    int? userId,
    DateTime? timestamp,
    double? batterySOC,
    double? gridPowerW,
    double? pvPowerW,
    double? loadPowerW,
    double? batteryPowerW,
  }) {
    return DeviceTelemetry(
      id: id is int? ? id : this.id,
      deviceId: deviceId ?? this.deviceId,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      batterySOC: batterySOC ?? this.batterySOC,
      gridPowerW: gridPowerW ?? this.gridPowerW,
      pvPowerW: pvPowerW ?? this.pvPowerW,
      loadPowerW: loadPowerW ?? this.loadPowerW,
      batteryPowerW: batteryPowerW ?? this.batteryPowerW,
    );
  }
}

class DeviceTelemetryUpdateTable extends _i1.UpdateTable<DeviceTelemetryTable> {
  DeviceTelemetryUpdateTable(super.table);

  _i1.ColumnValue<String, String> deviceId(String value) => _i1.ColumnValue(
    table.deviceId,
    value,
  );

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> timestamp(DateTime value) =>
      _i1.ColumnValue(
        table.timestamp,
        value,
      );

  _i1.ColumnValue<double, double> batterySOC(double value) => _i1.ColumnValue(
    table.batterySOC,
    value,
  );

  _i1.ColumnValue<double, double> gridPowerW(double value) => _i1.ColumnValue(
    table.gridPowerW,
    value,
  );

  _i1.ColumnValue<double, double> pvPowerW(double value) => _i1.ColumnValue(
    table.pvPowerW,
    value,
  );

  _i1.ColumnValue<double, double> loadPowerW(double value) => _i1.ColumnValue(
    table.loadPowerW,
    value,
  );

  _i1.ColumnValue<double, double> batteryPowerW(double value) =>
      _i1.ColumnValue(
        table.batteryPowerW,
        value,
      );
}

class DeviceTelemetryTable extends _i1.Table<int?> {
  DeviceTelemetryTable({super.tableRelation})
    : super(tableName: 'device_telemetry') {
    updateTable = DeviceTelemetryUpdateTable(this);
    deviceId = _i1.ColumnString(
      'deviceId',
      this,
    );
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    timestamp = _i1.ColumnDateTime(
      'timestamp',
      this,
    );
    batterySOC = _i1.ColumnDouble(
      'batterySOC',
      this,
    );
    gridPowerW = _i1.ColumnDouble(
      'gridPowerW',
      this,
    );
    pvPowerW = _i1.ColumnDouble(
      'pvPowerW',
      this,
    );
    loadPowerW = _i1.ColumnDouble(
      'loadPowerW',
      this,
    );
    batteryPowerW = _i1.ColumnDouble(
      'batteryPowerW',
      this,
    );
  }

  late final DeviceTelemetryUpdateTable updateTable;

  late final _i1.ColumnString deviceId;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnDateTime timestamp;

  late final _i1.ColumnDouble batterySOC;

  late final _i1.ColumnDouble gridPowerW;

  late final _i1.ColumnDouble pvPowerW;

  late final _i1.ColumnDouble loadPowerW;

  late final _i1.ColumnDouble batteryPowerW;

  @override
  List<_i1.Column> get columns => [
    id,
    deviceId,
    userId,
    timestamp,
    batterySOC,
    gridPowerW,
    pvPowerW,
    loadPowerW,
    batteryPowerW,
  ];
}

class DeviceTelemetryInclude extends _i1.IncludeObject {
  DeviceTelemetryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => DeviceTelemetry.t;
}

class DeviceTelemetryIncludeList extends _i1.IncludeList {
  DeviceTelemetryIncludeList._({
    _i1.WhereExpressionBuilder<DeviceTelemetryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeviceTelemetry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DeviceTelemetry.t;
}

class DeviceTelemetryRepository {
  const DeviceTelemetryRepository._();

  /// Returns a list of [DeviceTelemetry]s matching the given query parameters.
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
  Future<List<DeviceTelemetry>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeviceTelemetryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeviceTelemetryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeviceTelemetryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeviceTelemetry>(
      where: where?.call(DeviceTelemetry.t),
      orderBy: orderBy?.call(DeviceTelemetry.t),
      orderByList: orderByList?.call(DeviceTelemetry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DeviceTelemetry] matching the given query parameters.
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
  Future<DeviceTelemetry?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeviceTelemetryTable>? where,
    int? offset,
    _i1.OrderByBuilder<DeviceTelemetryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeviceTelemetryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeviceTelemetry>(
      where: where?.call(DeviceTelemetry.t),
      orderBy: orderBy?.call(DeviceTelemetry.t),
      orderByList: orderByList?.call(DeviceTelemetry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeviceTelemetry] by its [id] or null if no such row exists.
  Future<DeviceTelemetry?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeviceTelemetry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeviceTelemetry]s in the list and returns the inserted rows.
  ///
  /// The returned [DeviceTelemetry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<DeviceTelemetry>> insert(
    _i1.DatabaseSession session,
    List<DeviceTelemetry> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<DeviceTelemetry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [DeviceTelemetry] and returns the inserted row.
  ///
  /// The returned [DeviceTelemetry] will have its `id` field set.
  Future<DeviceTelemetry> insertRow(
    _i1.DatabaseSession session,
    DeviceTelemetry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeviceTelemetry>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DeviceTelemetry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DeviceTelemetry>> update(
    _i1.DatabaseSession session,
    List<DeviceTelemetry> rows, {
    _i1.ColumnSelections<DeviceTelemetryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DeviceTelemetry>(
      rows,
      columns: columns?.call(DeviceTelemetry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeviceTelemetry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeviceTelemetry> updateRow(
    _i1.DatabaseSession session,
    DeviceTelemetry row, {
    _i1.ColumnSelections<DeviceTelemetryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeviceTelemetry>(
      row,
      columns: columns?.call(DeviceTelemetry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeviceTelemetry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeviceTelemetry?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<DeviceTelemetryUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DeviceTelemetry>(
      id,
      columnValues: columnValues(DeviceTelemetry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeviceTelemetry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DeviceTelemetry>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<DeviceTelemetryUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<DeviceTelemetryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeviceTelemetryTable>? orderBy,
    _i1.OrderByListBuilder<DeviceTelemetryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DeviceTelemetry>(
      columnValues: columnValues(DeviceTelemetry.t.updateTable),
      where: where(DeviceTelemetry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeviceTelemetry.t),
      orderByList: orderByList?.call(DeviceTelemetry.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DeviceTelemetry]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DeviceTelemetry>> delete(
    _i1.DatabaseSession session,
    List<DeviceTelemetry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DeviceTelemetry>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [DeviceTelemetry].
  Future<DeviceTelemetry> deleteRow(
    _i1.DatabaseSession session,
    DeviceTelemetry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeviceTelemetry>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<DeviceTelemetry>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DeviceTelemetryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DeviceTelemetry>(
      where: where(DeviceTelemetry.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeviceTelemetryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DeviceTelemetry>(
      where: where?.call(DeviceTelemetry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeviceTelemetry] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DeviceTelemetryTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeviceTelemetry>(
      where: where(DeviceTelemetry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
