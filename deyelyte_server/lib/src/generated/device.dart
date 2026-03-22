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

abstract class Device implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Device._({
    this.id,
    required this.userId,
    required this.hashedSerial,
    required this.licenseKey,
    this.lastSeenAt,
    required this.lastInverterOk,
    this.syncIntervalSeconds,
    required this.createdAt,
  });

  factory Device({
    int? id,
    required int userId,
    required String hashedSerial,
    required String licenseKey,
    DateTime? lastSeenAt,
    required bool lastInverterOk,
    int? syncIntervalSeconds,
    required DateTime createdAt,
  }) = _DeviceImpl;

  factory Device.fromJson(Map<String, dynamic> jsonSerialization) {
    return Device(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      hashedSerial: jsonSerialization['hashedSerial'] as String,
      licenseKey: jsonSerialization['licenseKey'] as String,
      lastSeenAt: jsonSerialization['lastSeenAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastSeenAt']),
      lastInverterOk: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['lastInverterOk'],
      ),
      syncIntervalSeconds: jsonSerialization['syncIntervalSeconds'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = DeviceTable();

  static const db = DeviceRepository._();

  @override
  int? id;

  int userId;

  String hashedSerial;

  String licenseKey;

  DateTime? lastSeenAt;

  bool lastInverterOk;

  int? syncIntervalSeconds;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Device]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Device copyWith({
    int? id,
    int? userId,
    String? hashedSerial,
    String? licenseKey,
    DateTime? lastSeenAt,
    bool? lastInverterOk,
    int? syncIntervalSeconds,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Device',
      if (id != null) 'id': id,
      'userId': userId,
      'hashedSerial': hashedSerial,
      'licenseKey': licenseKey,
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
      'lastInverterOk': lastInverterOk,
      if (syncIntervalSeconds != null)
        'syncIntervalSeconds': syncIntervalSeconds,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Device',
      if (id != null) 'id': id,
      'userId': userId,
      'hashedSerial': hashedSerial,
      'licenseKey': licenseKey,
      if (lastSeenAt != null) 'lastSeenAt': lastSeenAt?.toJson(),
      'lastInverterOk': lastInverterOk,
      if (syncIntervalSeconds != null)
        'syncIntervalSeconds': syncIntervalSeconds,
      'createdAt': createdAt.toJson(),
    };
  }

  static DeviceInclude include() {
    return DeviceInclude._();
  }

  static DeviceIncludeList includeList({
    _i1.WhereExpressionBuilder<DeviceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeviceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeviceTable>? orderByList,
    DeviceInclude? include,
  }) {
    return DeviceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Device.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Device.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceImpl extends Device {
  _DeviceImpl({
    int? id,
    required int userId,
    required String hashedSerial,
    required String licenseKey,
    DateTime? lastSeenAt,
    required bool lastInverterOk,
    int? syncIntervalSeconds,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         hashedSerial: hashedSerial,
         licenseKey: licenseKey,
         lastSeenAt: lastSeenAt,
         lastInverterOk: lastInverterOk,
         syncIntervalSeconds: syncIntervalSeconds,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Device]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Device copyWith({
    Object? id = _Undefined,
    int? userId,
    String? hashedSerial,
    String? licenseKey,
    Object? lastSeenAt = _Undefined,
    bool? lastInverterOk,
    Object? syncIntervalSeconds = _Undefined,
    DateTime? createdAt,
  }) {
    return Device(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      hashedSerial: hashedSerial ?? this.hashedSerial,
      licenseKey: licenseKey ?? this.licenseKey,
      lastSeenAt: lastSeenAt is DateTime? ? lastSeenAt : this.lastSeenAt,
      lastInverterOk: lastInverterOk ?? this.lastInverterOk,
      syncIntervalSeconds: syncIntervalSeconds is int?
          ? syncIntervalSeconds
          : this.syncIntervalSeconds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DeviceUpdateTable extends _i1.UpdateTable<DeviceTable> {
  DeviceUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> hashedSerial(String value) => _i1.ColumnValue(
    table.hashedSerial,
    value,
  );

  _i1.ColumnValue<String, String> licenseKey(String value) => _i1.ColumnValue(
    table.licenseKey,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> lastSeenAt(DateTime? value) =>
      _i1.ColumnValue(
        table.lastSeenAt,
        value,
      );

  _i1.ColumnValue<bool, bool> lastInverterOk(bool value) => _i1.ColumnValue(
    table.lastInverterOk,
    value,
  );

  _i1.ColumnValue<int, int> syncIntervalSeconds(int? value) => _i1.ColumnValue(
    table.syncIntervalSeconds,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class DeviceTable extends _i1.Table<int?> {
  DeviceTable({super.tableRelation}) : super(tableName: 'devices') {
    updateTable = DeviceUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    hashedSerial = _i1.ColumnString(
      'hashedSerial',
      this,
    );
    licenseKey = _i1.ColumnString(
      'licenseKey',
      this,
    );
    lastSeenAt = _i1.ColumnDateTime(
      'lastSeenAt',
      this,
    );
    lastInverterOk = _i1.ColumnBool(
      'lastInverterOk',
      this,
    );
    syncIntervalSeconds = _i1.ColumnInt(
      'syncIntervalSeconds',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final DeviceUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString hashedSerial;

  late final _i1.ColumnString licenseKey;

  late final _i1.ColumnDateTime lastSeenAt;

  late final _i1.ColumnBool lastInverterOk;

  late final _i1.ColumnInt syncIntervalSeconds;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    hashedSerial,
    licenseKey,
    lastSeenAt,
    lastInverterOk,
    syncIntervalSeconds,
    createdAt,
  ];
}

class DeviceInclude extends _i1.IncludeObject {
  DeviceInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Device.t;
}

class DeviceIncludeList extends _i1.IncludeList {
  DeviceIncludeList._({
    _i1.WhereExpressionBuilder<DeviceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Device.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Device.t;
}

class DeviceRepository {
  const DeviceRepository._();

  /// Returns a list of [Device]s matching the given query parameters.
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
  Future<List<Device>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeviceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeviceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeviceTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Device>(
      where: where?.call(Device.t),
      orderBy: orderBy?.call(Device.t),
      orderByList: orderByList?.call(Device.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Device] matching the given query parameters.
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
  Future<Device?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeviceTable>? where,
    int? offset,
    _i1.OrderByBuilder<DeviceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<DeviceTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Device>(
      where: where?.call(Device.t),
      orderBy: orderBy?.call(Device.t),
      orderByList: orderByList?.call(Device.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Device] by its [id] or null if no such row exists.
  Future<Device?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Device>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Device]s in the list and returns the inserted rows.
  ///
  /// The returned [Device]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Device>> insert(
    _i1.DatabaseSession session,
    List<Device> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Device>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Device] and returns the inserted row.
  ///
  /// The returned [Device] will have its `id` field set.
  Future<Device> insertRow(
    _i1.DatabaseSession session,
    Device row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Device>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Device]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Device>> update(
    _i1.DatabaseSession session,
    List<Device> rows, {
    _i1.ColumnSelections<DeviceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Device>(
      rows,
      columns: columns?.call(Device.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Device]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Device> updateRow(
    _i1.DatabaseSession session,
    Device row, {
    _i1.ColumnSelections<DeviceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Device>(
      row,
      columns: columns?.call(Device.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Device] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Device?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<DeviceUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Device>(
      id,
      columnValues: columnValues(Device.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Device]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Device>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<DeviceUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<DeviceTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DeviceTable>? orderBy,
    _i1.OrderByListBuilder<DeviceTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Device>(
      columnValues: columnValues(Device.t.updateTable),
      where: where(Device.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Device.t),
      orderByList: orderByList?.call(Device.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Device]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Device>> delete(
    _i1.DatabaseSession session,
    List<Device> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Device>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Device].
  Future<Device> deleteRow(
    _i1.DatabaseSession session,
    Device row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Device>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Device>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DeviceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Device>(
      where: where(Device.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DeviceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Device>(
      where: where?.call(Device.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Device] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DeviceTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Device>(
      where: where(Device.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
