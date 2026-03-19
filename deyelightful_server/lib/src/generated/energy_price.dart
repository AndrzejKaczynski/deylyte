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

abstract class EnergyPrice
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  EnergyPrice._({
    this.id,
    required this.userInfoId,
    required this.timestamp,
    required this.buyPrice,
    required this.sellPrice,
    required this.currency,
  });

  factory EnergyPrice({
    int? id,
    required int userInfoId,
    required DateTime timestamp,
    required double buyPrice,
    required double sellPrice,
    required String currency,
  }) = _EnergyPriceImpl;

  factory EnergyPrice.fromJson(Map<String, dynamic> jsonSerialization) {
    return EnergyPrice(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      timestamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      buyPrice: (jsonSerialization['buyPrice'] as num).toDouble(),
      sellPrice: (jsonSerialization['sellPrice'] as num).toDouble(),
      currency: jsonSerialization['currency'] as String,
    );
  }

  static final t = EnergyPriceTable();

  static const db = EnergyPriceRepository._();

  @override
  int? id;

  int userInfoId;

  DateTime timestamp;

  double buyPrice;

  double sellPrice;

  String currency;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [EnergyPrice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EnergyPrice copyWith({
    int? id,
    int? userInfoId,
    DateTime? timestamp,
    double? buyPrice,
    double? sellPrice,
    String? currency,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EnergyPrice',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'timestamp': timestamp.toJson(),
      'buyPrice': buyPrice,
      'sellPrice': sellPrice,
      'currency': currency,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EnergyPrice',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'timestamp': timestamp.toJson(),
      'buyPrice': buyPrice,
      'sellPrice': sellPrice,
      'currency': currency,
    };
  }

  static EnergyPriceInclude include() {
    return EnergyPriceInclude._();
  }

  static EnergyPriceIncludeList includeList({
    _i1.WhereExpressionBuilder<EnergyPriceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EnergyPriceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnergyPriceTable>? orderByList,
    EnergyPriceInclude? include,
  }) {
    return EnergyPriceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnergyPrice.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EnergyPrice.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EnergyPriceImpl extends EnergyPrice {
  _EnergyPriceImpl({
    int? id,
    required int userInfoId,
    required DateTime timestamp,
    required double buyPrice,
    required double sellPrice,
    required String currency,
  }) : super._(
         id: id,
         userInfoId: userInfoId,
         timestamp: timestamp,
         buyPrice: buyPrice,
         sellPrice: sellPrice,
         currency: currency,
       );

  /// Returns a shallow copy of this [EnergyPrice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EnergyPrice copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    DateTime? timestamp,
    double? buyPrice,
    double? sellPrice,
    String? currency,
  }) {
    return EnergyPrice(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      timestamp: timestamp ?? this.timestamp,
      buyPrice: buyPrice ?? this.buyPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      currency: currency ?? this.currency,
    );
  }
}

class EnergyPriceUpdateTable extends _i1.UpdateTable<EnergyPriceTable> {
  EnergyPriceUpdateTable(super.table);

  _i1.ColumnValue<int, int> userInfoId(int value) => _i1.ColumnValue(
    table.userInfoId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> timestamp(DateTime value) =>
      _i1.ColumnValue(
        table.timestamp,
        value,
      );

  _i1.ColumnValue<double, double> buyPrice(double value) => _i1.ColumnValue(
    table.buyPrice,
    value,
  );

  _i1.ColumnValue<double, double> sellPrice(double value) => _i1.ColumnValue(
    table.sellPrice,
    value,
  );

  _i1.ColumnValue<String, String> currency(String value) => _i1.ColumnValue(
    table.currency,
    value,
  );
}

class EnergyPriceTable extends _i1.Table<int?> {
  EnergyPriceTable({super.tableRelation}) : super(tableName: 'energy_price') {
    updateTable = EnergyPriceUpdateTable(this);
    userInfoId = _i1.ColumnInt(
      'userInfoId',
      this,
    );
    timestamp = _i1.ColumnDateTime(
      'timestamp',
      this,
    );
    buyPrice = _i1.ColumnDouble(
      'buyPrice',
      this,
    );
    sellPrice = _i1.ColumnDouble(
      'sellPrice',
      this,
    );
    currency = _i1.ColumnString(
      'currency',
      this,
    );
  }

  late final EnergyPriceUpdateTable updateTable;

  late final _i1.ColumnInt userInfoId;

  late final _i1.ColumnDateTime timestamp;

  late final _i1.ColumnDouble buyPrice;

  late final _i1.ColumnDouble sellPrice;

  late final _i1.ColumnString currency;

  @override
  List<_i1.Column> get columns => [
    id,
    userInfoId,
    timestamp,
    buyPrice,
    sellPrice,
    currency,
  ];
}

class EnergyPriceInclude extends _i1.IncludeObject {
  EnergyPriceInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => EnergyPrice.t;
}

class EnergyPriceIncludeList extends _i1.IncludeList {
  EnergyPriceIncludeList._({
    _i1.WhereExpressionBuilder<EnergyPriceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EnergyPrice.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => EnergyPrice.t;
}

class EnergyPriceRepository {
  const EnergyPriceRepository._();

  /// Returns a list of [EnergyPrice]s matching the given query parameters.
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
  Future<List<EnergyPrice>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EnergyPriceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EnergyPriceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnergyPriceTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EnergyPrice>(
      where: where?.call(EnergyPrice.t),
      orderBy: orderBy?.call(EnergyPrice.t),
      orderByList: orderByList?.call(EnergyPrice.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EnergyPrice] matching the given query parameters.
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
  Future<EnergyPrice?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EnergyPriceTable>? where,
    int? offset,
    _i1.OrderByBuilder<EnergyPriceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EnergyPriceTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EnergyPrice>(
      where: where?.call(EnergyPrice.t),
      orderBy: orderBy?.call(EnergyPrice.t),
      orderByList: orderByList?.call(EnergyPrice.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EnergyPrice] by its [id] or null if no such row exists.
  Future<EnergyPrice?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EnergyPrice>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EnergyPrice]s in the list and returns the inserted rows.
  ///
  /// The returned [EnergyPrice]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<EnergyPrice>> insert(
    _i1.DatabaseSession session,
    List<EnergyPrice> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<EnergyPrice>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [EnergyPrice] and returns the inserted row.
  ///
  /// The returned [EnergyPrice] will have its `id` field set.
  Future<EnergyPrice> insertRow(
    _i1.DatabaseSession session,
    EnergyPrice row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EnergyPrice>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EnergyPrice]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EnergyPrice>> update(
    _i1.DatabaseSession session,
    List<EnergyPrice> rows, {
    _i1.ColumnSelections<EnergyPriceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EnergyPrice>(
      rows,
      columns: columns?.call(EnergyPrice.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EnergyPrice]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EnergyPrice> updateRow(
    _i1.DatabaseSession session,
    EnergyPrice row, {
    _i1.ColumnSelections<EnergyPriceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EnergyPrice>(
      row,
      columns: columns?.call(EnergyPrice.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EnergyPrice] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EnergyPrice?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<EnergyPriceUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<EnergyPrice>(
      id,
      columnValues: columnValues(EnergyPrice.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EnergyPrice]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<EnergyPrice>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<EnergyPriceUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<EnergyPriceTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EnergyPriceTable>? orderBy,
    _i1.OrderByListBuilder<EnergyPriceTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<EnergyPrice>(
      columnValues: columnValues(EnergyPrice.t.updateTable),
      where: where(EnergyPrice.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EnergyPrice.t),
      orderByList: orderByList?.call(EnergyPrice.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [EnergyPrice]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EnergyPrice>> delete(
    _i1.DatabaseSession session,
    List<EnergyPrice> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EnergyPrice>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EnergyPrice].
  Future<EnergyPrice> deleteRow(
    _i1.DatabaseSession session,
    EnergyPrice row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EnergyPrice>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EnergyPrice>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<EnergyPriceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EnergyPrice>(
      where: where(EnergyPrice.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EnergyPriceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EnergyPrice>(
      where: where?.call(EnergyPrice.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EnergyPrice] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<EnergyPriceTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EnergyPrice>(
      where: where(EnergyPrice.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
