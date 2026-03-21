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

abstract class AppConfig
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AppConfig._({
    this.id,
    required this.userInfoId,
    this.dataGatheringSince,
    required this.chargingEnabled,
    required this.sellingEnabled,
    required this.pvOnlySelling,
    required this.topUpRequested,
    required this.alwaysChargePriceThreshold,
    this.minSellPriceThreshold,
    this.batteryCapacityKwh,
    this.batteryCost,
    this.batteryLifecycles,
    this.minSocPercentage,
    this.maxDischargeRateKw,
    this.maxChargeRateKw,
    this.gridConnectionKw,
    this.cityName,
    this.latitude,
    this.longitude,
    this.priceSource,
    this.fixedBuyRatePln,
    this.fixedSellRatePln,
    required this.pstrykEnabled,
  });

  factory AppConfig({
    int? id,
    required int userInfoId,
    DateTime? dataGatheringSince,
    required bool chargingEnabled,
    required bool sellingEnabled,
    required bool pvOnlySelling,
    required bool topUpRequested,
    required double alwaysChargePriceThreshold,
    double? minSellPriceThreshold,
    double? batteryCapacityKwh,
    double? batteryCost,
    int? batteryLifecycles,
    double? minSocPercentage,
    double? maxDischargeRateKw,
    double? maxChargeRateKw,
    double? gridConnectionKw,
    String? cityName,
    double? latitude,
    double? longitude,
    String? priceSource,
    double? fixedBuyRatePln,
    double? fixedSellRatePln,
    required bool pstrykEnabled,
  }) = _AppConfigImpl;

  factory AppConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppConfig(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      dataGatheringSince: jsonSerialization['dataGatheringSince'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['dataGatheringSince'],
            ),
      chargingEnabled: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['chargingEnabled'],
      ),
      sellingEnabled: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['sellingEnabled'],
      ),
      pvOnlySelling: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['pvOnlySelling'],
      ),
      topUpRequested: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['topUpRequested'],
      ),
      alwaysChargePriceThreshold:
          (jsonSerialization['alwaysChargePriceThreshold'] as num).toDouble(),
      minSellPriceThreshold:
          (jsonSerialization['minSellPriceThreshold'] as num?)?.toDouble(),
      batteryCapacityKwh: (jsonSerialization['batteryCapacityKwh'] as num?)
          ?.toDouble(),
      batteryCost: (jsonSerialization['batteryCost'] as num?)?.toDouble(),
      batteryLifecycles: jsonSerialization['batteryLifecycles'] as int?,
      minSocPercentage: (jsonSerialization['minSocPercentage'] as num?)
          ?.toDouble(),
      maxDischargeRateKw: (jsonSerialization['maxDischargeRateKw'] as num?)
          ?.toDouble(),
      maxChargeRateKw: (jsonSerialization['maxChargeRateKw'] as num?)
          ?.toDouble(),
      gridConnectionKw: (jsonSerialization['gridConnectionKw'] as num?)
          ?.toDouble(),
      cityName: jsonSerialization['cityName'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      priceSource: jsonSerialization['priceSource'] as String?,
      fixedBuyRatePln: (jsonSerialization['fixedBuyRatePln'] as num?)
          ?.toDouble(),
      fixedSellRatePln: (jsonSerialization['fixedSellRatePln'] as num?)
          ?.toDouble(),
      pstrykEnabled: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['pstrykEnabled'],
      ),
    );
  }

  static final t = AppConfigTable();

  static const db = AppConfigRepository._();

  @override
  int? id;

  int userInfoId;

  DateTime? dataGatheringSince;

  bool chargingEnabled;

  bool sellingEnabled;

  bool pvOnlySelling;

  bool topUpRequested;

  double alwaysChargePriceThreshold;

  double? minSellPriceThreshold;

  double? batteryCapacityKwh;

  double? batteryCost;

  int? batteryLifecycles;

  double? minSocPercentage;

  double? maxDischargeRateKw;

  double? maxChargeRateKw;

  double? gridConnectionKw;

  String? cityName;

  double? latitude;

  double? longitude;

  String? priceSource;

  double? fixedBuyRatePln;

  double? fixedSellRatePln;

  bool pstrykEnabled;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AppConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppConfig copyWith({
    int? id,
    int? userInfoId,
    DateTime? dataGatheringSince,
    bool? chargingEnabled,
    bool? sellingEnabled,
    bool? pvOnlySelling,
    bool? topUpRequested,
    double? alwaysChargePriceThreshold,
    double? minSellPriceThreshold,
    double? batteryCapacityKwh,
    double? batteryCost,
    int? batteryLifecycles,
    double? minSocPercentage,
    double? maxDischargeRateKw,
    double? maxChargeRateKw,
    double? gridConnectionKw,
    String? cityName,
    double? latitude,
    double? longitude,
    String? priceSource,
    double? fixedBuyRatePln,
    double? fixedSellRatePln,
    bool? pstrykEnabled,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppConfig',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      if (dataGatheringSince != null)
        'dataGatheringSince': dataGatheringSince?.toJson(),
      'chargingEnabled': chargingEnabled,
      'sellingEnabled': sellingEnabled,
      'pvOnlySelling': pvOnlySelling,
      'topUpRequested': topUpRequested,
      'alwaysChargePriceThreshold': alwaysChargePriceThreshold,
      if (minSellPriceThreshold != null)
        'minSellPriceThreshold': minSellPriceThreshold,
      if (batteryCapacityKwh != null) 'batteryCapacityKwh': batteryCapacityKwh,
      if (batteryCost != null) 'batteryCost': batteryCost,
      if (batteryLifecycles != null) 'batteryLifecycles': batteryLifecycles,
      if (minSocPercentage != null) 'minSocPercentage': minSocPercentage,
      if (maxDischargeRateKw != null) 'maxDischargeRateKw': maxDischargeRateKw,
      if (maxChargeRateKw != null) 'maxChargeRateKw': maxChargeRateKw,
      if (gridConnectionKw != null) 'gridConnectionKw': gridConnectionKw,
      if (cityName != null) 'cityName': cityName,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (priceSource != null) 'priceSource': priceSource,
      if (fixedBuyRatePln != null) 'fixedBuyRatePln': fixedBuyRatePln,
      if (fixedSellRatePln != null) 'fixedSellRatePln': fixedSellRatePln,
      'pstrykEnabled': pstrykEnabled,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppConfig',
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      if (dataGatheringSince != null)
        'dataGatheringSince': dataGatheringSince?.toJson(),
      'chargingEnabled': chargingEnabled,
      'sellingEnabled': sellingEnabled,
      'pvOnlySelling': pvOnlySelling,
      'topUpRequested': topUpRequested,
      'alwaysChargePriceThreshold': alwaysChargePriceThreshold,
      if (minSellPriceThreshold != null)
        'minSellPriceThreshold': minSellPriceThreshold,
      if (batteryCapacityKwh != null) 'batteryCapacityKwh': batteryCapacityKwh,
      if (batteryCost != null) 'batteryCost': batteryCost,
      if (batteryLifecycles != null) 'batteryLifecycles': batteryLifecycles,
      if (minSocPercentage != null) 'minSocPercentage': minSocPercentage,
      if (maxDischargeRateKw != null) 'maxDischargeRateKw': maxDischargeRateKw,
      if (maxChargeRateKw != null) 'maxChargeRateKw': maxChargeRateKw,
      if (gridConnectionKw != null) 'gridConnectionKw': gridConnectionKw,
      if (cityName != null) 'cityName': cityName,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (priceSource != null) 'priceSource': priceSource,
      if (fixedBuyRatePln != null) 'fixedBuyRatePln': fixedBuyRatePln,
      if (fixedSellRatePln != null) 'fixedSellRatePln': fixedSellRatePln,
      'pstrykEnabled': pstrykEnabled,
    };
  }

  static AppConfigInclude include() {
    return AppConfigInclude._();
  }

  static AppConfigIncludeList includeList({
    _i1.WhereExpressionBuilder<AppConfigTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppConfigTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppConfigTable>? orderByList,
    AppConfigInclude? include,
  }) {
    return AppConfigIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppConfig.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AppConfig.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppConfigImpl extends AppConfig {
  _AppConfigImpl({
    int? id,
    required int userInfoId,
    DateTime? dataGatheringSince,
    required bool chargingEnabled,
    required bool sellingEnabled,
    required bool pvOnlySelling,
    required bool topUpRequested,
    required double alwaysChargePriceThreshold,
    double? minSellPriceThreshold,
    double? batteryCapacityKwh,
    double? batteryCost,
    int? batteryLifecycles,
    double? minSocPercentage,
    double? maxDischargeRateKw,
    double? maxChargeRateKw,
    double? gridConnectionKw,
    String? cityName,
    double? latitude,
    double? longitude,
    String? priceSource,
    double? fixedBuyRatePln,
    double? fixedSellRatePln,
    required bool pstrykEnabled,
  }) : super._(
         id: id,
         userInfoId: userInfoId,
         dataGatheringSince: dataGatheringSince,
         chargingEnabled: chargingEnabled,
         sellingEnabled: sellingEnabled,
         pvOnlySelling: pvOnlySelling,
         topUpRequested: topUpRequested,
         alwaysChargePriceThreshold: alwaysChargePriceThreshold,
         minSellPriceThreshold: minSellPriceThreshold,
         batteryCapacityKwh: batteryCapacityKwh,
         batteryCost: batteryCost,
         batteryLifecycles: batteryLifecycles,
         minSocPercentage: minSocPercentage,
         maxDischargeRateKw: maxDischargeRateKw,
         maxChargeRateKw: maxChargeRateKw,
         gridConnectionKw: gridConnectionKw,
         cityName: cityName,
         latitude: latitude,
         longitude: longitude,
         priceSource: priceSource,
         fixedBuyRatePln: fixedBuyRatePln,
         fixedSellRatePln: fixedSellRatePln,
         pstrykEnabled: pstrykEnabled,
       );

  /// Returns a shallow copy of this [AppConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppConfig copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    Object? dataGatheringSince = _Undefined,
    bool? chargingEnabled,
    bool? sellingEnabled,
    bool? pvOnlySelling,
    bool? topUpRequested,
    double? alwaysChargePriceThreshold,
    Object? minSellPriceThreshold = _Undefined,
    Object? batteryCapacityKwh = _Undefined,
    Object? batteryCost = _Undefined,
    Object? batteryLifecycles = _Undefined,
    Object? minSocPercentage = _Undefined,
    Object? maxDischargeRateKw = _Undefined,
    Object? maxChargeRateKw = _Undefined,
    Object? gridConnectionKw = _Undefined,
    Object? cityName = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? priceSource = _Undefined,
    Object? fixedBuyRatePln = _Undefined,
    Object? fixedSellRatePln = _Undefined,
    bool? pstrykEnabled,
  }) {
    return AppConfig(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      dataGatheringSince: dataGatheringSince is DateTime?
          ? dataGatheringSince
          : this.dataGatheringSince,
      chargingEnabled: chargingEnabled ?? this.chargingEnabled,
      sellingEnabled: sellingEnabled ?? this.sellingEnabled,
      pvOnlySelling: pvOnlySelling ?? this.pvOnlySelling,
      topUpRequested: topUpRequested ?? this.topUpRequested,
      alwaysChargePriceThreshold:
          alwaysChargePriceThreshold ?? this.alwaysChargePriceThreshold,
      minSellPriceThreshold: minSellPriceThreshold is double?
          ? minSellPriceThreshold
          : this.minSellPriceThreshold,
      batteryCapacityKwh: batteryCapacityKwh is double?
          ? batteryCapacityKwh
          : this.batteryCapacityKwh,
      batteryCost: batteryCost is double? ? batteryCost : this.batteryCost,
      batteryLifecycles: batteryLifecycles is int?
          ? batteryLifecycles
          : this.batteryLifecycles,
      minSocPercentage: minSocPercentage is double?
          ? minSocPercentage
          : this.minSocPercentage,
      maxDischargeRateKw: maxDischargeRateKw is double?
          ? maxDischargeRateKw
          : this.maxDischargeRateKw,
      maxChargeRateKw: maxChargeRateKw is double?
          ? maxChargeRateKw
          : this.maxChargeRateKw,
      gridConnectionKw: gridConnectionKw is double?
          ? gridConnectionKw
          : this.gridConnectionKw,
      cityName: cityName is String? ? cityName : this.cityName,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      priceSource: priceSource is String? ? priceSource : this.priceSource,
      fixedBuyRatePln: fixedBuyRatePln is double?
          ? fixedBuyRatePln
          : this.fixedBuyRatePln,
      fixedSellRatePln: fixedSellRatePln is double?
          ? fixedSellRatePln
          : this.fixedSellRatePln,
      pstrykEnabled: pstrykEnabled ?? this.pstrykEnabled,
    );
  }
}

class AppConfigUpdateTable extends _i1.UpdateTable<AppConfigTable> {
  AppConfigUpdateTable(super.table);

  _i1.ColumnValue<int, int> userInfoId(int value) => _i1.ColumnValue(
    table.userInfoId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> dataGatheringSince(DateTime? value) =>
      _i1.ColumnValue(
        table.dataGatheringSince,
        value,
      );

  _i1.ColumnValue<bool, bool> chargingEnabled(bool value) => _i1.ColumnValue(
    table.chargingEnabled,
    value,
  );

  _i1.ColumnValue<bool, bool> sellingEnabled(bool value) => _i1.ColumnValue(
    table.sellingEnabled,
    value,
  );

  _i1.ColumnValue<bool, bool> pvOnlySelling(bool value) => _i1.ColumnValue(
    table.pvOnlySelling,
    value,
  );

  _i1.ColumnValue<bool, bool> topUpRequested(bool value) => _i1.ColumnValue(
    table.topUpRequested,
    value,
  );

  _i1.ColumnValue<double, double> alwaysChargePriceThreshold(double value) =>
      _i1.ColumnValue(
        table.alwaysChargePriceThreshold,
        value,
      );

  _i1.ColumnValue<double, double> minSellPriceThreshold(double? value) =>
      _i1.ColumnValue(
        table.minSellPriceThreshold,
        value,
      );

  _i1.ColumnValue<double, double> batteryCapacityKwh(double? value) =>
      _i1.ColumnValue(
        table.batteryCapacityKwh,
        value,
      );

  _i1.ColumnValue<double, double> batteryCost(double? value) => _i1.ColumnValue(
    table.batteryCost,
    value,
  );

  _i1.ColumnValue<int, int> batteryLifecycles(int? value) => _i1.ColumnValue(
    table.batteryLifecycles,
    value,
  );

  _i1.ColumnValue<double, double> minSocPercentage(double? value) =>
      _i1.ColumnValue(
        table.minSocPercentage,
        value,
      );

  _i1.ColumnValue<double, double> maxDischargeRateKw(double? value) =>
      _i1.ColumnValue(
        table.maxDischargeRateKw,
        value,
      );

  _i1.ColumnValue<double, double> maxChargeRateKw(double? value) =>
      _i1.ColumnValue(
        table.maxChargeRateKw,
        value,
      );

  _i1.ColumnValue<double, double> gridConnectionKw(double? value) =>
      _i1.ColumnValue(
        table.gridConnectionKw,
        value,
      );

  _i1.ColumnValue<String, String> cityName(String? value) => _i1.ColumnValue(
    table.cityName,
    value,
  );

  _i1.ColumnValue<double, double> latitude(double? value) => _i1.ColumnValue(
    table.latitude,
    value,
  );

  _i1.ColumnValue<double, double> longitude(double? value) => _i1.ColumnValue(
    table.longitude,
    value,
  );

  _i1.ColumnValue<String, String> priceSource(String? value) => _i1.ColumnValue(
    table.priceSource,
    value,
  );

  _i1.ColumnValue<double, double> fixedBuyRatePln(double? value) =>
      _i1.ColumnValue(
        table.fixedBuyRatePln,
        value,
      );

  _i1.ColumnValue<double, double> fixedSellRatePln(double? value) =>
      _i1.ColumnValue(
        table.fixedSellRatePln,
        value,
      );

  _i1.ColumnValue<bool, bool> pstrykEnabled(bool value) => _i1.ColumnValue(
    table.pstrykEnabled,
    value,
  );
}

class AppConfigTable extends _i1.Table<int?> {
  AppConfigTable({super.tableRelation}) : super(tableName: 'app_config') {
    updateTable = AppConfigUpdateTable(this);
    userInfoId = _i1.ColumnInt(
      'userInfoId',
      this,
    );
    dataGatheringSince = _i1.ColumnDateTime(
      'dataGatheringSince',
      this,
    );
    chargingEnabled = _i1.ColumnBool(
      'chargingEnabled',
      this,
    );
    sellingEnabled = _i1.ColumnBool(
      'sellingEnabled',
      this,
    );
    pvOnlySelling = _i1.ColumnBool(
      'pvOnlySelling',
      this,
    );
    topUpRequested = _i1.ColumnBool(
      'topUpRequested',
      this,
    );
    alwaysChargePriceThreshold = _i1.ColumnDouble(
      'alwaysChargePriceThreshold',
      this,
    );
    minSellPriceThreshold = _i1.ColumnDouble(
      'minSellPriceThreshold',
      this,
    );
    batteryCapacityKwh = _i1.ColumnDouble(
      'batteryCapacityKwh',
      this,
    );
    batteryCost = _i1.ColumnDouble(
      'batteryCost',
      this,
    );
    batteryLifecycles = _i1.ColumnInt(
      'batteryLifecycles',
      this,
    );
    minSocPercentage = _i1.ColumnDouble(
      'minSocPercentage',
      this,
    );
    maxDischargeRateKw = _i1.ColumnDouble(
      'maxDischargeRateKw',
      this,
    );
    maxChargeRateKw = _i1.ColumnDouble(
      'maxChargeRateKw',
      this,
    );
    gridConnectionKw = _i1.ColumnDouble(
      'gridConnectionKw',
      this,
    );
    cityName = _i1.ColumnString(
      'cityName',
      this,
    );
    latitude = _i1.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _i1.ColumnDouble(
      'longitude',
      this,
    );
    priceSource = _i1.ColumnString(
      'priceSource',
      this,
    );
    fixedBuyRatePln = _i1.ColumnDouble(
      'fixedBuyRatePln',
      this,
    );
    fixedSellRatePln = _i1.ColumnDouble(
      'fixedSellRatePln',
      this,
    );
    pstrykEnabled = _i1.ColumnBool(
      'pstrykEnabled',
      this,
    );
  }

  late final AppConfigUpdateTable updateTable;

  late final _i1.ColumnInt userInfoId;

  late final _i1.ColumnDateTime dataGatheringSince;

  late final _i1.ColumnBool chargingEnabled;

  late final _i1.ColumnBool sellingEnabled;

  late final _i1.ColumnBool pvOnlySelling;

  late final _i1.ColumnBool topUpRequested;

  late final _i1.ColumnDouble alwaysChargePriceThreshold;

  late final _i1.ColumnDouble minSellPriceThreshold;

  late final _i1.ColumnDouble batteryCapacityKwh;

  late final _i1.ColumnDouble batteryCost;

  late final _i1.ColumnInt batteryLifecycles;

  late final _i1.ColumnDouble minSocPercentage;

  late final _i1.ColumnDouble maxDischargeRateKw;

  late final _i1.ColumnDouble maxChargeRateKw;

  late final _i1.ColumnDouble gridConnectionKw;

  late final _i1.ColumnString cityName;

  late final _i1.ColumnDouble latitude;

  late final _i1.ColumnDouble longitude;

  late final _i1.ColumnString priceSource;

  late final _i1.ColumnDouble fixedBuyRatePln;

  late final _i1.ColumnDouble fixedSellRatePln;

  late final _i1.ColumnBool pstrykEnabled;

  @override
  List<_i1.Column> get columns => [
    id,
    userInfoId,
    dataGatheringSince,
    chargingEnabled,
    sellingEnabled,
    pvOnlySelling,
    topUpRequested,
    alwaysChargePriceThreshold,
    minSellPriceThreshold,
    batteryCapacityKwh,
    batteryCost,
    batteryLifecycles,
    minSocPercentage,
    maxDischargeRateKw,
    maxChargeRateKw,
    gridConnectionKw,
    cityName,
    latitude,
    longitude,
    priceSource,
    fixedBuyRatePln,
    fixedSellRatePln,
    pstrykEnabled,
  ];
}

class AppConfigInclude extends _i1.IncludeObject {
  AppConfigInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AppConfig.t;
}

class AppConfigIncludeList extends _i1.IncludeList {
  AppConfigIncludeList._({
    _i1.WhereExpressionBuilder<AppConfigTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AppConfig.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AppConfig.t;
}

class AppConfigRepository {
  const AppConfigRepository._();

  /// Returns a list of [AppConfig]s matching the given query parameters.
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
  Future<List<AppConfig>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AppConfigTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppConfigTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppConfigTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AppConfig>(
      where: where?.call(AppConfig.t),
      orderBy: orderBy?.call(AppConfig.t),
      orderByList: orderByList?.call(AppConfig.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AppConfig] matching the given query parameters.
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
  Future<AppConfig?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AppConfigTable>? where,
    int? offset,
    _i1.OrderByBuilder<AppConfigTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AppConfigTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AppConfig>(
      where: where?.call(AppConfig.t),
      orderBy: orderBy?.call(AppConfig.t),
      orderByList: orderByList?.call(AppConfig.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AppConfig] by its [id] or null if no such row exists.
  Future<AppConfig?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AppConfig>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AppConfig]s in the list and returns the inserted rows.
  ///
  /// The returned [AppConfig]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<AppConfig>> insert(
    _i1.DatabaseSession session,
    List<AppConfig> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<AppConfig>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [AppConfig] and returns the inserted row.
  ///
  /// The returned [AppConfig] will have its `id` field set.
  Future<AppConfig> insertRow(
    _i1.DatabaseSession session,
    AppConfig row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AppConfig>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AppConfig]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AppConfig>> update(
    _i1.DatabaseSession session,
    List<AppConfig> rows, {
    _i1.ColumnSelections<AppConfigTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AppConfig>(
      rows,
      columns: columns?.call(AppConfig.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppConfig]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AppConfig> updateRow(
    _i1.DatabaseSession session,
    AppConfig row, {
    _i1.ColumnSelections<AppConfigTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AppConfig>(
      row,
      columns: columns?.call(AppConfig.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppConfig] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AppConfig?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<AppConfigUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AppConfig>(
      id,
      columnValues: columnValues(AppConfig.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AppConfig]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AppConfig>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<AppConfigUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AppConfigTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AppConfigTable>? orderBy,
    _i1.OrderByListBuilder<AppConfigTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AppConfig>(
      columnValues: columnValues(AppConfig.t.updateTable),
      where: where(AppConfig.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppConfig.t),
      orderByList: orderByList?.call(AppConfig.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AppConfig]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AppConfig>> delete(
    _i1.DatabaseSession session,
    List<AppConfig> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AppConfig>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AppConfig].
  Future<AppConfig> deleteRow(
    _i1.DatabaseSession session,
    AppConfig row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AppConfig>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AppConfig>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AppConfigTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AppConfig>(
      where: where(AppConfig.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<AppConfigTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AppConfig>(
      where: where?.call(AppConfig.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AppConfig] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<AppConfigTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AppConfig>(
      where: where(AppConfig.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
