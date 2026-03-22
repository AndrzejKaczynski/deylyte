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

abstract class InverterModel
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  InverterModel._({
    this.id,
    required this.modelId,
    required this.displayName,
    required this.registerMapJson,
  });

  factory InverterModel({
    int? id,
    required String modelId,
    required String displayName,
    required String registerMapJson,
  }) = _InverterModelImpl;

  factory InverterModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return InverterModel(
      id: jsonSerialization['id'] as int?,
      modelId: jsonSerialization['modelId'] as String,
      displayName: jsonSerialization['displayName'] as String,
      registerMapJson: jsonSerialization['registerMapJson'] as String,
    );
  }

  static final t = InverterModelTable();

  static const db = InverterModelRepository._();

  @override
  int? id;

  String modelId;

  String displayName;

  String registerMapJson;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [InverterModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  InverterModel copyWith({
    int? id,
    String? modelId,
    String? displayName,
    String? registerMapJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InverterModel',
      if (id != null) 'id': id,
      'modelId': modelId,
      'displayName': displayName,
      'registerMapJson': registerMapJson,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InverterModel',
      if (id != null) 'id': id,
      'modelId': modelId,
      'displayName': displayName,
      'registerMapJson': registerMapJson,
    };
  }

  static InverterModelInclude include() {
    return InverterModelInclude._();
  }

  static InverterModelIncludeList includeList({
    _i1.WhereExpressionBuilder<InverterModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<InverterModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<InverterModelTable>? orderByList,
    InverterModelInclude? include,
  }) {
    return InverterModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(InverterModel.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(InverterModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InverterModelImpl extends InverterModel {
  _InverterModelImpl({
    int? id,
    required String modelId,
    required String displayName,
    required String registerMapJson,
  }) : super._(
         id: id,
         modelId: modelId,
         displayName: displayName,
         registerMapJson: registerMapJson,
       );

  /// Returns a shallow copy of this [InverterModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  InverterModel copyWith({
    Object? id = _Undefined,
    String? modelId,
    String? displayName,
    String? registerMapJson,
  }) {
    return InverterModel(
      id: id is int? ? id : this.id,
      modelId: modelId ?? this.modelId,
      displayName: displayName ?? this.displayName,
      registerMapJson: registerMapJson ?? this.registerMapJson,
    );
  }
}

class InverterModelUpdateTable extends _i1.UpdateTable<InverterModelTable> {
  InverterModelUpdateTable(super.table);

  _i1.ColumnValue<String, String> modelId(String value) => _i1.ColumnValue(
    table.modelId,
    value,
  );

  _i1.ColumnValue<String, String> displayName(String value) => _i1.ColumnValue(
    table.displayName,
    value,
  );

  _i1.ColumnValue<String, String> registerMapJson(String value) =>
      _i1.ColumnValue(
        table.registerMapJson,
        value,
      );
}

class InverterModelTable extends _i1.Table<int?> {
  InverterModelTable({super.tableRelation})
    : super(tableName: 'inverter_models') {
    updateTable = InverterModelUpdateTable(this);
    modelId = _i1.ColumnString(
      'modelId',
      this,
    );
    displayName = _i1.ColumnString(
      'displayName',
      this,
    );
    registerMapJson = _i1.ColumnString(
      'registerMapJson',
      this,
    );
  }

  late final InverterModelUpdateTable updateTable;

  late final _i1.ColumnString modelId;

  late final _i1.ColumnString displayName;

  late final _i1.ColumnString registerMapJson;

  @override
  List<_i1.Column> get columns => [
    id,
    modelId,
    displayName,
    registerMapJson,
  ];
}

class InverterModelInclude extends _i1.IncludeObject {
  InverterModelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => InverterModel.t;
}

class InverterModelIncludeList extends _i1.IncludeList {
  InverterModelIncludeList._({
    _i1.WhereExpressionBuilder<InverterModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(InverterModel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => InverterModel.t;
}

class InverterModelRepository {
  const InverterModelRepository._();

  /// Returns a list of [InverterModel]s matching the given query parameters.
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
  Future<List<InverterModel>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<InverterModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<InverterModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<InverterModelTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<InverterModel>(
      where: where?.call(InverterModel.t),
      orderBy: orderBy?.call(InverterModel.t),
      orderByList: orderByList?.call(InverterModel.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [InverterModel] matching the given query parameters.
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
  Future<InverterModel?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<InverterModelTable>? where,
    int? offset,
    _i1.OrderByBuilder<InverterModelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<InverterModelTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<InverterModel>(
      where: where?.call(InverterModel.t),
      orderBy: orderBy?.call(InverterModel.t),
      orderByList: orderByList?.call(InverterModel.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [InverterModel] by its [id] or null if no such row exists.
  Future<InverterModel?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<InverterModel>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [InverterModel]s in the list and returns the inserted rows.
  ///
  /// The returned [InverterModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<InverterModel>> insert(
    _i1.DatabaseSession session,
    List<InverterModel> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<InverterModel>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [InverterModel] and returns the inserted row.
  ///
  /// The returned [InverterModel] will have its `id` field set.
  Future<InverterModel> insertRow(
    _i1.DatabaseSession session,
    InverterModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<InverterModel>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [InverterModel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<InverterModel>> update(
    _i1.DatabaseSession session,
    List<InverterModel> rows, {
    _i1.ColumnSelections<InverterModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<InverterModel>(
      rows,
      columns: columns?.call(InverterModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [InverterModel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<InverterModel> updateRow(
    _i1.DatabaseSession session,
    InverterModel row, {
    _i1.ColumnSelections<InverterModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<InverterModel>(
      row,
      columns: columns?.call(InverterModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [InverterModel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<InverterModel?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<InverterModelUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<InverterModel>(
      id,
      columnValues: columnValues(InverterModel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [InverterModel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<InverterModel>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<InverterModelUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<InverterModelTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<InverterModelTable>? orderBy,
    _i1.OrderByListBuilder<InverterModelTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<InverterModel>(
      columnValues: columnValues(InverterModel.t.updateTable),
      where: where(InverterModel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(InverterModel.t),
      orderByList: orderByList?.call(InverterModel.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [InverterModel]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<InverterModel>> delete(
    _i1.DatabaseSession session,
    List<InverterModel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<InverterModel>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [InverterModel].
  Future<InverterModel> deleteRow(
    _i1.DatabaseSession session,
    InverterModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<InverterModel>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<InverterModel>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<InverterModelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<InverterModel>(
      where: where(InverterModel.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<InverterModelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<InverterModel>(
      where: where?.call(InverterModel.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [InverterModel] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<InverterModelTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<InverterModel>(
      where: where(InverterModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
