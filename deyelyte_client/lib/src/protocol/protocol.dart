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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'admin_user.dart' as _i2;
import 'app_config.dart' as _i3;
import 'auth_key_metadata.dart' as _i4;
import 'daily_avg_price.dart' as _i5;
import 'daily_energy_aggregate.dart' as _i6;
import 'device.dart' as _i7;
import 'device_telemetry.dart' as _i8;
import 'energy_price.dart' as _i9;
import 'example.dart' as _i10;
import 'history_day_data.dart' as _i11;
import 'history_period_data.dart' as _i12;
import 'integration_credentials.dart' as _i13;
import 'inverter_data.dart' as _i14;
import 'inverter_model.dart' as _i15;
import 'license_key.dart' as _i16;
import 'optimization_frame.dart' as _i17;
import 'outage_reserve.dart' as _i18;
import 'price_time_range.dart' as _i19;
import 'pv_forecast.dart' as _i20;
import 'tier_sync_config.dart' as _i21;
import 'package:deyelyte_client/src/protocol/pv_forecast.dart' as _i22;
import 'package:deyelyte_client/src/protocol/optimization_frame.dart' as _i23;
import 'package:deyelyte_client/src/protocol/outage_reserve.dart' as _i24;
import 'package:deyelyte_client/src/protocol/energy_price.dart' as _i25;
import 'package:deyelyte_client/src/protocol/price_time_range.dart' as _i26;
import 'package:deyelyte_client/src/protocol/device_telemetry.dart' as _i27;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i28;
export 'admin_user.dart';
export 'app_config.dart';
export 'auth_key_metadata.dart';
export 'daily_avg_price.dart';
export 'daily_energy_aggregate.dart';
export 'device.dart';
export 'device_telemetry.dart';
export 'energy_price.dart';
export 'example.dart';
export 'history_day_data.dart';
export 'history_period_data.dart';
export 'integration_credentials.dart';
export 'inverter_data.dart';
export 'inverter_model.dart';
export 'license_key.dart';
export 'optimization_frame.dart';
export 'outage_reserve.dart';
export 'price_time_range.dart';
export 'pv_forecast.dart';
export 'tier_sync_config.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.AdminUser) {
      return _i2.AdminUser.fromJson(data) as T;
    }
    if (t == _i3.AppConfig) {
      return _i3.AppConfig.fromJson(data) as T;
    }
    if (t == _i4.AuthKeyMetadata) {
      return _i4.AuthKeyMetadata.fromJson(data) as T;
    }
    if (t == _i5.DailyAvgPrice) {
      return _i5.DailyAvgPrice.fromJson(data) as T;
    }
    if (t == _i6.DailyEnergyAggregate) {
      return _i6.DailyEnergyAggregate.fromJson(data) as T;
    }
    if (t == _i7.Device) {
      return _i7.Device.fromJson(data) as T;
    }
    if (t == _i8.DeviceTelemetry) {
      return _i8.DeviceTelemetry.fromJson(data) as T;
    }
    if (t == _i9.EnergyPrice) {
      return _i9.EnergyPrice.fromJson(data) as T;
    }
    if (t == _i10.Example) {
      return _i10.Example.fromJson(data) as T;
    }
    if (t == _i11.HistoryDayData) {
      return _i11.HistoryDayData.fromJson(data) as T;
    }
    if (t == _i12.HistoryPeriodData) {
      return _i12.HistoryPeriodData.fromJson(data) as T;
    }
    if (t == _i13.IntegrationCredentials) {
      return _i13.IntegrationCredentials.fromJson(data) as T;
    }
    if (t == _i14.InverterData) {
      return _i14.InverterData.fromJson(data) as T;
    }
    if (t == _i15.InverterModel) {
      return _i15.InverterModel.fromJson(data) as T;
    }
    if (t == _i16.LicenseKey) {
      return _i16.LicenseKey.fromJson(data) as T;
    }
    if (t == _i17.OptimizationFrame) {
      return _i17.OptimizationFrame.fromJson(data) as T;
    }
    if (t == _i18.OutageReserve) {
      return _i18.OutageReserve.fromJson(data) as T;
    }
    if (t == _i19.PriceTimeRange) {
      return _i19.PriceTimeRange.fromJson(data) as T;
    }
    if (t == _i20.PvForecast) {
      return _i20.PvForecast.fromJson(data) as T;
    }
    if (t == _i21.TierSyncConfig) {
      return _i21.TierSyncConfig.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AdminUser?>()) {
      return (data != null ? _i2.AdminUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AppConfig?>()) {
      return (data != null ? _i3.AppConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AuthKeyMetadata?>()) {
      return (data != null ? _i4.AuthKeyMetadata.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.DailyAvgPrice?>()) {
      return (data != null ? _i5.DailyAvgPrice.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.DailyEnergyAggregate?>()) {
      return (data != null ? _i6.DailyEnergyAggregate.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.Device?>()) {
      return (data != null ? _i7.Device.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.DeviceTelemetry?>()) {
      return (data != null ? _i8.DeviceTelemetry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.EnergyPrice?>()) {
      return (data != null ? _i9.EnergyPrice.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Example?>()) {
      return (data != null ? _i10.Example.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.HistoryDayData?>()) {
      return (data != null ? _i11.HistoryDayData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.HistoryPeriodData?>()) {
      return (data != null ? _i12.HistoryPeriodData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.IntegrationCredentials?>()) {
      return (data != null ? _i13.IntegrationCredentials.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i14.InverterData?>()) {
      return (data != null ? _i14.InverterData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.InverterModel?>()) {
      return (data != null ? _i15.InverterModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.LicenseKey?>()) {
      return (data != null ? _i16.LicenseKey.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.OptimizationFrame?>()) {
      return (data != null ? _i17.OptimizationFrame.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.OutageReserve?>()) {
      return (data != null ? _i18.OutageReserve.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.PriceTimeRange?>()) {
      return (data != null ? _i19.PriceTimeRange.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.PvForecast?>()) {
      return (data != null ? _i20.PvForecast.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.TierSyncConfig?>()) {
      return (data != null ? _i21.TierSyncConfig.fromJson(data) : null) as T;
    }
    if (t == List<_i8.DeviceTelemetry>) {
      return (data as List)
              .map((e) => deserialize<_i8.DeviceTelemetry>(e))
              .toList()
          as T;
    }
    if (t == List<_i9.EnergyPrice>) {
      return (data as List).map((e) => deserialize<_i9.EnergyPrice>(e)).toList()
          as T;
    }
    if (t == List<_i17.OptimizationFrame>) {
      return (data as List)
              .map((e) => deserialize<_i17.OptimizationFrame>(e))
              .toList()
          as T;
    }
    if (t == List<_i6.DailyEnergyAggregate>) {
      return (data as List)
              .map((e) => deserialize<_i6.DailyEnergyAggregate>(e))
              .toList()
          as T;
    }
    if (t == List<_i5.DailyAvgPrice>) {
      return (data as List)
              .map((e) => deserialize<_i5.DailyAvgPrice>(e))
              .toList()
          as T;
    }
    if (t == Map<String, bool>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<bool>(v)),
          )
          as T;
    }
    if (t == List<_i22.PvForecast>) {
      return (data as List).map((e) => deserialize<_i22.PvForecast>(e)).toList()
          as T;
    }
    if (t == List<_i23.OptimizationFrame>) {
      return (data as List)
              .map((e) => deserialize<_i23.OptimizationFrame>(e))
              .toList()
          as T;
    }
    if (t == List<_i24.OutageReserve>) {
      return (data as List)
              .map((e) => deserialize<_i24.OutageReserve>(e))
              .toList()
          as T;
    }
    if (t == List<_i25.EnergyPrice>) {
      return (data as List)
              .map((e) => deserialize<_i25.EnergyPrice>(e))
              .toList()
          as T;
    }
    if (t == List<_i26.PriceTimeRange>) {
      return (data as List)
              .map((e) => deserialize<_i26.PriceTimeRange>(e))
              .toList()
          as T;
    }
    if (t == List<_i27.DeviceTelemetry>) {
      return (data as List)
              .map((e) => deserialize<_i27.DeviceTelemetry>(e))
              .toList()
          as T;
    }
    try {
      return _i28.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AdminUser => 'AdminUser',
      _i3.AppConfig => 'AppConfig',
      _i4.AuthKeyMetadata => 'AuthKeyMetadata',
      _i5.DailyAvgPrice => 'DailyAvgPrice',
      _i6.DailyEnergyAggregate => 'DailyEnergyAggregate',
      _i7.Device => 'Device',
      _i8.DeviceTelemetry => 'DeviceTelemetry',
      _i9.EnergyPrice => 'EnergyPrice',
      _i10.Example => 'Example',
      _i11.HistoryDayData => 'HistoryDayData',
      _i12.HistoryPeriodData => 'HistoryPeriodData',
      _i13.IntegrationCredentials => 'IntegrationCredentials',
      _i14.InverterData => 'InverterData',
      _i15.InverterModel => 'InverterModel',
      _i16.LicenseKey => 'LicenseKey',
      _i17.OptimizationFrame => 'OptimizationFrame',
      _i18.OutageReserve => 'OutageReserve',
      _i19.PriceTimeRange => 'PriceTimeRange',
      _i20.PvForecast => 'PvForecast',
      _i21.TierSyncConfig => 'TierSyncConfig',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('deyelyte.', '');
    }

    switch (data) {
      case _i2.AdminUser():
        return 'AdminUser';
      case _i3.AppConfig():
        return 'AppConfig';
      case _i4.AuthKeyMetadata():
        return 'AuthKeyMetadata';
      case _i5.DailyAvgPrice():
        return 'DailyAvgPrice';
      case _i6.DailyEnergyAggregate():
        return 'DailyEnergyAggregate';
      case _i7.Device():
        return 'Device';
      case _i8.DeviceTelemetry():
        return 'DeviceTelemetry';
      case _i9.EnergyPrice():
        return 'EnergyPrice';
      case _i10.Example():
        return 'Example';
      case _i11.HistoryDayData():
        return 'HistoryDayData';
      case _i12.HistoryPeriodData():
        return 'HistoryPeriodData';
      case _i13.IntegrationCredentials():
        return 'IntegrationCredentials';
      case _i14.InverterData():
        return 'InverterData';
      case _i15.InverterModel():
        return 'InverterModel';
      case _i16.LicenseKey():
        return 'LicenseKey';
      case _i17.OptimizationFrame():
        return 'OptimizationFrame';
      case _i18.OutageReserve():
        return 'OutageReserve';
      case _i19.PriceTimeRange():
        return 'PriceTimeRange';
      case _i20.PvForecast():
        return 'PvForecast';
      case _i21.TierSyncConfig():
        return 'TierSyncConfig';
    }
    className = _i28.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AdminUser') {
      return deserialize<_i2.AdminUser>(data['data']);
    }
    if (dataClassName == 'AppConfig') {
      return deserialize<_i3.AppConfig>(data['data']);
    }
    if (dataClassName == 'AuthKeyMetadata') {
      return deserialize<_i4.AuthKeyMetadata>(data['data']);
    }
    if (dataClassName == 'DailyAvgPrice') {
      return deserialize<_i5.DailyAvgPrice>(data['data']);
    }
    if (dataClassName == 'DailyEnergyAggregate') {
      return deserialize<_i6.DailyEnergyAggregate>(data['data']);
    }
    if (dataClassName == 'Device') {
      return deserialize<_i7.Device>(data['data']);
    }
    if (dataClassName == 'DeviceTelemetry') {
      return deserialize<_i8.DeviceTelemetry>(data['data']);
    }
    if (dataClassName == 'EnergyPrice') {
      return deserialize<_i9.EnergyPrice>(data['data']);
    }
    if (dataClassName == 'Example') {
      return deserialize<_i10.Example>(data['data']);
    }
    if (dataClassName == 'HistoryDayData') {
      return deserialize<_i11.HistoryDayData>(data['data']);
    }
    if (dataClassName == 'HistoryPeriodData') {
      return deserialize<_i12.HistoryPeriodData>(data['data']);
    }
    if (dataClassName == 'IntegrationCredentials') {
      return deserialize<_i13.IntegrationCredentials>(data['data']);
    }
    if (dataClassName == 'InverterData') {
      return deserialize<_i14.InverterData>(data['data']);
    }
    if (dataClassName == 'InverterModel') {
      return deserialize<_i15.InverterModel>(data['data']);
    }
    if (dataClassName == 'LicenseKey') {
      return deserialize<_i16.LicenseKey>(data['data']);
    }
    if (dataClassName == 'OptimizationFrame') {
      return deserialize<_i17.OptimizationFrame>(data['data']);
    }
    if (dataClassName == 'OutageReserve') {
      return deserialize<_i18.OutageReserve>(data['data']);
    }
    if (dataClassName == 'PriceTimeRange') {
      return deserialize<_i19.PriceTimeRange>(data['data']);
    }
    if (dataClassName == 'PvForecast') {
      return deserialize<_i20.PvForecast>(data['data']);
    }
    if (dataClassName == 'TierSyncConfig') {
      return deserialize<_i21.TierSyncConfig>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i28.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i28.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
