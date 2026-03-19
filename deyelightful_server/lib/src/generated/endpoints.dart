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
import '../endpoints/baseline_endpoint.dart' as _i2;
import '../endpoints/example_endpoint.dart' as _i3;
import '../endpoints/forecast_endpoint.dart' as _i4;
import '../endpoints/price_endpoint.dart' as _i5;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i6;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'baseline': _i2.BaselineEndpoint()
        ..initialize(
          server,
          'baseline',
          null,
        ),
      'example': _i3.ExampleEndpoint()
        ..initialize(
          server,
          'example',
          null,
        ),
      'forecast': _i4.ForecastEndpoint()
        ..initialize(
          server,
          'forecast',
          null,
        ),
      'price': _i5.PriceEndpoint()
        ..initialize(
          server,
          'price',
          null,
        ),
    };
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
              ) async => (endpoints['baseline'] as _i2.BaselineEndpoint)
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
              ) async => (endpoints['example'] as _i3.ExampleEndpoint).hello(
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
              ) async => (endpoints['forecast'] as _i4.ForecastEndpoint)
                  .updateForecast(
                    session,
                    params['apiKey'],
                    params['siteId'],
                    params['userInfoId'],
                  ),
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
              ) async => (endpoints['price'] as _i5.PriceEndpoint).updatePrices(
                session,
                params['token'],
                params['userInfoId'],
              ),
        ),
      },
    );
    modules['serverpod_auth'] = _i6.Endpoints()..initializeEndpoints(server);
  }
}
