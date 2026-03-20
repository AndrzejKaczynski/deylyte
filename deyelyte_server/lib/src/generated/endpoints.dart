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
import '../endpoints/example_endpoint.dart' as _i4;
import '../endpoints/forecast_endpoint.dart' as _i5;
import '../endpoints/optimizer_endpoint.dart' as _i6;
import '../endpoints/price_endpoint.dart' as _i7;
import 'package:deyelyte_server/src/generated/app_config.dart' as _i8;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i9;

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
      'example': _i4.ExampleEndpoint()
        ..initialize(
          server,
          'example',
          null,
        ),
      'forecast': _i5.ForecastEndpoint()
        ..initialize(
          server,
          'forecast',
          null,
        ),
      'optimizer': _i6.OptimizerEndpoint()
        ..initialize(
          server,
          'optimizer',
          null,
        ),
      'price': _i7.PriceEndpoint()
        ..initialize(
          server,
          'price',
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
              type: _i1.getType<_i8.AppConfig>(),
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
              ) async => (endpoints['example'] as _i4.ExampleEndpoint).hello(
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
              ) async => (endpoints['forecast'] as _i5.ForecastEndpoint)
                  .updateForecast(session),
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
              ) async => (endpoints['optimizer'] as _i6.OptimizerEndpoint)
                  .calculateAndStore(session),
        ),
        'getSchedule': _i1.MethodConnector(
          name: 'getSchedule',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['optimizer'] as _i6.OptimizerEndpoint)
                  .getSchedule(session),
        ),
        'requestTopUp': _i1.MethodConnector(
          name: 'requestTopUp',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['optimizer'] as _i6.OptimizerEndpoint)
                  .requestTopUp(session),
        ),
        'cancelTopUp': _i1.MethodConnector(
          name: 'cancelTopUp',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['optimizer'] as _i6.OptimizerEndpoint)
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
              ) async => (endpoints['optimizer'] as _i6.OptimizerEndpoint)
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
              ) async => (endpoints['optimizer'] as _i6.OptimizerEndpoint)
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
              ) async => (endpoints['optimizer'] as _i6.OptimizerEndpoint)
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
              ) async => (endpoints['price'] as _i7.PriceEndpoint).updatePrices(
                session,
                params['token'],
                params['userInfoId'],
              ),
        ),
      },
    );
    modules['serverpod_auth'] = _i9.Endpoints()..initializeEndpoints(server);
  }
}
