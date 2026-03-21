/// Compile-time environment configuration for the DeyLyte Flutter app.
///
/// All constants are injected at build time via --dart-define.
/// They default to local-dev values and cannot be changed at runtime.
///
/// Usage:
///   flutter run -d chrome \
///     --dart-define=SERVERPOD_HOST=localhost \
///     --dart-define=SERVERPOD_PORT=8080
///
///   flutter build web \
///     --dart-define=SERVERPOD_HOST=api.deylyte.com \
///     --dart-define=SERVERPOD_PORT=443
class Env {
  /// Serverpod API hostname. Defaults to localhost for local development.
  static const String serverpodHost = String.fromEnvironment(
    'SERVERPOD_HOST',
    defaultValue: 'localhost',
  );

  /// Serverpod API port. Defaults to 8080 for local development.
  static const int serverpodPort = int.fromEnvironment(
    'SERVERPOD_PORT',
    defaultValue: 8080,
  );

  /// Full Serverpod API base URL, derived from host + port.
  static String get serverpodUrl =>
      'http://$serverpodHost:$serverpodPort/';

  /// When true, the onboarding gate is skipped and the app goes directly
  /// to the Dashboard. MUST NOT be set in production builds.
  static const bool bypassOnboarding = bool.fromEnvironment(
    'BYPASS_ONBOARDING',
    defaultValue: false,
  );

  /// When true, all data calls return mock data instead of hitting Serverpod.
  /// Enables UI development without a running backend.
  /// MUST NOT be set in production builds.
  static const bool useMockData = bool.fromEnvironment(
    'USE_MOCK_DATA',
    defaultValue: false,
  );
}
