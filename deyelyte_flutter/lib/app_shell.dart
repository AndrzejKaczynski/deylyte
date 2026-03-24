import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'theme/theme.dart';
import 'providers/app_providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppShell – adaptive navigation container
//
// Desktop  →  persistent left sidebar  (surface-container-lowest)
// Mobile   →  bottom navigation bar   (semi-transparent, backdrop-blur)
// ─────────────────────────────────────────────────────────────────────────────

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _destinations = [
    _NavDestination(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard_rounded,
      label: 'Dashboard',
      route: '/',
    ),
    _NavDestination(
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today_rounded,
      label: 'Schedule',
      route: '/schedule',
    ),
    _NavDestination(
      icon: Icons.history_outlined,
      activeIcon: Icons.history_rounded,
      label: 'History',
      route: '/history',
    ),
    _NavDestination(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings_rounded,
      label: 'Settings',
      route: '/settings',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _destinations.indexWhere(
      (d) => d.route == location,
    ).clamp(0, _destinations.length - 1);

    final isDesktop = MediaQuery.sizeOf(context).width >= 900;

    void onDestinationSelected(int i) =>
        context.go(_destinations[i].route);

    void onSignOut() => ref.read(sessionManagerProvider).signOutDevice();

    return isDesktop
        ? _DesktopShell(
            selectedIndex: selectedIndex,
            destinations: _destinations,
            onDestinationSelected: onDestinationSelected,
            onSignOut: onSignOut,
            child: child,
          )
        : _MobileShell(
            selectedIndex: selectedIndex,
            destinations: _destinations,
            onDestinationSelected: onDestinationSelected,
            child: child,
          );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Desktop – left sidebar
// ─────────────────────────────────────────────────────────────────────────────

class _DesktopShell extends StatelessWidget {
  const _DesktopShell({
    required this.selectedIndex,
    required this.destinations,
    required this.onDestinationSelected,
    required this.onSignOut,
    required this.child,
  });

  final int selectedIndex;
  final List<_NavDestination> destinations;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onSignOut;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Row(
        children: [
          // ── Sidebar ───────────────────────────────────────────────────────
          _DesktopSidebar(
            selectedIndex: selectedIndex,
            destinations: destinations,
            onDestinationSelected: onDestinationSelected,
            onSignOut: onSignOut,
          ),
          // ── Content ───────────────────────────────────────────────────────
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _DesktopSidebar extends StatelessWidget {
  const _DesktopSidebar({
    required this.selectedIndex,
    required this.destinations,
    required this.onDestinationSelected,
    required this.onSignOut,
  });

  final int selectedIndex;
  final List<_NavDestination> destinations;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: AppColors.surfaceContainerLowest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
            child: Row(
              children: [
                const _BoltIcon(size: 22),
                const SizedBox(width: 10),
                Text(
                  'DeyLyte',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: -0.3,
                      ),
                ),
                const SizedBox(width: 8),
                const _BetaBadge(),
              ],
            ),
          ),
          // Label
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Text(
              'ENERGY MANAGEMENT',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.outline,
                    letterSpacing: 0.12,
                  ),
            ),
          ),
          // Nav items
          ...destinations.asMap().entries.map((e) {
            final i = e.key;
            final d = e.value;
            final active = selectedIndex == i;
            return _SidebarNavItem(
              icon: active ? d.activeIcon : d.icon,
              label: d.label,
              isActive: active,
              onTap: () => onDestinationSelected(i),
            );
          }),
          const Spacer(),
          // Sign out
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
            child: _SidebarNavItem(
              icon: Icons.logout_rounded,
              label: 'Sign Out',
              isActive: false,
              onTap: onSignOut,
              isDanger: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarNavItem extends StatefulWidget {
  const _SidebarNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isDanger = false,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isDanger;

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isDanger
        ? AppColors.error
        : widget.isActive
            ? AppColors.primary
            : _hovered
                ? AppColors.onSurface
                : AppColors.onSurfaceVariant;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.primary.withValues(alpha: 0.10)
                : _hovered
                    ? AppColors.surfaceContainerHigh.withValues(alpha: 0.6)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              // Active light-bar indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 3,
                height: widget.isActive ? 20 : 0,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Icon(widget.icon, size: 20, color: color),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mobile – bottom navigation bar
// ─────────────────────────────────────────────────────────────────────────────

class _MobileShell extends StatelessWidget {
  const _MobileShell({
    required this.selectedIndex,
    required this.destinations,
    required this.onDestinationSelected,
    required this.child,
  });

  final int selectedIndex;
  final List<_NavDestination> destinations;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          const _BetaBanner(),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: _GlassBottomBar(
        selectedIndex: selectedIndex,
        destinations: destinations,
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }
}

class _GlassBottomBar extends StatelessWidget {
  const _GlassBottomBar({
    required this.selectedIndex,
    required this.destinations,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final List<_NavDestination> destinations;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    return Container(
      color: AppColors.surfaceContainer.withValues(alpha: 0.80),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            top: 8,
            bottom: bottomPadding > 0 ? 0 : 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: destinations.asMap().entries.map((e) {
              final i = e.key;
              final d = e.value;
              final active = selectedIndex == i;
              return _BottomBarItem(
                icon: active ? d.activeIcon : d.icon,
                label: d.label,
                isActive: active,
                onTap: () => onDestinationSelected(i),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  const _BottomBarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, size: 22, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

class _NavDestination {
  const _NavDestination({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
}

/// Small pill badge shown next to the app name on desktop.
class _BetaBadge extends StatelessWidget {
  const _BetaBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.4)),
      ),
      child: Text(
        'BETA',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.tertiary,
              fontWeight: FontWeight.w700,
              fontSize: 9,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}

/// Thin amber strip shown at the top of the screen on mobile.
class _BetaBanner extends StatelessWidget {
  const _BetaBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.tertiary.withValues(alpha: 0.12),
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 4,
        bottom: 4,
      ),
      child: Text(
        'BETA — app is under active development',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.tertiary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
      ),
    );
  }
}

/// Reusable lightning-bolt icon used across the app shell.
class _BoltIcon extends StatelessWidget {
  const _BoltIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _BoltPainter()),
    );
  }
}

class _BoltPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.62, 0)
      ..lineTo(size.width * 0.25, size.height * 0.52)
      ..lineTo(size.width * 0.50, size.height * 0.52)
      ..lineTo(size.width * 0.38, size.height)
      ..lineTo(size.width * 0.75, size.height * 0.48)
      ..lineTo(size.width * 0.50, size.height * 0.48)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BoltPainter old) => false;
}
