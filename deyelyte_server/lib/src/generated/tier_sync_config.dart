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

abstract class TierSyncConfig
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TierSyncConfig._({
    this.id,
    required this.tier,
    required this.syncIntervalSeconds,
    required this.historyDurationDays,
  });

  factory TierSyncConfig({
    int? id,
    required String tier,
    required int syncIntervalSeconds,
    required int historyDurationDays,
  }) = _TierSyncConfigImpl;

  factory TierSyncConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return TierSyncConfig(
      id: jsonSerialization['id'] as int?,
      tier: jsonSerialization['tier'] as String,
      syncIntervalSeconds: jsonSerialization['syncIntervalSeconds'] as int,
      historyDurationDays: jsonSerialization['historyDurationDays'] as int,
    );
  }

  static final t = TierSyncConfigTable();

  static const db = TierSyncConfigRepository._();

  @override
  int? id;

  String tier;

  int syncIntervalSeconds;

  int historyDurationDays;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TierSyncConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TierSyncConfig copyWith({
    int? id,
    String? tier,
    int? syncIntervalSeconds,
    int? historyDurationDays,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TierSyncConfig',
      if (id != null) 'id': id,
      'tier': tier,
      'syncIntervalSeconds': syncIntervalSeconds,
      'historyDurationDays': historyDurationDays,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TierSyncConfig',
      if (id != null) 'id': id,
      'tier': tier,
      'syncIntervalSeconds': syncIntervalSeconds,
      'historyDurationDays': historyDurationDays,
    };
  }

  static TierSyncConfigInclude include() {
    return TierSyncConfigInclude._();
  }

  static TierSyncConfigIncludeList includeList({
    _i1.WhereExpressionBuilder<TierSyncConfigTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TierSyncConfigTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TierSyncConfigTable>? orderByList,
    TierSyncConfigInclude? include,
  }) {
    return TierSyncConfigIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TierSyncConfig.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TierSyncConfig.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TierSyncConfigImpl extends TierSyncConfig {
  _TierSyncConfigImpl({
    int? id,
    required String tier,
    required int syncIntervalSeconds,
    required int historyDurationDays,
  }) : super._(
         id: id,
         tier: tier,
         syncIntervalSeconds: syncIntervalSeconds,
         historyDurationDays: historyDurationDays,
       );

  /// Returns a shallow copy of this [TierSyncConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TierSyncConfig copyWith({
    Object? id = _Undefined,
    String? tier,
    int? syncIntervalSeconds,
    int? historyDurationDays,
  }) {
    return TierSyncConfig(
      id: id is int? ? id : this.id,
      tier: tier ?? this.tier,
      syncIntervalSeconds: syncIntervalSeconds ?? this.syncIntervalSeconds,
      historyDurationDays: historyDurationDays ?? this.historyDurationDays,
    );
  }
}

class TierSyncConfigUpdateTable extends _i1.UpdateTable<TierSyncConfigTable> {
  TierSyncConfigUpdateTable(super.table);

  _i1.ColumnValue<String, String> tier(String value) => _i1.ColumnValue(
    table.tier,
    value,
  );

  _i1.ColumnValue<int, int> syncIntervalSeconds(int value) => _i1.ColumnValue(
    table.syncIntervalSeconds,
    value,
  );

  _i1.ColumnValue<int, int> historyDurationDays(int value) => _i1.ColumnValue(
    table.historyDurationDays,
    value,
  );
}

class TierSyncConfigTable extends _i1.Table<int?> {
  TierSyncConfigTable({super.tableRelation})
    : super(tableName: 'tier_sync_configs') {
    updateTable = TierSyncConfigUpdateTable(this);
    tier = _i1.ColumnString(
      'tier',
      this,
    );
    syncIntervalSeconds = _i1.ColumnInt(
      'syncIntervalSeconds',
      this,
    );
    historyDurationDays = _i1.ColumnInt(
      'historyDurationDays',
      this,
    );
  }

  late final TierSyncConfigUpdateTable updateTable;

  late final _i1.ColumnString tier;

  late final _i1.ColumnInt syncIntervalSeconds;

  late final _i1.ColumnInt historyDurationDays;

  @override
  List<_i1.Column> get columns => [
    id,
    tier,
    syncIntervalSeconds,
    historyDurationDays,
  ];
}

class TierSyncConfigInclude extends _i1.IncludeObject {
  TierSyncConfigInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TierSyncConfig.t;
}

class TierSyncConfigIncludeList extends _i1.IncludeList {
  TierSyncConfigIncludeList._({
    _i1.WhereExpressionBuilder<TierSyncConfigTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TierSyncConfig.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TierSyncConfig.t;
}

class TierSyncConfigRepository {
  const TierSyncConfigRepository._();

  /// Returns a list of [TierSyncConfig]s matching the given query parameters.
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
  Future<List<TierSyncConfig>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<TierSyncConfigTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TierSyncConfigTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TierSyncConfigTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TierSyncConfig>(
      where: where?.call(TierSyncConfig.t),
      orderBy: orderBy?.call(TierSyncConfig.t),
      orderByList: orderByList?.call(TierSyncConfig.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TierSyncConfig] matching the given query parameters.
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
  Future<TierSyncConfig?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<TierSyncConfigTable>? where,
    int? offset,
    _i1.OrderByBuilder<TierSyncConfigTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TierSyncConfigTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TierSyncConfig>(
      where: where?.call(TierSyncConfig.t),
      orderBy: orderBy?.call(TierSyncConfig.t),
      orderByList: orderByList?.call(TierSyncConfig.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TierSyncConfig] by its [id] or null if no such row exists.
  Future<TierSyncConfig?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TierSyncConfig>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TierSyncConfig]s in the list and returns the inserted rows.
  ///
  /// The returned [TierSyncConfig]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<TierSyncConfig>> insert(
    _i1.DatabaseSession session,
    List<TierSyncConfig> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<TierSyncConfig>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [TierSyncConfig] and returns the inserted row.
  ///
  /// The returned [TierSyncConfig] will have its `id` field set.
  Future<TierSyncConfig> insertRow(
    _i1.DatabaseSession session,
    TierSyncConfig row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TierSyncConfig>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TierSyncConfig]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TierSyncConfig>> update(
    _i1.DatabaseSession session,
    List<TierSyncConfig> rows, {
    _i1.ColumnSelections<TierSyncConfigTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TierSyncConfig>(
      rows,
      columns: columns?.call(TierSyncConfig.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TierSyncConfig]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TierSyncConfig> updateRow(
    _i1.DatabaseSession session,
    TierSyncConfig row, {
    _i1.ColumnSelections<TierSyncConfigTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TierSyncConfig>(
      row,
      columns: columns?.call(TierSyncConfig.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TierSyncConfig] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TierSyncConfig?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<TierSyncConfigUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TierSyncConfig>(
      id,
      columnValues: columnValues(TierSyncConfig.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TierSyncConfig]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TierSyncConfig>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<TierSyncConfigUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<TierSyncConfigTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TierSyncConfigTable>? orderBy,
    _i1.OrderByListBuilder<TierSyncConfigTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TierSyncConfig>(
      columnValues: columnValues(TierSyncConfig.t.updateTable),
      where: where(TierSyncConfig.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TierSyncConfig.t),
      orderByList: orderByList?.call(TierSyncConfig.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TierSyncConfig]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TierSyncConfig>> delete(
    _i1.DatabaseSession session,
    List<TierSyncConfig> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TierSyncConfig>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TierSyncConfig].
  Future<TierSyncConfig> deleteRow(
    _i1.DatabaseSession session,
    TierSyncConfig row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TierSyncConfig>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TierSyncConfig>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<TierSyncConfigTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TierSyncConfig>(
      where: where(TierSyncConfig.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<TierSyncConfigTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TierSyncConfig>(
      where: where?.call(TierSyncConfig.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TierSyncConfig] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<TierSyncConfigTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TierSyncConfig>(
      where: where(TierSyncConfig.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
