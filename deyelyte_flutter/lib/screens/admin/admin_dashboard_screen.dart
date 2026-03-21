import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../components/section_header.dart';
import '../../components/surface_card.dart';
import '../../components/pulse_indicator.dart';
import '../../providers/admin_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(adminUsersProvider);
    final keys = ref.watch(adminLicenseKeysProvider);
    final devices = ref.watch(adminDevicesProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sp6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const SectionHeader(title: 'Overview'),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh all',
            onPressed: () {
              ref.invalidate(adminUsersProvider);
              ref.invalidate(adminLicenseKeysProvider);
              ref.invalidate(adminDevicesProvider);
            },
          ),
        ]),
        const SizedBox(height: AppSpacing.sp4),

        // ── KPI row ────────────────────────────────────────────────────────
        Row(children: [
          Expanded(
            child: _KpiCard(
              icon: Icons.people_rounded,
              label: 'Total users',
              value: users.when(
                data: (l) => '${l.length}',
                loading: () => '—',
                error: (_, __) => '!',
              ),
              sub: users.when(
                data: (l) {
                  final live =
                      l.where((u) => u['planningOnly'] == false).length;
                  return '$live live';
                },
                loading: () => '',
                error: (_, __) => '',
              ),
              onTap: () => context.go('/admin/users'),
            ),
          ),
          const SizedBox(width: AppSpacing.sp4),
          Expanded(
            child: _KpiCard(
              icon: Icons.vpn_key_rounded,
              label: 'License keys',
              value: keys.when(
                data: (l) => '${l.length}',
                loading: () => '—',
                error: (_, __) => '!',
              ),
              sub: keys.when(
                data: (l) {
                  final active =
                      l.where((k) => k['isActive'] == true).length;
                  return '$active active';
                },
                loading: () => '',
                error: (_, __) => '',
              ),
              onTap: () => context.go('/admin/licenses'),
            ),
          ),
          const SizedBox(width: AppSpacing.sp4),
          Expanded(
            child: _KpiCard(
              icon: Icons.developer_board_rounded,
              label: 'Devices',
              value: devices.when(
                data: (l) => '${l.length}',
                loading: () => '—',
                error: (_, __) => '!',
              ),
              sub: devices.when(
                data: (l) {
                  final online =
                      l.where((d) => d['connected'] == true).length;
                  return '$online online';
                },
                loading: () => '',
                error: (_, __) => '',
              ),
              onTap: () => context.go('/admin/devices'),
            ),
          ),
        ]),

        const SizedBox(height: AppSpacing.sp4),

        // ── Recent devices ─────────────────────────────────────────────────
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Online devices
              Expanded(
                child: SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CardTitle(
                        icon: Icons.developer_board_rounded,
                        label: 'Connected devices',
                        onMore: () => context.go('/admin/devices'),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: devices.when(
                          loading: () => const Center(
                              child: CircularProgressIndicator()),
                          error: (e, _) =>
                              Center(child: Text('Error: $e')),
                          data: (list) {
                            final online = list
                                .where((d) => d['connected'] == true)
                                .toList();
                            if (online.isEmpty) {
                              return const Center(
                                  child:
                                      Text('No devices currently online.'));
                            }
                            return ListView.separated(
                              itemCount: online.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (_, i) {
                                final d = online[i];
                                return _DeviceRow(device: d);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sp4),
              // Recently created keys
              Expanded(
                child: SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CardTitle(
                        icon: Icons.vpn_key_rounded,
                        label: 'Recent license keys',
                        onMore: () => context.go('/admin/licenses'),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: keys.when(
                          loading: () => const Center(
                              child: CircularProgressIndicator()),
                          error: (e, _) =>
                              Center(child: Text('Error: $e')),
                          data: (list) {
                            if (list.isEmpty) {
                              return const Center(
                                  child: Text('No license keys yet.'));
                            }
                            final recent = list.take(8).toList();
                            return ListView.separated(
                              itemCount: recent.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (_, i) {
                                final k = recent[i];
                                return _KeyRow(key0: k);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final String sub;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SurfaceCard(
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: tt.labelSmall
                        ?.copyWith(color: AppColors.onSurfaceVariant)),
                Text(value,
                    style: tt.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
                if (sub.isNotEmpty)
                  Text(sub,
                      style: tt.labelSmall
                          ?.copyWith(color: AppColors.secondary)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              size: 18, color: AppColors.onSurfaceVariant),
        ]),
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({
    required this.icon,
    required this.label,
    required this.onMore,
  });

  final IconData icon;
  final String label;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(children: [
      Icon(icon, size: 16, color: AppColors.primary),
      const SizedBox(width: 8),
      Text(label,
          style:
              tt.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
      const Spacer(),
      TextButton(
        onPressed: onMore,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: tt.labelSmall,
          minimumSize: Size.zero,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        child: const Text('View all →'),
      ),
    ]);
  }
}

class _DeviceRow extends StatelessWidget {
  const _DeviceRow({required this.device});
  final Map<String, dynamic> device;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final inverterOk = device['inverterReachable'] as bool? ?? false;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        const PulseIndicator(color: AppColors.secondary, size: 8),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(device['userEmail'] ?? '—', style: tt.bodySmall),
            Text(
              inverterOk ? 'Inverter reachable' : 'Inverter unreachable',
              style: tt.labelSmall?.copyWith(
                color: inverterOk
                    ? AppColors.secondary
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _KeyRow extends StatelessWidget {
  const _KeyRow({required this.key0});
  final Map<String, dynamic> key0;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final isActive = key0['isActive'] as bool? ?? false;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              key0['licenseKey'] as String,
              style: tt.bodySmall?.copyWith(fontFamily: 'monospace'),
            ),
            Text(
              '${key0['userEmail'] ?? 'unassigned'} · ${key0['tier']}',
              style: tt.labelSmall
                  ?.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: (isActive ? AppColors.secondary : AppColors.onSurfaceVariant)
                .withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            isActive ? 'Active' : 'Inactive',
            style: tt.labelSmall?.copyWith(
              color: isActive
                  ? AppColors.secondary
                  : AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ]),
    );
  }
}
