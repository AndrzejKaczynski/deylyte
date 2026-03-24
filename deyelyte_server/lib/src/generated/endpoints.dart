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
import '../endpoints/admin_endpoint.dart' as _i2;
import '../endpoints/app_config_endpoint.dart' as _i3;
import '../endpoints/baseline_endpoint.dart' as _i4;
import '../endpoints/credentials_endpoint.dart' as _i5;
import '../endpoints/device_endpoint.dart' as _i6;
import '../endpoints/example_endpoint.dart' as _i7;
import '../endpoints/forecast_endpoint.dart' as _i8;
import '../endpoints/history_endpoint.dart' as _i9;
import '../endpoints/license_endpoint.dart' as _i10;
import '../endpoints/optimizer_endpoint.dart' as _i11;
import '../endpoints/price_endpoint.dart' as _i12;
import '../endpoints/price_time_ranges_endpoint.dart' as _i13;
import '../endpoints/schedule_endpoint.dart' as _i14;
import '../endpoints/telemetry_endpoint.dart' as _i15;
import 'package:deyelyte_server/src/generated/app_config.dart' as _i16;
import 'package:deyelyte_server/src/generated/price_time_range.dart' as _i17;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i18;
import 'package:deyelyte_server/src/generated/future_calls.dart' as _i19;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'admin': _i2.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'appConfig': _i3.AppConfigEndpoint()
        ..initialize(
          server,
          'appConfig',
          null,
        ),
      'baseline': _i4.BaselineEndpoint()
        ..initialize(
          server,
          'baseline',
          null,
        ),
      'credentials': _i5.CredentialsEndpoint()
        ..initialize(
          server,
          'credentials',
          null,
        ),
      'device': _i6.DeviceEndpoint()
        ..initialize(
          server,
          'device',
          null,
        ),
      'example': _i7.ExampleEndpoint()
        ..initialize(
          server,
          'example',
          null,
        ),
      'forecast': _i8.ForecastEndpoint()
        ..initialize(
          server,
          'forecast',
          null,
        ),
      'history': _i9.HistoryEndpoint()
        ..initialize(
          server,
          'history',
          null,
        ),
      'license': _i10.LicenseEndpoint()
        ..initialize(
          server,
          'license',
          null,
        ),
      'optimizer': _i11.OptimizerEndpoint()
        ..initialize(
          server,
          'optimizer',
          null,
        ),
      'price': _i12.PriceEndpoint()
        ..initialize(
          server,
          'price',
          null,
        ),
      'priceTimeRanges': _i13.PriceTimeRangesEndpoint()
        ..initialize(
          server,
          'priceTimeRanges',
          null,
        ),
      'schedule': _i14.ScheduleEndpoint()
        ..initialize(
          server,
          'schedule',
          null,
        ),
      'telemetry': _i15.TelemetryEndpoint()
        ..initialize(
          server,
          'telemetry',
          null,
        ),
    };
    connectors['admin'] = _i1.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'checkAccess': _i1.MethodConnector(
          name: 'checkAccess',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i2.AdminEndpoint).checkAccess(
                session,
              ),
        ),
        'listLicenseKeys': _i1.MethodConnector(
          name: 'listLicenseKeys',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i2.AdminEndpoint)
                  .listLicenseKeys(session),
        ),
        'createLicenseKey': _i1.MethodConnector(
          name: 'createLicenseKey',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'tier': _i1.ParameterDescription(
              name: 'tier',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'expiresAt': _i1.ParameterDescription(
              name: 'expiresAt',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i2.AdminEndpoint).createLicenseKey(
                    session,
                    userId: params['userId'],
                    tier: params['tier'],
                    expiresAt: params['expiresAt'],
                  ),
        ),
        'setLicenseKeyActive': _i1.MethodConnector(
          name: 'setLicenseKeyActive',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'active': _i1.ParameterDescription(
              name: 'active',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i2.AdminEndpoint).setLicenseKeyActive(
                    session,
                    id: params['id'],
                    active: params['active'],
                  ),
        ),
        'listUsers': _i1.MethodConnector(
          name: 'listUsers',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i2.AdminEndpoint).listUsers(session),
        ),
        'listDevices': _i1.MethodConnector(
          name: 'listDevices',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i2.AdminEndpoint).listDevices(
                session,
              ),
        ),
        'listTierPermissions': _i1.MethodConnector(
          name: 'listTierPermissions',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i2.AdminEndpoint)
                  .listTierPermissions(session),
        ),
        'updateTierPermissions': _i1.MethodConnector(
          name: 'updateTierPermissions',
          params: {
            'tier': _i1.ParameterDescription(
              name: 'tier',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'syncIntervalSeconds': _i1.ParameterDescription(
              name: 'syncIntervalSeconds',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'historyDurationDays': _i1.ParameterDescription(
              name: 'historyDurationDays',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i2.AdminEndpoint)
                  .updateTierPermissions(
                    session,
                    tier: params['tier'],
                    syncIntervalSeconds: params['syncIntervalSeconds'],
                    historyDurationDays: params['historyDurationDays'],
                  ),
        ),
      },
    );
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
              ) async => (endpoints['appConfig'] as _i3.AppConfigEndpoint)
                  .getConfig(session),
        ),
        'saveConfig': _i1.MethodConnector(
          name: 'saveConfig',
          params: {
            'config': _i1.ParameterDescription(
              name: 'config',
              type: _i1.getType<_i16.AppConfig>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['appConfig'] as _i3.AppConfigEndpoint).saveConfig(
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
              ) async => (endpoints['baseline'] as _i4.BaselineEndpoint)
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
              ) async => (endpoints['credentials'] as _i5.CredentialsEndpoint)
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
              ) async => (endpoints['credentials'] as _i5.CredentialsEndpoint)
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
              ) async => (endpoints['credentials'] as _i5.CredentialsEndpoint)
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
              ) async => (endpoints['credentials'] as _i5.CredentialsEndpoint)
                  .removeDeye(session),
        ),
        'removeSolcast': _i1.MethodConnector(
          name: 'removeSolcast',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['credentials'] as _i5.CredentialsEndpoint)
                  .removeSolcast(session),
        ),
        'removePstryk': _i1.MethodConnector(
          name: 'removePstryk',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['credentials'] as _i5.CredentialsEndpoint)
                  .removePstryk(session),
        ),
        'getStatus': _i1.MethodConnector(
          name: 'getStatus',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['credentials'] as _i5.CredentialsEndpoint)
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
              ) async => (endpoints['device'] as _i6.DeviceEndpoint).getStatus(
                session,
              ),
        ),
        'listModels': _i1.MethodConnector(
          name: 'listModels',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['device'] as _i6.DeviceEndpoint).listModels(
                session,
              ),
        ),
        'setModel': _i1.MethodConnector(
          name: 'setModel',
          params: {
            'modelId': _i1.ParameterDescription(
              name: 'modelId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['device'] as _i6.DeviceEndpoint).setModel(
                session,
                params['modelId'],
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
              ) async => (endpoints['example'] as _i7.ExampleEndpoint).hello(
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
              ) async => (endpoints['forecast'] as _i8.ForecastEndpoint)
                  .updateForecast(session),
        ),
        'getForecast': _i1.MethodConnector(
          name: 'getForecast',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['forecast'] as _i8.ForecastEndpoint)
                  .getForecast(session),
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
                  (endpoints['history'] as _i9.HistoryEndpoint).getSummary(
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
                  (endpoints['history'] as _i9.HistoryEndpoint).getEvents(
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
              ) async =>
                  (endpoints['license'] as _i10.LicenseEndpoint).validate(
                    session,
                    params['licenseKey'],
                  ),
        ),
        'getUserLicense': _i1.MethodConnector(
          name: 'getUserLicense',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['license'] as _i10.LicenseEndpoint)
                  .getUserLicense(session),
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
              ) async => (endpoints['optimizer'] as _i11.OptimizerEndpoint)
                  .calculateAndStore(session),
        ),
        'getSchedule': _i1.MethodConnector(
          name: 'getSchedule',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['optimizer'] as _i11.OptimizerEndpoint)
                  .getSchedule(session),
        ),
        'requestTopUp': _i1.MethodConnector(
          name: 'requestTopUp',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['optimizer'] as _i11.OptimizerEndpoint)
                  .requestTopUp(session),
        ),
        'cancelTopUp': _i1.MethodConnector(
          name: 'cancelTopUp',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['optimizer'] as _i11.OptimizerEndpoint)
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
              ) async => (endpoints['optimizer'] as _i11.OptimizerEndpoint)
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
              ) async => (endpoints['optimizer'] as _i11.OptimizerEndpoint)
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
              ) async => (endpoints['optimizer'] as _i11.OptimizerEndpoint)
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
                  (endpoints['price'] as _i12.PriceEndpoint).updatePrices(
                    session,
                    params['token'],
                    params['userInfoId'],
                  ),
        ),
        'triggerFetch': _i1.MethodConnector(
          name: 'triggerFetch',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['price'] as _i12.PriceEndpoint)
                  .triggerFetch(session),
        ),
        'getPricesForPeriod': _i1.MethodConnector(
          name: 'getPricesForPeriod',
          params: {
            'days': _i1.ParameterDescription(
              name: 'days',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['price'] as _i12.PriceEndpoint).getPricesForPeriod(
                    session,
                    params['days'],
                  ),
        ),
        'getTodayPrices': _i1.MethodConnector(
          name: 'getTodayPrices',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['price'] as _i12.PriceEndpoint)
                  .getTodayPrices(session),
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
                  (endpoints['priceTimeRanges'] as _i13.PriceTimeRangesEndpoint)
                      .getTimeRanges(session),
        ),
        'saveTimeRanges': _i1.MethodConnector(
          name: 'saveTimeRanges',
          params: {
            'ranges': _i1.ParameterDescription(
              name: 'ranges',
              type: _i1.getType<List<_i17.PriceTimeRange>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['priceTimeRanges'] as _i13.PriceTimeRangesEndpoint)
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
              ) async => (endpoints['schedule'] as _i14.ScheduleEndpoint)
                  .getCurrent(session),
        ),
        'getForecast': _i1.MethodConnector(
          name: 'getForecast',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['schedule'] as _i14.ScheduleEndpoint)
                  .getForecast(session),
        ),
        'getTodayFrames': _i1.MethodConnector(
          name: 'getTodayFrames',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['schedule'] as _i14.ScheduleEndpoint)
                  .getTodayFrames(session),
        ),
        'getFramesForPeriod': _i1.MethodConnector(
          name: 'getFramesForPeriod',
          params: {
            'days': _i1.ParameterDescription(
              name: 'days',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['schedule'] as _i14.ScheduleEndpoint)
                  .getFramesForPeriod(
                    session,
                    params['days'],
                  ),
        ),
        'getEvents': _i1.MethodConnector(
          name: 'getEvents',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['schedule'] as _i14.ScheduleEndpoint)
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
                  (endpoints['schedule'] as _i14.ScheduleEndpoint).getSchedule(
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
              ) async => (endpoints['schedule'] as _i14.ScheduleEndpoint)
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
            'currentModelId': _i1.ParameterDescription(
              name: 'currentModelId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'hmacTimestamp': _i1.ParameterDescription(
              name: 'hmacTimestamp',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'hmacSignature': _i1.ParameterDescription(
              name: 'hmacSignature',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['telemetry'] as _i15.TelemetryEndpoint).ingest(
                    session,
                    params['licenseKey'],
                    params['deviceId'],
                    params['timestamp'],
                    params['batterySOC'],
                    params['gridPowerW'],
                    params['pvPowerW'],
                    params['loadPowerW'],
                    params['batteryPowerW'],
                    params['currentModelId'],
                    params['hmacTimestamp'],
                    params['hmacSignature'],
                  ),
        ),
        'getLatest': _i1.MethodConnector(
          name: 'getLatest',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['telemetry'] as _i15.TelemetryEndpoint)
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
                  (endpoints['telemetry'] as _i15.TelemetryEndpoint).getHistory(
                    session,
                    params['hours'],
                  ),
        ),
      },
    );
    modules['serverpod_auth'] = _i18.Endpoints()..initializeEndpoints(server);
  }

  @override
  _i1.FutureCallDispatch? get futureCalls {
    return _i19.FutureCalls();
  }
}
