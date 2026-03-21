import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/section_header.dart';
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
          const SectionHeader(title: 'Users'),
          const Spacer(),
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

class _UsersTable extends StatelessWidget {
  const _UsersTable({required this.users});
  final List<Map<String, dynamic>> users;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(0.5),  // ID
          1: FlexColumnWidth(2),    // email
          2: FlexColumnWidth(1.5),  // joined
          3: FlexColumnWidth(1.2),  // baseline
          4: FlexColumnWidth(1),    // price source
          5: FlexColumnWidth(1),    // mode
          6: FlexColumnWidth(1),    // device
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: AppColors.outline.withValues(alpha: 0.3))),
            ),
            children: [
              _header('ID', tt),
              _header('Email', tt),
              _header('Joined', tt),
              _header('Gathering since', tt),
              _header('Price source', tt),
              _header('Mode', tt),
              _header('Device', tt),
            ],
          ),
          for (final u in users)
            TableRow(children: [
              _cell(Text('#${u['id']}', style: tt.bodySmall)),
              _cell(Text(u['email'] ?? '—', style: tt.bodySmall)),
              _cell(Text(_fmt(u['created']), style: tt.bodySmall)),
              _cell(Text(_fmt(u['dataGatheringSince']), style: tt.bodySmall)),
              _cell(Text(u['priceSource'] ?? '—', style: tt.bodySmall)),
              _cell(_ModeChip(planningOnly: u['planningOnly'] as bool?)),
              _cell(_DeviceStatus(
                connected: u['deviceConnected'] as bool? ?? false,
                lastSeen: u['deviceLastSeen'] as String?,
                inverterOk: u['inverterReachable'] as bool? ?? false,
              )),
            ]),
        ],
      ),
    );
  }

  Widget _header(String label, TextTheme tt) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Text(label,
            style: tt.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w600)),
      );

  Widget _cell(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: child,
      );

  String _fmt(dynamic iso) {
    if (iso == null) return '—';
    final dt = DateTime.tryParse(iso as String);
    if (dt == null) return '—';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')}';
  }
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
