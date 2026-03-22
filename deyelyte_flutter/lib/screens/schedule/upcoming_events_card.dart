import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';

class UpcomingEventsCard extends StatelessWidget {
  const UpcomingEventsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Upcoming Events', style: tt.titleMedium),
        const SizedBox(height: 16),
        const _UpcomingRow(time: '12:00', event: 'Feed-in spike', color: AppColors.secondary),
        const SizedBox(height: 12),
        const _UpcomingRow(time: '17:00', event: 'Peak shaving start', color: AppColors.error),
        const SizedBox(height: 12),
        const _UpcomingRow(time: '22:00', event: 'Tesla Wallbox charge', color: AppColors.primary),
        const SizedBox(height: 12),
        const _UpcomingRow(time: '02:00', event: 'Next off-peak window', color: AppColors.secondary),
      ]),
    );
  }
}

class _UpcomingRow extends StatelessWidget {
  const _UpcomingRow({
    required this.time,
    required this.event,
    required this.color,
  });
  final String time;
  final String event;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(children: [
      Container(
        width: 44,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(time,
            textAlign: TextAlign.center,
            style: tt.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w700)),
      ),
      const SizedBox(width: 10),
      Expanded(child: Text(event, style: tt.bodySmall)),
    ]);
  }
}
