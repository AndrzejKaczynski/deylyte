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
import 'dart:async' as _i2;
import 'package:deyelyte_client/src/protocol/app_config.dart' as _i3;
import 'package:deyelyte_client/src/protocol/optimization_frame.dart' as _i4;
import 'package:deyelyte_client/src/protocol/outage_reserve.dart' as _i5;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i6;
import 'protocol.dart' as _i7;

/// {@category Endpoint}
class EndpointAppConfig extends _i1.EndpointRef {
  EndpointAppConfig(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'appConfig';

  /// Returns the AppConfig for the authenticated user, or null if not yet set.
  _i2.Future<_i3.AppConfig?> getConfig() =>
      caller.callServerEndpoint<_i3.AppConfig?>(
        'appConfig',
        'getConfig',
        {},
      );

  /// Upserts the AppConfig for the authenticated user.
  /// The userInfoId field on the incoming config is ignored — it is always set
  /// to the authenticated user's ID.
  _i2.Future<void> saveConfig(_i3.AppConfig config) =>
      caller.callServerEndpoint<void>(
        'appConfig',
        'saveConfig',
        {'config': config},
      );
}

/// {@category Endpoint}
class EndpointBaseline extends _i1.EndpointRef {
  EndpointBaseline(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'baseline';

  _i2.Future<String> calculateBaseline(int userInfoId) =>
      caller.callServerEndpoint<String>(
        'baseline',
        'calculateBaseline',
        {'userInfoId': userInfoId},
      );
}

/// {@category Endpoint}
class EndpointCredentials extends _i1.EndpointRef {
  EndpointCredentials(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'credentials';

  /// Save Deye Cloud credentials. The password is stored as a SHA256 hash.
  /// appId and appSecret are read from server config — not supplied by the user.
  /// Schedules InitUserCall on the first save to fetch the device SN.
  _i2.Future<void> saveDeye(
    String username,
    String password,
  ) => caller.callServerEndpoint<void>(
    'credentials',
    'saveDeye',
    {
      'username': username,
      'password': password,
    },
  );

  /// Save Solcast PV forecast credentials.
  _i2.Future<void> saveSolcast(
    String apiKey,
    String siteId,
  ) => caller.callServerEndpoint<void>(
    'credentials',
    'saveSolcast',
    {
      'apiKey': apiKey,
      'siteId': siteId,
    },
  );

  /// Save Pstryk energy pricing token.
  _i2.Future<void> savePstryk(String token) => caller.callServerEndpoint<void>(
    'credentials',
    'savePstryk',
    {'token': token},
  );

  /// Remove Deye credentials. Also clears deviceSn and resets dataGatheringSince.
  _i2.Future<void> removeDeye() => caller.callServerEndpoint<void>(
    'credentials',
    'removeDeye',
    {},
  );

  /// Remove Solcast credentials.
  _i2.Future<void> removeSolcast() => caller.callServerEndpoint<void>(
    'credentials',
    'removeSolcast',
    {},
  );

  /// Remove Pstryk credentials.
  _i2.Future<void> removePstryk() => caller.callServerEndpoint<void>(
    'credentials',
    'removePstryk',
    {},
  );

  /// Returns which integrations are currently configured.
  _i2.Future<Map<String, bool>> getStatus() =>
      caller.callServerEndpoint<Map<String, bool>>(
        'credentials',
        'getStatus',
        {},
      );
}

/// {@category Endpoint}
class EndpointExample extends _i1.EndpointRef {
  EndpointExample(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'example';

  _i2.Future<String> hello(String name) => caller.callServerEndpoint<String>(
    'example',
    'hello',
    {'name': name},
  );
}

/// {@category Endpoint}
class EndpointForecast extends _i1.EndpointRef {
  EndpointForecast(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'forecast';

  /// Refreshes the PV forecast for the authenticated user.
  /// Uses Solcast if credentials are configured; falls back to the
  /// Open-Meteo estimator (requires cityName in AppConfig) if not.
  _i2.Future<void> updateForecast() => caller.callServerEndpoint<void>(
    'forecast',
    'updateForecast',
    {},
  );
}

/// {@category Endpoint}
class EndpointOptimizer extends _i1.EndpointRef {
  EndpointOptimizer(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'optimizer';

  /// Run the optimizer for the authenticated user, persist the 24-frame plan,
  /// and return it. Upserts by (userInfoId, hour) so repeated calls refresh
  /// the plan in place.
  _i2.Future<List<_i4.OptimizationFrame>> calculateAndStore() =>
      caller.callServerEndpoint<List<_i4.OptimizationFrame>>(
        'optimizer',
        'calculateAndStore',
        {},
      );

  /// Return the stored 24-hour plan for the authenticated user, ordered by hour.
  _i2.Future<List<_i4.OptimizationFrame>> getSchedule() =>
      caller.callServerEndpoint<List<_i4.OptimizationFrame>>(
        'optimizer',
        'getSchedule',
        {},
      );

  /// Set the one-off top-up flag — the next plan recalculation will charge
  /// to 100% at the cheapest available hours.
  _i2.Future<void> requestTopUp() => caller.callServerEndpoint<void>(
    'optimizer',
    'requestTopUp',
    {},
  );

  /// Cancel a pending top-up request.
  _i2.Future<void> cancelTopUp() => caller.callServerEndpoint<void>(
    'optimizer',
    'cancelTopUp',
    {},
  );

  /// Add an outage-reserve date. The optimizer will pre-charge cheaply to 100%
  /// before this date and block all selling on the day itself.
  _i2.Future<void> addOutageReserve(
    DateTime date,
    String? note,
  ) => caller.callServerEndpoint<void>(
    'optimizer',
    'addOutageReserve',
    {
      'date': date,
      'note': note,
    },
  );

  /// Remove an outage-reserve date.
  _i2.Future<void> removeOutageReserve(DateTime date) =>
      caller.callServerEndpoint<void>(
        'optimizer',
        'removeOutageReserve',
        {'date': date},
      );

  /// List all upcoming outage-reserve dates for the authenticated user.
  _i2.Future<List<_i5.OutageReserve>> getOutageReserves() =>
      caller.callServerEndpoint<List<_i5.OutageReserve>>(
        'optimizer',
        'getOutageReserves',
        {},
      );
}

/// {@category Endpoint}
class EndpointPrice extends _i1.EndpointRef {
  EndpointPrice(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'price';

  _i2.Future<void> updatePrices(
    String token,
    int userInfoId,
  ) => caller.callServerEndpoint<void>(
    'price',
    'updatePrices',
    {
      'token': token,
      'userInfoId': userInfoId,
    },
  );
}

class Modules {
  Modules(Client client) {
    auth = _i6.Caller(client);
  }

  late final _i6.Caller auth;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i7.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    appConfig = EndpointAppConfig(this);
    baseline = EndpointBaseline(this);
    credentials = EndpointCredentials(this);
    example = EndpointExample(this);
    forecast = EndpointForecast(this);
    optimizer = EndpointOptimizer(this);
    price = EndpointPrice(this);
    modules = Modules(this);
  }

  late final EndpointAppConfig appConfig;

  late final EndpointBaseline baseline;

  late final EndpointCredentials credentials;

  late final EndpointExample example;

  late final EndpointForecast forecast;

  late final EndpointOptimizer optimizer;

  late final EndpointPrice price;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'appConfig': appConfig,
    'baseline': baseline,
    'credentials': credentials,
    'example': example,
    'forecast': forecast,
    'optimizer': optimizer,
    'price': price,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'auth': modules.auth,
  };
}
