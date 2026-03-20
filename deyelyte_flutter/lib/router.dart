import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app_shell.dart';
import 'auth_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'providers/app_providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final sessionManager = ref.read(sessionManagerProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: sessionManager,
    redirect: (context, state) {
      final loggedIn = sessionManager.isSignedIn;
      final onAuth = state.matchedLocation == '/auth';
      if (!loggedIn && !onAuth) return '/auth';
      if (loggedIn && onAuth) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        builder: (_, __) => const AuthScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/schedule',
            builder: (_, __) => const ScheduleScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (_, __) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (_, __) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});
