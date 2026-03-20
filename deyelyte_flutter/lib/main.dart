import 'package:deyelyte_client/deyelyte_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

import 'auth_screen.dart';
import 'app_shell.dart';
import 'theme/app_theme.dart';

late Client client;
late SessionManager sessionManager;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  client = Client(
    'http://localhost:8080/',
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  );

  sessionManager = SessionManager(
    caller: client.modules.auth,
  );
  await sessionManager.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    sessionManager.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeyLyte',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: sessionManager.isSignedIn ? const AppShell() : const AuthScreen(),
    );
  }
}
