import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../components/section_header.dart';
import '../../components/surface_card.dart';
import '../../providers/admin_provider.dart';
import '../../theme/app_spacing.dart';
import 'admin_dashboard_widgets.dart';

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
          const Expanded(child: SectionHeader(title: 'Overview')),
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
            child: AdminKpiCard(
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
            child: AdminKpiCard(
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
            child: AdminKpiCard(
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
                      AdminCardTitle(
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
                                return AdminDeviceRow(device: d);
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
                      AdminCardTitle(
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
                                return AdminKeyRow(key0: k);
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
