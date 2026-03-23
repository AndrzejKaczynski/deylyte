import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../providers/app_providers.dart';

/// Estimate KPI tiles shown at the top of the Schedule screen.
/// Mirrors the _KpiItem layout from the dashboard KpiStrip but surfaces
/// forward-looking values (forecasts + plan-based estimates) instead of
/// real-time / measured data.
class ScheduleKpiStrip extends ConsumerWidget {
  const ScheduleKpiStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyKwh = ref.watch(dailySolarYieldProvider).valueOrNull;

    final forecastRows = ref.watch(pvForecastProvider).valueOrNull ?? [];
    final now = DateTime.now().toLocal();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final tomorrowMidnight = todayMidnight.add(const Duration(days: 1));

    // Remaining PV forecast for today (future 30-min periods only)
    final forecastRemaining = forecastRows.fold(0.0, (sum, r) {
      final t = r.timestamp.toLocal();
      if (t.isBefore(todayMidnight) || !t.isBefore(tomorrowMidnight)) {
        return sum;
      }
      return sum + r.expectedYieldWatts * 0.5 / 1000;
    });

    final solarTotal = (dailyKwh ?? 0) + forecastRemaining;
    final hasSolarData = dailyKwh != null || forecastRows.isNotEmpty;

    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth > 600;
      final items = [
        _KpiItem(
          title: 'Solar Total',
          value: hasSolarData
              ? '${solarTotal.toStringAsFixed(1)} kWh'
              : '--',
          subtitle: 'Actual + forecast',
          icon: Icons.sunny_snowing,
          iconColor: AppColors.tertiary,
        ),
        _KpiItem(
          title: 'PV Forecast',
          value: forecastRows.isEmpty
              ? '--'
              : '${forecastRemaining.toStringAsFixed(1)} kWh',
          subtitle: 'Remaining today',
          icon: Icons.wb_cloudy_outlined,
          iconColor: AppColors.tertiary,
        ),
        const _KpiItem(
          title: "Today's Estimate",
          value: '--',
          subtitle: 'Based on schedule',
          icon: Icons.trending_up_rounded,
          iconColor: AppColors.secondary,
        ),
      ];

      if (wide) {
        return Row(
          children: items
              .map((i) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: i,
                    ),
                  ))
              .toList(),
        );
      }
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
        children: items,
      );
    });
  }
}

class _KpiItem extends StatelessWidget {
  const _KpiItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.subtitle,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 6),
            Text(title, style: tt.bodySmall),
          ]),
          const SizedBox(height: 10),
          Text(
            value,
            style: tt.headlineSmall?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.02,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: tt.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}
