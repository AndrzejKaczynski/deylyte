import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../components/surface_card.dart';

/// Wraps all /admin sub-screens with a minimal sidebar nav.
class AdminShell extends StatelessWidget {
  const AdminShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: Row(children: [
        // ── Sidebar ────────────────────────────────────────────────────────
        SizedBox(
          width: 200,
          child: SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sp4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Admin',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          )),
                ),
                const SizedBox(height: AppSpacing.sp4),
                _NavItem(
                  icon: Icons.vpn_key_rounded,
                  label: 'License Keys',
                  route: '/admin/licenses',
                  active: loc.startsWith('/admin/licenses'),
                ),
                _NavItem(
                  icon: Icons.people_rounded,
                  label: 'Users',
                  route: '/admin/users',
                  active: loc.startsWith('/admin/users'),
                ),
                _NavItem(
                  icon: Icons.developer_board_rounded,
                  label: 'Devices',
                  route: '/admin/devices',
                  active: loc.startsWith('/admin/devices'),
                ),
                const Spacer(),
                const _NavItem(
                  icon: Icons.arrow_back_rounded,
                  label: 'Back to app',
                  route: '/',
                  active: false,
                ),
                const SizedBox(height: AppSpacing.sp4),
              ],
            ),
          ),
        ),
        // ── Main content ───────────────────────────────────────────────────
        Expanded(
          child: child,
        ),
      ]),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.active,
  });

  final IconData icon;
  final String label;
  final String route;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: active
            ? BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: Row(children: [
          Icon(icon,
              size: 18,
              color: active
                  ? AppColors.primary
                  : AppColors.onSurfaceVariant),
          const SizedBox(width: 10),
          Text(label,
              style: tt.bodyMedium?.copyWith(
                color: active ? AppColors.primary : AppColors.onSurfaceVariant,
                fontWeight:
                    active ? FontWeight.w600 : FontWeight.normal,
              )),
        ]),
      ),
    );
  }
}
