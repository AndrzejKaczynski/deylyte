import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import 'app_shell.dart';
import 'auth_screen.dart';
import 'config/app_config.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/schedule/schedule_screen.dart';
import 'screens/history/history_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/onboarding/onboarding_license_screen.dart';
import 'screens/onboarding/onboarding_setup_screen.dart';
import 'screens/admin/admin_shell.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/admin_licenses_screen.dart';
import 'screens/admin/admin_users_screen.dart';
import 'screens/admin/admin_devices_screen.dart';
import 'screens/admin/admin_sync_settings_screen.dart';
import 'providers/admin_provider.dart';
import 'providers/app_providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final sessionManager = ref.read(sessionManagerProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: sessionManager,
    redirect: (context, state) async {
      final loggedIn = sessionManager.isSignedIn;
      final loc = state.matchedLocation;

      // Not signed in — go to auth
      if (!loggedIn) {
        return loc == '/auth' ? null : '/auth';
      }

      // Already signed in, sitting on auth — push to app
      if (loc == '/auth') return '/';

      // BYPASS_ONBOARDING skips onboarding checks entirely (dev mode)
      if (Env.bypassOnboarding) return null;

      // Already in onboarding — don't redirect
      if (loc.startsWith('/onboarding')) return null;

      // Admin section — check role once (result is cached by isAdminProvider)
      if (loc.startsWith('/admin')) {
        final isAdmin = await ref.read(isAdminProvider.future);
        return isAdmin ? null : '/';
      }

      // Check license key — local storage first, then server fallback.
      const storage = FlutterSecureStorage();
      final localKey = await storage.read(key: 'license_key');
      final hasLocalLicense = localKey?.isNotEmpty ?? false;

      if (!hasLocalLicense) {
        // Local key missing — check server directly (bypass cached provider).
        try {
          final raw = await ref.read(clientProvider).license.getUserLicense();
          final data = jsonDecode(raw) as Map<String, dynamic>;
          if (data['tier'] == null) return '/onboarding/license';
        } catch (_) {
          return '/onboarding/license';
        }
      }

      // Check device connection (has ever connected)
      try {
        final repo = ref.read(deviceRepositoryProvider);
        final status = await repo.getStatus();
        final everConnected = status['lastSeenAt'] != null ||
            status['connected'] == true;
        if (!everConnected) return '/onboarding/setup';
      } catch (_) {
        // If server unreachable, let the user through rather than blocking forever
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        builder: (_, __) => const AuthScreen(),
      ),
      GoRoute(
        path: '/onboarding/license',
        builder: (_, __) => const OnboardingLicenseScreen(),
      ),
      GoRoute(
        path: '/onboarding/setup',
        builder: (_, __) => const OnboardingSetupScreen(),
      ),
      // ── Admin section (role gated in top-level redirect above) ────────
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: '/admin',
            redirect: (_, __) => '/admin/dashboard',
          ),
          GoRoute(
            path: '/admin/dashboard',
            builder: (_, __) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: '/admin/licenses',
            builder: (_, __) => const AdminLicensesScreen(),
          ),
          GoRoute(
            path: '/admin/users',
            builder: (_, __) => const AdminUsersScreen(),
          ),
          GoRoute(
            path: '/admin/devices',
            builder: (_, __) => const AdminDevicesScreen(),
          ),
          GoRoute(
            path: '/admin/sync-settings',
            builder: (_, __) => const AdminSyncSettingsScreen(),
          ),
        ],
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
