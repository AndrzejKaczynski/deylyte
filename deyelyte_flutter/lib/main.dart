import 'package:deyelyte_client/deyelyte_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

import 'auth_screen.dart';
import 'app_shell.dart';
import 'theme/theme.dart';
import 'providers/app_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = Client(
    'http://localhost:8080/',
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  );

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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSignedIn = ref.watch(sessionManagerProvider).isSignedIn;
    return MaterialApp(
      title: 'DeyLyte',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: isSignedIn ? const AppShell() : const AuthScreen(),
    );
  }
}
