import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';

class PowerAllocationCard extends StatelessWidget {
  const PowerAllocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Power Allocation Flow'),
          SizedBox(height: 16),
          _TimelineEvent(
            time: '02:00–04:00',
            title: 'Off-Peak Pre-charge',
            body: 'System charged 4.5 kWh at \$0.08 to offset evening peak costs.',
            icon: Icons.battery_charging_full_rounded,
            color: AppColors.secondary,
            badge: 'Completed',
          ),
          SizedBox(height: 12),
          _TimelineEvent(
            time: '08:00–14:00',
            title: 'Solar Harvest',
            body: 'PV forecast: 12.4 kWh yield, 3.2 kW surplus for charging.',
            icon: Icons.wb_sunny_rounded,
            color: AppColors.tertiary,
            badge: 'In Progress',
            badgeColor: AppColors.tertiary,
          ),
          SizedBox(height: 12),
          _TimelineEvent(
            time: '12:00',
            title: 'High-Yield Feed-in',
            body: 'Scheduled discharge of excess 3.2 kWh during price spike (\$0.42/kWh).',
            icon: Icons.upload_rounded,
            color: AppColors.primary,
            badge: 'Upcoming',
            badgeColor: AppColors.primary,
          ),
          SizedBox(height: 12),
          _TimelineEvent(
            time: '17:00–21:00',
            title: 'Evening Peak Shaving',
            body: 'Battery discharge scheduled to avoid grid import at peak rates.',
            icon: Icons.bolt_rounded,
            color: AppColors.error,
            badge: 'Planned',
          ),
        ],
      ),
    );
  }
}

class _TimelineEvent extends StatelessWidget {
  const _TimelineEvent({
    required this.time,
    required this.title,
    required this.body,
    required this.icon,
    required this.color,
    this.badge,
    this.badgeColor,
  });

  final String time;
  final String title;
  final String body;
  final IconData icon;
  final Color color;
  final String? badge;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadius.radiusMd,
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(title,
                    style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (badgeColor ?? AppColors.onSurfaceVariant).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge!,
                    style: tt.labelSmall?.copyWith(
                        color: badgeColor ?? AppColors.onSurfaceVariant),
                  ),
                ),
            ]),
            const SizedBox(height: 2),
            Text(time, style: tt.labelSmall?.copyWith(color: color)),
            const SizedBox(height: 6),
            Text(body, style: tt.bodySmall),
          ]),
        ),
      ]),
    );
  }
}
