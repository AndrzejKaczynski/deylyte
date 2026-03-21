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
import 'app_config.dart' as _i2;
import 'energy_price.dart' as _i3;
import 'example.dart' as _i4;
import 'integration_credentials.dart' as _i5;
import 'inverter_data.dart' as _i6;
import 'optimization_frame.dart' as _i7;
import 'outage_reserve.dart' as _i8;
import 'price_time_range.dart' as _i9;
import 'pv_forecast.dart' as _i10;
import 'package:deyelyte_client/src/protocol/optimization_frame.dart' as _i11;
import 'package:deyelyte_client/src/protocol/outage_reserve.dart' as _i12;
import 'package:deyelyte_client/src/protocol/price_time_range.dart' as _i13;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i14;
export 'app_config.dart';
export 'energy_price.dart';
export 'example.dart';
export 'integration_credentials.dart';
export 'inverter_data.dart';
export 'optimization_frame.dart';
export 'outage_reserve.dart';
export 'price_time_range.dart';
export 'pv_forecast.dart';
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

    if (t == _i2.AppConfig) {
      return _i2.AppConfig.fromJson(data) as T;
    }
    if (t == _i3.EnergyPrice) {
      return _i3.EnergyPrice.fromJson(data) as T;
    }
    if (t == _i4.Example) {
      return _i4.Example.fromJson(data) as T;
    }
    if (t == _i5.IntegrationCredentials) {
      return _i5.IntegrationCredentials.fromJson(data) as T;
    }
    if (t == _i6.InverterData) {
      return _i6.InverterData.fromJson(data) as T;
    }
    if (t == _i7.OptimizationFrame) {
      return _i7.OptimizationFrame.fromJson(data) as T;
    }
    if (t == _i8.OutageReserve) {
      return _i8.OutageReserve.fromJson(data) as T;
    }
    if (t == _i9.PriceTimeRange) {
      return _i9.PriceTimeRange.fromJson(data) as T;
    }
    if (t == _i10.PvForecast) {
      return _i10.PvForecast.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AppConfig?>()) {
      return (data != null ? _i2.AppConfig.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.EnergyPrice?>()) {
      return (data != null ? _i3.EnergyPrice.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Example?>()) {
      return (data != null ? _i4.Example.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.IntegrationCredentials?>()) {
      return (data != null ? _i5.IntegrationCredentials.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.InverterData?>()) {
      return (data != null ? _i6.InverterData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.OptimizationFrame?>()) {
      return (data != null ? _i7.OptimizationFrame.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.OutageReserve?>()) {
      return (data != null ? _i8.OutageReserve.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.PriceTimeRange?>()) {
      return (data != null ? _i9.PriceTimeRange.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.PvForecast?>()) {
      return (data != null ? _i10.PvForecast.fromJson(data) : null) as T;
    }
    if (t == Map<String, bool>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<bool>(v)),
          )
          as T;
    }
    if (t == List<_i11.OptimizationFrame>) {
      return (data as List)
              .map((e) => deserialize<_i11.OptimizationFrame>(e))
              .toList()
          as T;
    }
    if (t == List<_i12.OutageReserve>) {
      return (data as List)
              .map((e) => deserialize<_i12.OutageReserve>(e))
              .toList()
          as T;
    }
    if (t == List<_i13.PriceTimeRange>) {
      return (data as List)
              .map((e) => deserialize<_i13.PriceTimeRange>(e))
              .toList()
          as T;
    }
    try {
      return _i14.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AppConfig => 'AppConfig',
      _i3.EnergyPrice => 'EnergyPrice',
      _i4.Example => 'Example',
      _i5.IntegrationCredentials => 'IntegrationCredentials',
      _i6.InverterData => 'InverterData',
      _i7.OptimizationFrame => 'OptimizationFrame',
      _i8.OutageReserve => 'OutageReserve',
      _i9.PriceTimeRange => 'PriceTimeRange',
      _i10.PvForecast => 'PvForecast',
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
      case _i2.AppConfig():
        return 'AppConfig';
      case _i3.EnergyPrice():
        return 'EnergyPrice';
      case _i4.Example():
        return 'Example';
      case _i5.IntegrationCredentials():
        return 'IntegrationCredentials';
      case _i6.InverterData():
        return 'InverterData';
      case _i7.OptimizationFrame():
        return 'OptimizationFrame';
      case _i8.OutageReserve():
        return 'OutageReserve';
      case _i9.PriceTimeRange():
        return 'PriceTimeRange';
      case _i10.PvForecast():
        return 'PvForecast';
    }
    className = _i14.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'AppConfig') {
      return deserialize<_i2.AppConfig>(data['data']);
    }
    if (dataClassName == 'EnergyPrice') {
      return deserialize<_i3.EnergyPrice>(data['data']);
    }
    if (dataClassName == 'Example') {
      return deserialize<_i4.Example>(data['data']);
    }
    if (dataClassName == 'IntegrationCredentials') {
      return deserialize<_i5.IntegrationCredentials>(data['data']);
    }
    if (dataClassName == 'InverterData') {
      return deserialize<_i6.InverterData>(data['data']);
    }
    if (dataClassName == 'OptimizationFrame') {
      return deserialize<_i7.OptimizationFrame>(data['data']);
    }
    if (dataClassName == 'OutageReserve') {
      return deserialize<_i8.OutageReserve>(data['data']);
    }
    if (dataClassName == 'PriceTimeRange') {
      return deserialize<_i9.PriceTimeRange>(data['data']);
    }
    if (dataClassName == 'PvForecast') {
      return deserialize<_i10.PvForecast>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i14.Protocol().deserializeByClassName(data);
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
      return _i14.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
