import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../providers/app_providers.dart';

class EmsStatusCard extends ConsumerWidget {
  const EmsStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final scheduleAsync = ref.watch(currentScheduleProvider);
    final configAsync = ref.watch(appConfigProvider);
    final schedule = scheduleAsync.valueOrNull;
    final config = configAsync.valueOrNull;
    final planningOnly = config?.planningOnly ?? false;

    final minSocPct = config?.minSocPercentage != null
        ? '${((config!.minSocPercentage!) * 100).round()}%'
        : '--';

    final mode = schedule == null
        ? 'Standby'
        : switch (schedule.command.toLowerCase()) {
            'charge' => 'Charging',
            'discharge' => 'Discharging',
            'idle' => 'Standby',
            _ => 'Optimizing',
          };

    final modeColor = switch (mode) {
      'Charging' => AppColors.secondary,
      'Discharging' => AppColors.primary,
      'Optimizing' => AppColors.primary,
      _ => AppColors.onSurfaceVariant,
    };

    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(title: 'EMS Status'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: modeColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            PulseIndicator(color: modeColor, size: 6),
            const SizedBox(width: 6),
            Text(
              mode,
              style: tt.labelMedium
                  ?.copyWith(color: modeColor, fontWeight: FontWeight.w600),
            ),
          ]),
        ),
        if (planningOnly) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(children: [
              const Icon(Icons.visibility_outlined,
                  size: 13, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Planning Mode — inverter not controlled',
                  style: tt.labelSmall?.copyWith(color: AppColors.primary),
                ),
              ),
            ]),
          ),
        ],
        const SizedBox(height: 16),
        Row(children: [
          const Icon(Icons.battery_alert_rounded,
              size: 14, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 6),
          Text('Battery reserve: $minSocPct', style: tt.bodySmall),
        ]),
        if (schedule == null) ...[
          const SizedBox(height: 12),
          Text(
            'No schedule yet — EMS configuring',
            style: tt.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => context.go('/schedule'),
          child: Text(
            'View Schedule →',
            style: tt.bodySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ]),
    );
  }
}
