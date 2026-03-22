import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/section_header.dart';
import '../../utils/date_format.dart';
import '../../components/surface_card.dart';
import '../../components/pulse_indicator.dart';
import '../../providers/admin_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(adminUsersProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sp6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(child: SectionHeader(title: 'Users')),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(adminUsersProvider),
          ),
        ]),
        const SizedBox(height: AppSpacing.sp4),
        Expanded(
          child: SurfaceCard(
            child: users.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (list) => list.isEmpty
                  ? const Center(child: Text('No users yet.'))
                  : _UsersTable(users: list),
            ),
          ),
        ),
      ]),
    );
  }
}

class _UsersTable extends ConsumerWidget {
  const _UsersTable({required this.users});
  final List<Map<String, dynamic>> users;

  static const _flex = [0.5, 2.0, 1.5, 1.2, 1.0, 1.0, 1.0];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final keys = ref.watch(adminLicenseKeysProvider).valueOrNull ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            for (final h in ['ID', 'Email', 'Joined', 'Gathering since',
                             'Price source', 'Mode', 'Device'])
              Expanded(
                flex: (_flex[['ID', 'Email', 'Joined', 'Gathering since',
                              'Price source', 'Mode', 'Device'].indexOf(h)] * 10)
                    .round(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(h,
                      style: tt.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w600)),
                ),
              ),
          ]),
        ),
        Divider(height: 1, color: AppColors.outline.withValues(alpha: 0.3)),
        // Data rows
        Expanded(
          child: ListView.separated(
            itemCount: users.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, color: AppColors.outline.withValues(alpha: 0.15)),
            itemBuilder: (_, i) {
              final u = users[i];
              final userKeys = keys
                  .where((k) => k['userId'] == u['id'])
                  .toList();
              return InkWell(
                onTap: () => _showLicenseDialog(context, u, userKeys, tt),
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(children: [
                    _cell(Text('#${u['id']}', style: tt.bodySmall), _flex[0]),
                    _cell(Text(u['email'] ?? '—', style: tt.bodySmall), _flex[1]),
                    _cell(Text(fmtDateTime(u['created']), style: tt.bodySmall), _flex[2]),
                    _cell(Text(fmtDateTime(u['dataGatheringSince']), style: tt.bodySmall), _flex[3]),
                    _cell(Text(u['priceSource'] ?? '—', style: tt.bodySmall), _flex[4]),
                    _cell(_ModeChip(planningOnly: u['planningOnly'] as bool?), _flex[5]),
                    _cell(_DeviceStatus(
                      connected: u['deviceConnected'] as bool? ?? false,
                      lastSeen: u['deviceLastSeen'] as String?,
                      inverterOk: u['inverterReachable'] as bool? ?? false,
                    ), _flex[6]),
                  ]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showLicenseDialog(BuildContext context, Map<String, dynamic> user,
      List<Map<String, dynamic>> userKeys, TextTheme tt) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(user['email'] ?? 'User #${user['id']}'),
        content: SizedBox(
          width: 480,
          child: userKeys.isEmpty
              ? const Text('No license keys assigned to this user.')
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('License keys:', style: tt.labelMedium),
                    const SizedBox(height: 12),
                    for (final k in userKeys) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: (k['isActive'] as bool? ?? false)
                                ? AppColors.secondary.withValues(alpha: 0.3)
                                : AppColors.outline.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText(
                              k['licenseKey'] as String,
                              style: tt.bodyMedium?.copyWith(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w700,
                                color: (k['isActive'] as bool? ?? false)
                                    ? AppColors.secondary
                                    : AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${k['tier']} · '
                              '${(k['isActive'] as bool? ?? false) ? 'Active' : 'Inactive'} · '
                              'Created ${fmtDateTime(k['createdAt'])}',
                              style: tt.labelSmall?.copyWith(
                                  color: AppColors.onSurfaceVariant),
                            ),
                            if (k['lastSeenAt'] != null)
                              Text(
                                'Last seen ${fmtDateTime(k['lastSeenAt'])}',
                                style: tt.labelSmall?.copyWith(
                                    color: AppColors.onSurfaceVariant),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _cell(Widget child, double flex) => Expanded(
        flex: (flex * 10).round(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: child,
        ),
      );

}

class _ModeChip extends StatelessWidget {
  const _ModeChip({required this.planningOnly});
  final bool? planningOnly;

  @override
  Widget build(BuildContext context) {
    if (planningOnly == null) {
      return Text('—', style: Theme.of(context).textTheme.bodySmall);
    }
    final label = planningOnly! ? 'Planning' : 'Live';
    final color =
        planningOnly! ? AppColors.tertiary : AppColors.secondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _DeviceStatus extends StatelessWidget {
  const _DeviceStatus({
    required this.connected,
    required this.lastSeen,
    required this.inverterOk,
  });
  final bool connected;
  final String? lastSeen;
  final bool inverterOk;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    if (lastSeen == null) {
      return Text('Never connected',
          style: tt.bodySmall?.copyWith(color: AppColors.onSurfaceVariant));
    }
    return Row(children: [
      PulseIndicator(
        color: connected ? AppColors.secondary : AppColors.tertiary,
        size: 8,
      ),
      const SizedBox(width: 6),
      Expanded(
        child: Text(
          connected
              ? (inverterOk ? 'Online' : 'Online · no inverter')
              : 'Offline',
          style: tt.bodySmall,
        ),
      ),
    ]);
  }
}
