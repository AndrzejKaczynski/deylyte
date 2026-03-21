import 'package:deyelyte_client/deyelyte_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

import 'config/app_config.dart';
import 'theme/theme.dart';
import 'providers/app_providers.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = Client(Env.serverpodUrl)
    ..authKeyProvider = FlutterAuthenticationKeyManager();

  final sessionManager = SessionManager(
    caller: client.modules.auth,
  );
  await sessionManager.initialize();

  runApp(
    ProviderScope(
      overrides: [
        clientProvider.overrideWithValue(client),
        sessionManagerProvider.overrideWith((ref) => sessionManager),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'DeyLyte',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
