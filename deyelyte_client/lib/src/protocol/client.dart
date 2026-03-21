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
import 'package:deyelyte_client/src/protocol/price_time_range.dart' as _i6;
import 'package:deyelyte_client/src/protocol/device_telemetry.dart' as _i7;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i8;
import 'protocol.dart' as _i9;

/// All methods require the caller to be an authenticated admin.
/// Admin rows are created exclusively via direct SQL — no endpoint can
/// grant or revoke admin status.
/// {@category Endpoint}
class EndpointAdmin extends _i1.EndpointRef {
  EndpointAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  /// Returns true if the authenticated user is an admin. Used by the Flutter
  /// router to decide whether to show the /admin section.
  _i2.Future<bool> checkAccess() => caller.callServerEndpoint<bool>(
    'admin',
    'checkAccess',
    {},
  );

  /// Returns all license keys, newest first, with basic user info (JSON string).
  _i2.Future<String> listLicenseKeys() => caller.callServerEndpoint<String>(
    'admin',
    'listLicenseKeys',
    {},
  );

  /// Creates a new license key for [userId] with the given [tier].
  /// Returns the generated key string.
  _i2.Future<String> createLicenseKey({
    required int userId,
    required String tier,
    DateTime? expiresAt,
  }) => caller.callServerEndpoint<String>(
    'admin',
    'createLicenseKey',
    {
      'userId': userId,
      'tier': tier,
      'expiresAt': expiresAt,
    },
  );

  /// Activates or deactivates a license key by its DB id.
  _i2.Future<void> setLicenseKeyActive({
    required int id,
    required bool active,
  }) => caller.callServerEndpoint<void>(
    'admin',
    'setLicenseKeyActive',
    {
      'id': id,
      'active': active,
    },
  );

  /// Returns all users with their app config and device status (JSON string).
  _i2.Future<String> listUsers() => caller.callServerEndpoint<String>(
    'admin',
    'listUsers',
    {},
  );

  /// Returns all registered devices with connection status (JSON string).
  _i2.Future<String> listDevices() => caller.callServerEndpoint<String>(
    'admin',
    'listDevices',
    {},
  );
}

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
  /// appId and appSecret are read from server config (passwords.yaml) — not
  /// supplied by the user.
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

/// Returns HA add-on connection status for the authenticated user.
/// Called by Flutter on every app launch and by the onboarding polling widget.
/// {@category Endpoint}
class EndpointDevice extends _i1.EndpointRef {
  EndpointDevice(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'device';

  /// Returns add-on connection status.
  ///
  /// Response fields:
  ///   connected       — true when telemetry received within last 5 minutes
  ///   lastSeenAt      — ISO8601 UTC of most recent telemetry, or null
  ///   inverterReachable — true if last telemetry had valid inverter state
  _i2.Future<Map<String, dynamic>> getStatus() =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'device',
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

/// Returns historical energy summaries and events for the Flutter history screen.
/// Stub implementation — returns zero/empty data until the baseline engine
/// and telemetry aggregation are wired in a later phase.
/// {@category Endpoint}
class EndpointHistory extends _i1.EndpointRef {
  EndpointHistory(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'history';

  /// Returns aggregate summary metrics for the given date range.
  ///
  /// [rangeDays] — number of days to include (7, 30, or 90)
  ///
  /// Stub returns zero values. Real implementation will aggregate
  /// DeviceTelemetry + EnergyPrice rows.
  _i2.Future<Map<String, dynamic>> getSummary(int rangeDays) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'history',
        'getSummary',
        {'rangeDays': rangeDays},
      );

  /// Returns a list of notable market/schedule events for the history screen.
  ///
  /// [rangeDays] — number of days to include (7, 30, or 90)
  ///
  /// Stub returns empty list.
  _i2.Future<List<Map<String, dynamic>>> getEvents(int rangeDays) =>
      caller.callServerEndpoint<List<Map<String, dynamic>>>(
        'history',
        'getEvents',
        {'rangeDays': rangeDays},
      );
}

/// License key validation. Called during onboarding (user is authenticated
/// but license not yet verified). Also called by the HA add-on on startup.
/// {@category Endpoint}
class EndpointLicense extends _i1.EndpointRef {
  EndpointLicense(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'license';

  /// Validates a license key and associates it with the authenticated user.
  ///
  /// Returns:
  ///   valid  — bool
  ///   tier   — String? ('beta_free' | 'basic' | 'pro') when valid
  ///   reason — String? human-readable denial reason when invalid
  _i2.Future<Map<String, dynamic>> validate(String licenseKey) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'license',
        'validate',
        {'licenseKey': licenseKey},
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

/// {@category Endpoint}
class EndpointPriceTimeRanges extends _i1.EndpointRef {
  EndpointPriceTimeRanges(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'priceTimeRanges';

  /// Returns all time ranges for the authenticated user.
  _i2.Future<List<_i6.PriceTimeRange>> getTimeRanges() =>
      caller.callServerEndpoint<List<_i6.PriceTimeRange>>(
        'priceTimeRanges',
        'getTimeRanges',
        {},
      );

  /// Replaces all time ranges for the authenticated user.
  _i2.Future<void> saveTimeRanges(List<_i6.PriceTimeRange> ranges) =>
      caller.callServerEndpoint<void>(
        'priceTimeRanges',
        'saveTimeRanges',
        {'ranges': ranges},
      );
}

/// Serves optimization schedules to the Flutter app and the HA add-on.
/// {@category Endpoint}
class EndpointSchedule extends _i1.EndpointRef {
  EndpointSchedule(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'schedule';

  /// Returns the OptimizationFrame for the current hour, or null.
  _i2.Future<_i4.OptimizationFrame?> getCurrent() =>
      caller.callServerEndpoint<_i4.OptimizationFrame?>(
        'schedule',
        'getCurrent',
        {},
      );

  /// Returns all upcoming OptimizationFrames (current hour onwards).
  _i2.Future<List<_i4.OptimizationFrame>> getForecast() =>
      caller.callServerEndpoint<List<_i4.OptimizationFrame>>(
        'schedule',
        'getForecast',
        {},
      );

  /// Returns schedule events as a list of maps for the Flutter schedule screen.
  /// Stub: returns empty list until optimization engine is wired.
  _i2.Future<List<Map<String, dynamic>>> getEvents() =>
      caller.callServerEndpoint<List<Map<String, dynamic>>>(
        'schedule',
        'getEvents',
        {},
      );

  /// Returns upcoming OptimizationFrames for the user associated with
  /// [licenseKey]. Returns an empty list on invalid license.
  _i2.Future<List<_i4.OptimizationFrame>> getSchedule(String licenseKey) =>
      caller.callServerEndpoint<List<_i4.OptimizationFrame>>(
        'schedule',
        'getSchedule',
        {'licenseKey': licenseKey},
      );

  /// Returns schedule frames AND an offline fallback policy for the add-on.
  ///
  /// The add-on should cache this response locally. If the server is
  /// unreachable for more than [offlineGraceMinutes] (default 15), the add-on
  /// applies [offlineFallback] instead of the cached schedule — stopping all
  /// active charging/discharging commands to protect against expensive
  /// runaway behaviour. Default grace period is 120 minutes (2 missed hourly
  /// fetches) to avoid false positives from brief server restarts.
  ///
  /// [offlineFallback] keys:
  ///   - `chargingEnabled` (bool)  — whether to charge when offline
  ///   - `sellingEnabled`  (bool)  — whether to discharge/sell when offline
  ///   - `maxBuyPricePln`  (double) — max buy price to honour offline
  ///   - `priceSource`     (String) — pricing mode used for this fallback
  ///   - `offlineGraceMinutes` (int) — grace period before fallback activates
  _i2.Future<Map<String, dynamic>> getScheduleWithFallback(String licenseKey) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'schedule',
        'getScheduleWithFallback',
        {'licenseKey': licenseKey},
      );
}

/// Handles inverter telemetry from the HA add-on and serves telemetry
/// history to the Flutter app.
/// {@category Endpoint}
class EndpointTelemetry extends _i1.EndpointRef {
  EndpointTelemetry(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'telemetry';

  /// Receives a single telemetry snapshot from the HA add-on.
  /// Auth: the add-on provides its licenseKey as a plain parameter.
  ///
  /// On success:
  ///   - Upserts a Device row (updates lastSeenAt + lastInverterOk)
  ///   - Inserts a DeviceTelemetry row
  _i2.Future<void> ingest(
    String licenseKey,
    String deviceId,
    DateTime timestamp,
    double batterySOC,
    double gridPowerW,
    double pvPowerW,
    double loadPowerW,
    double batteryPowerW,
  ) => caller.callServerEndpoint<void>(
    'telemetry',
    'ingest',
    {
      'licenseKey': licenseKey,
      'deviceId': deviceId,
      'timestamp': timestamp,
      'batterySOC': batterySOC,
      'gridPowerW': gridPowerW,
      'pvPowerW': pvPowerW,
      'loadPowerW': loadPowerW,
      'batteryPowerW': batteryPowerW,
    },
  );

  /// Returns the most recent telemetry snapshot for the authenticated user.
  /// Returns null when no telemetry has been received yet.
  _i2.Future<_i7.DeviceTelemetry?> getLatest() =>
      caller.callServerEndpoint<_i7.DeviceTelemetry?>(
        'telemetry',
        'getLatest',
        {},
      );

  /// Returns up to [hours] hours of telemetry history for the authenticated user.
  _i2.Future<List<_i7.DeviceTelemetry>> getHistory(int hours) =>
      caller.callServerEndpoint<List<_i7.DeviceTelemetry>>(
        'telemetry',
        'getHistory',
        {'hours': hours},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i8.Caller(client);
  }

  late final _i8.Caller auth;
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
         _i9.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    admin = EndpointAdmin(this);
    appConfig = EndpointAppConfig(this);
    baseline = EndpointBaseline(this);
    credentials = EndpointCredentials(this);
    device = EndpointDevice(this);
    example = EndpointExample(this);
    forecast = EndpointForecast(this);
    history = EndpointHistory(this);
    license = EndpointLicense(this);
    optimizer = EndpointOptimizer(this);
    price = EndpointPrice(this);
    priceTimeRanges = EndpointPriceTimeRanges(this);
    schedule = EndpointSchedule(this);
    telemetry = EndpointTelemetry(this);
    modules = Modules(this);
  }

  late final EndpointAdmin admin;

  late final EndpointAppConfig appConfig;

  late final EndpointBaseline baseline;

  late final EndpointCredentials credentials;

  late final EndpointDevice device;

  late final EndpointExample example;

  late final EndpointForecast forecast;

  late final EndpointHistory history;

  late final EndpointLicense license;

  late final EndpointOptimizer optimizer;

  late final EndpointPrice price;

  late final EndpointPriceTimeRanges priceTimeRanges;

  late final EndpointSchedule schedule;

  late final EndpointTelemetry telemetry;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'admin': admin,
    'appConfig': appConfig,
    'baseline': baseline,
    'credentials': credentials,
    'device': device,
    'example': example,
    'forecast': forecast,
    'history': history,
    'license': license,
    'optimizer': optimizer,
    'price': price,
    'priceTimeRanges': priceTimeRanges,
    'schedule': schedule,
    'telemetry': telemetry,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'auth': modules.auth,
  };
}
