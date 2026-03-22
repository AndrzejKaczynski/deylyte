import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../providers/app_providers.dart';

class RecentEventsCard extends ConsumerWidget {
  const RecentEventsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final rangeIdx = ref.watch(historyRangeProvider);
    final days = rangeDays(rangeIdx);
    final eventsAsync = ref.watch(historyEventsProvider(days));
    final events = eventsAsync.valueOrNull ?? [];

    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Recent Market Events', style: tt.titleMedium),
        const SizedBox(height: 16),
        if (events.isEmpty)
          Text(
            'No events yet.',
            style: tt.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
          )
        else
          ...events.take(5).map((e) {
            final value = e['valuePln'] as double? ?? 0.0;
            final positive = value >= 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _EventRow(
                icon: positive
                    ? Icons.upload_rounded
                    : Icons.battery_charging_full_rounded,
                title: e['title'] as String? ?? 'Event',
                subtitle: e['subtitle'] as String? ?? '',
                value: '${positive ? '+' : ''}${value.toStringAsFixed(2)} zł',
                time: e['time'] as String? ?? '',
                valueColor: positive ? AppColors.secondary : AppColors.error,
              ),
            );
          }),
      ]),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.time,
    required this.valueColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final String time;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadius.radiusMd,
      ),
      child: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: valueColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: valueColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
            Text(subtitle, style: tt.bodySmall),
            Text(time, style: tt.labelSmall),
          ]),
        ),
        Text(value,
            style: tt.bodyMedium?.copyWith(color: valueColor, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}
