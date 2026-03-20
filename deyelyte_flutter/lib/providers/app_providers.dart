import 'package:deyelyte_client/deyelyte_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

/// Serverpod HTTP client — overridden in main() via ProviderScope.
final clientProvider = Provider<Client>(
  (ref) => throw UnimplementedError('clientProvider not overridden'),
);

/// Serverpod SessionManager (ChangeNotifier) — overridden in main() via ProviderScope.
/// Watching this provider re-builds widgets whenever auth state changes.
final sessionManagerProvider = ChangeNotifierProvider<SessionManager>(
  (ref) => throw UnimplementedError('sessionManagerProvider not overridden'),
);

/// Selected date range index for HistoryScreen (0=7d, 1=30d, 2=90d).
final historyRangeProvider = StateProvider<int>((ref) => 1);

/// Loads the user's AppConfig from the server. Null if the user has no config yet.
class AppConfigNotifier extends AsyncNotifier<AppConfig?> {
  @override
  Future<AppConfig?> build() async {
    return ref.read(clientProvider).appConfig.getConfig();
  }

  Future<void> save(AppConfig config) async {
    await ref.read(clientProvider).appConfig.saveConfig(config);
  }
}

final appConfigProvider =
    AsyncNotifierProvider<AppConfigNotifier, AppConfig?>(AppConfigNotifier.new);
