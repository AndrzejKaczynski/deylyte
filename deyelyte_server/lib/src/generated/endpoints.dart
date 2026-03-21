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
import '../endpoints/app_config_endpoint.dart' as _i2;
import '../endpoints/baseline_endpoint.dart' as _i3;
import '../endpoints/credentials_endpoint.dart' as _i4;
import '../endpoints/device_endpoint.dart' as _i5;
import '../endpoints/example_endpoint.dart' as _i6;
import '../endpoints/forecast_endpoint.dart' as _i7;
import '../endpoints/history_endpoint.dart' as _i8;
import '../endpoints/license_endpoint.dart' as _i9;
import '../endpoints/optimizer_endpoint.dart' as _i10;
import '../endpoints/price_endpoint.dart' as _i11;
import '../endpoints/price_time_ranges_endpoint.dart' as _i12;
import '../endpoints/schedule_endpoint.dart' as _i13;
import '../endpoints/telemetry_endpoint.dart' as _i14;
import 'package:deyelyte_server/src/generated/app_config.dart' as _i15;
import 'package:deyelyte_server/src/generated/price_time_range.dart' as _i16;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i17;
import 'package:deyelyte_server/src/generated/future_calls.dart' as _i18;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'appConfig': _i2.AppConfigEndpoint()
        ..initialize(
          server,
          'appConfig',
          null,
        ),
      'baseline': _i3.BaselineEndpoint()
        ..initialize(
          server,
          'baseline',
          null,
        ),
      'credentials': _i4.CredentialsEndpoint()
        ..initialize(
          server,
          'credentials',
          null,
        ),
      'device': _i5.DeviceEndpoint()
        ..initialize(
          server,
          'device',
          null,
        ),
      'example': _i6.ExampleEndpoint()
        ..initialize(
          server,
          'example',
          null,
        ),
      'forecast': _i7.ForecastEndpoint()
        ..initialize(
          server,
          'forecast',
          null,
        ),
      'history': _i8.HistoryEndpoint()
        ..initialize(
          server,
          'history',
          null,
        ),
      'license': _i9.LicenseEndpoint()
        ..initialize(
          server,
          'license',
          null,
        ),
      'optimizer': _i10.OptimizerEndpoint()
        ..initialize(
          server,
          'optimizer',
          null,
        ),
      'price': _i11.PriceEndpoint()
        ..initialize(
          server,
          'price',
          null,
        ),
      'priceTimeRanges': _i12.PriceTimeRangesEndpoint()
        ..initialize(
          server,
          'priceTimeRanges',
          null,
        ),
      'schedule': _i13.ScheduleEndpoint()
        ..initialize(
          server,
          'schedule',
          null,
        ),
      'telemetry': _i14.TelemetryEndpoint()
        ..initialize(
          server,
          'telemetry',
          null,
        ),
    };
    connectors['appConfig'] = _i1.EndpointConnector(
      name: 'appConfig',
      endpoint: endpoints['appConfig']!,
      methodConnectors: {
        'getConfig': _i1.MethodConnector(
          name: 'getConfig',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['appConfig'] as _i2.AppConfigEndpoint)
                  .getConfig(session),
        ),
        'saveConfig': _i1.MethodConnector(
          name: 'saveConfig',
          params: {
            'config': _i1.ParameterDescription(
              name: 'config',
              type: _i1.getType<_i15.AppConfig>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['appConfig'] as _i2.AppConfigEndpoint).saveConfig(
                    session,
                    params['config'],
                  ),
        ),
      },
    );
    connectors['baseline'] = _i1.EndpointConnector(
      name: 'baseline',
      endpoint: endpoints['baseline']!,
      methodConnectors: {
        'calculateBaseline': _i1.MethodConnector(
          name: 'calculateBaseline',
          params: {
            'userInfoId': _i1.ParameterDescription(
              name: 'userInfoId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['baseline'] as _i3.BaselineEndpoint)
                  .calculateBaseline(
                    session,
                    params['userInfoId'],
                  ),
        ),
      },
    );
    connectors['credentials'] = _i1.EndpointConnector(
      name: 'credentials',
      endpoint: endpoints['credentials']!,
      methodConnectors: {
        'saveDeye': _i1.MethodConnector(
          name: 'saveDeye',
          params: {
            'username': _i1.ParameterDescription(
              name: 'username',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['credentials'] as _i4.CredentialsEndpoint)
                  .saveDeye(
                    session,
                    params['username'],
                    params['password'],
                  ),
        ),
        'saveSolcast': _i1.MethodConnector(
          name: 'saveSolcast',
          params: {
            'apiKey': _i1.ParameterDescription(
              name: 'apiKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'siteId': _i1.ParameterDescription(
              name: 'siteId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['credentials'] as _i4.CredentialsEndpoint)
                  .saveSolcast(
                    session,
                    params['apiKey'],
                    params['siteId'],
                  ),
        ),
        'savePstryk': _i1.MethodConnector(
          name: 'savePstryk',
          params: {
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['credentials'] as _i4.CredentialsEndpoint)
                  .savePstryk(
                    session,
                    params['token'],
                  ),
        ),
        'removeDeye': _i1.MethodConnector(
          name: 'removeDeye',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['credentials'] as _i4.CredentialsEndpoint)
                  .removeDeye(session),
        ),
        'removeSolcast': _i1.MethodConnector(
          name: 'removeSolcast',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['credentials'] as _i4.CredentialsEndpoint)
                  .removeSolcast(session),
        ),
        'removePstryk': _i1.MethodConnector(
          name: 'removePstryk',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['credentials'] as _i4.CredentialsEndpoint)
                  .removePstryk(session),
        ),
        'getStatus': _i1.MethodConnector(
          name: 'getStatus',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['credentials'] as _i4.CredentialsEndpoint)
                  .getStatus(session),
        ),
      },
    );
    connectors['device'] = _i1.EndpointConnector(
      name: 'device',
      endpoint: endpoints['device']!,
      methodConnectors: {
        'getStatus': _i1.MethodConnector(
          name: 'getStatus',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['device'] as _i5.DeviceEndpoint).getStatus(
                session,
              ),
        ),
      },
    );
    connectors['example'] = _i1.EndpointConnector(
      name: 'example',
      endpoint: endpoints['example']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['example'] as _i6.ExampleEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    connectors['forecast'] = _i1.EndpointConnector(
      name: 'forecast',
      endpoint: endpoints['forecast']!,
      methodConnectors: {
        'updateForecast': _i1.MethodConnector(
          name: 'updateForecast',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['forecast'] as _i7.ForecastEndpoint)
                  .updateForecast(session),
        ),
      },
    );
    connectors['history'] = _i1.EndpointConnector(
      name: 'history',
      endpoint: endpoints['history']!,
      methodConnectors: {
        'getSummary': _i1.MethodConnector(
          name: 'getSummary',
          params: {
            'rangeDays': _i1.ParameterDescription(
              name: 'rangeDays',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['history'] as _i8.HistoryEndpoint).getSummary(
                    session,
                    params['rangeDays'],
                  ),
        ),
        'getEvents': _i1.MethodConnector(
          name: 'getEvents',
          params: {
            'rangeDays': _i1.ParameterDescription(
              name: 'rangeDays',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['history'] as _i8.HistoryEndpoint).getEvents(
                    session,
                    params['rangeDays'],
                  ),
        ),
      },
    );
    connectors['license'] = _i1.EndpointConnector(
      name: 'license',
      endpoint: endpoints['license']!,
      methodConnectors: {
        'validate': _i1.MethodConnector(
          name: 'validate',
          params: {
            'licenseKey': _i1.ParameterDescription(
              name: 'licenseKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['license'] as _i9.LicenseEndpoint).validate(
                session,
                params['licenseKey'],
              ),
        ),
      },
    );
    connectors['optimizer'] = _i1.EndpointConnector(
      name: 'optimizer',
      endpoint: endpoints['optimizer']!,
      methodConnectors: {
        'calculateAndStore': _i1.MethodConnector(
          name: 'calculateAndStore',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['optimizer'] as _i10.OptimizerEndpoint)
                  .calculateAndStore(session),
        ),
        'getSchedule': _i1.MethodConnector(
          name: 'getSchedule',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['optimizer'] as _i10.OptimizerEndpoint)
                  .getSchedule(session),
        ),
        'requestTopUp': _i1.MethodConnector(
          name: 'requestTopUp',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['optimizer'] as _i10.OptimizerEndpoint)
                  .requestTopUp(session),
        ),
        'cancelTopUp': _i1.MethodConnector(
          name: 'cancelTopUp',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['optimizer'] as _i10.OptimizerEndpoint)
                  .cancelTopUp(session),
        ),
        'addOutageReserve': _i1.MethodConnector(
          name: 'addOutageReserve',
          params: {
            'date': _i1.ParameterDescription(
              name: 'date',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'note': _i1.ParameterDescription(
              name: 'note',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['optimizer'] as _i10.OptimizerEndpoint)
                  .addOutageReserve(
                    session,
                    params['date'],
                    params['note'],
                  ),
        ),
        'removeOutageReserve': _i1.MethodConnector(
          name: 'removeOutageReserve',
          params: {
            'date': _i1.ParameterDescription(
              name: 'date',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['optimizer'] as _i10.OptimizerEndpoint)
                  .removeOutageReserve(
                    session,
                    params['date'],
                  ),
        ),
        'getOutageReserves': _i1.MethodConnector(
          name: 'getOutageReserves',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['optimizer'] as _i10.OptimizerEndpoint)
                  .getOutageReserves(session),
        ),
      },
    );
    connectors['price'] = _i1.EndpointConnector(
      name: 'price',
      endpoint: endpoints['price']!,
      methodConnectors: {
        'updatePrices': _i1.MethodConnector(
          name: 'updatePrices',
          params: {
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'userInfoId': _i1.ParameterDescription(
              name: 'userInfoId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['price'] as _i11.PriceEndpoint).updatePrices(
                    session,
                    params['token'],
                    params['userInfoId'],
                  ),
        ),
      },
    );
    connectors['priceTimeRanges'] = _i1.EndpointConnector(
      name: 'priceTimeRanges',
      endpoint: endpoints['priceTimeRanges']!,
      methodConnectors: {
        'getTimeRanges': _i1.MethodConnector(
          name: 'getTimeRanges',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['priceTimeRanges'] as _i12.PriceTimeRangesEndpoint)
                      .getTimeRanges(session),
        ),
        'saveTimeRanges': _i1.MethodConnector(
          name: 'saveTimeRanges',
          params: {
            'ranges': _i1.ParameterDescription(
              name: 'ranges',
              type: _i1.getType<List<_i16.PriceTimeRange>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['priceTimeRanges'] as _i12.PriceTimeRangesEndpoint)
                      .saveTimeRanges(
                        session,
                        params['ranges'],
                      ),
        ),
      },
    );
    connectors['schedule'] = _i1.EndpointConnector(
      name: 'schedule',
      endpoint: endpoints['schedule']!,
      methodConnectors: {
        'getCurrent': _i1.MethodConnector(
          name: 'getCurrent',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['schedule'] as _i13.ScheduleEndpoint)
                  .getCurrent(session),
        ),
        'getForecast': _i1.MethodConnector(
          name: 'getForecast',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['schedule'] as _i13.ScheduleEndpoint)
                  .getForecast(session),
        ),
        'getEvents': _i1.MethodConnector(
          name: 'getEvents',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['schedule'] as _i13.ScheduleEndpoint)
                  .getEvents(session),
        ),
        'getSchedule': _i1.MethodConnector(
          name: 'getSchedule',
          params: {
            'licenseKey': _i1.ParameterDescription(
              name: 'licenseKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['schedule'] as _i13.ScheduleEndpoint).getSchedule(
                    session,
                    params['licenseKey'],
                  ),
        ),
        'getScheduleWithFallback': _i1.MethodConnector(
          name: 'getScheduleWithFallback',
          params: {
            'licenseKey': _i1.ParameterDescription(
              name: 'licenseKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['schedule'] as _i13.ScheduleEndpoint)
                  .getScheduleWithFallback(
                    session,
                    params['licenseKey'],
                  ),
        ),
      },
    );
    connectors['telemetry'] = _i1.EndpointConnector(
      name: 'telemetry',
      endpoint: endpoints['telemetry']!,
      methodConnectors: {
        'ingest': _i1.MethodConnector(
          name: 'ingest',
          params: {
            'licenseKey': _i1.ParameterDescription(
              name: 'licenseKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'deviceId': _i1.ParameterDescription(
              name: 'deviceId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'timestamp': _i1.ParameterDescription(
              name: 'timestamp',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'batterySOC': _i1.ParameterDescription(
              name: 'batterySOC',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'gridPowerW': _i1.ParameterDescription(
              name: 'gridPowerW',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'pvPowerW': _i1.ParameterDescription(
              name: 'pvPowerW',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'loadPowerW': _i1.ParameterDescription(
              name: 'loadPowerW',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'batteryPowerW': _i1.ParameterDescription(
              name: 'batteryPowerW',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['telemetry'] as _i14.TelemetryEndpoint).ingest(
                    session,
                    params['licenseKey'],
                    params['deviceId'],
                    params['timestamp'],
                    params['batterySOC'],
                    params['gridPowerW'],
                    params['pvPowerW'],
                    params['loadPowerW'],
                    params['batteryPowerW'],
                  ),
        ),
        'getLatest': _i1.MethodConnector(
          name: 'getLatest',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['telemetry'] as _i14.TelemetryEndpoint)
                  .getLatest(session),
        ),
        'getHistory': _i1.MethodConnector(
          name: 'getHistory',
          params: {
            'hours': _i1.ParameterDescription(
              name: 'hours',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['telemetry'] as _i14.TelemetryEndpoint).getHistory(
                    session,
                    params['hours'],
                  ),
        ),
      },
    );
    modules['serverpod_auth'] = _i17.Endpoints()..initializeEndpoints(server);
  }

  @override
  _i1.FutureCallDispatch? get futureCalls {
    return _i18.FutureCalls();
  }
}
