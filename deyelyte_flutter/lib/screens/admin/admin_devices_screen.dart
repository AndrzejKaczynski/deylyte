import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/section_header.dart';
import '../../utils/date_format.dart';
import '../../components/surface_card.dart';
import '../../components/pulse_indicator.dart';
import '../../providers/admin_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class AdminDevicesScreen extends ConsumerWidget {
  const AdminDevicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(adminDevicesProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sp6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(child: SectionHeader(title: 'Devices')),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(adminDevicesProvider),
          ),
        ]),
        const SizedBox(height: AppSpacing.sp4),
        Expanded(
          child: SurfaceCard(
            child: devices.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (list) => list.isEmpty
                  ? const Center(child: Text('No devices registered yet.'))
                  : _DevicesTable(devices: list),
            ),
          ),
        ),
      ]),
    );
  }
}

class _DevicesTable extends StatelessWidget {
  const _DevicesTable({required this.devices});
  final List<Map<String, dynamic>> devices;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(0.5),  // ID
          1: FlexColumnWidth(2),    // user
          2: FlexColumnWidth(1.5),  // last seen
          3: FlexColumnWidth(1),    // status
          4: FlexColumnWidth(1),    // inverter
          5: FlexColumnWidth(1.5),  // registered
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
              _header('User', tt),
              _header('Last seen', tt),
              _header('Add-on', tt),
              _header('Inverter', tt),
              _header('Registered', tt),
            ],
          ),
          for (final d in devices)
            TableRow(children: [
              _cell(Text('#${d['id']}', style: tt.bodySmall)),
              _cell(Text(
                '${d['userEmail'] ?? '—'}\n#${d['userId']}',
                style: tt.bodySmall,
              )),
              _cell(Text(fmtDateTime(d['lastSeenAt']), style: tt.bodySmall)),
              _cell(_StatusDot(
                ok: d['connected'] as bool? ?? false,
                label: (d['connected'] as bool? ?? false) ? 'Online' : 'Offline',
              )),
              _cell(_StatusDot(
                ok: d['inverterReachable'] as bool? ?? false,
                label: (d['inverterReachable'] as bool? ?? false)
                    ? 'Reachable'
                    : 'Unreachable',
              )),
              _cell(Text(fmtDateTime(d['createdAt']), style: tt.bodySmall)),
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

}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.ok, required this.label});
  final bool ok;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = ok ? AppColors.secondary : AppColors.onSurfaceVariant;
    return Row(children: [
      PulseIndicator(color: color, size: 8),
      const SizedBox(width: 6),
      Text(label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: color)),
    ]);
  }
}
