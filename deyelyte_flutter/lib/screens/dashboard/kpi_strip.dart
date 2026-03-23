import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../providers/app_providers.dart';

class KpiStrip extends ConsumerWidget {
  const KpiStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final telemetry = ref.watch(latestTelemetryProvider).valueOrNull;
    final soc = telemetry?.batterySOC;
    final pv = telemetry?.pvPowerW;
    final grid = telemetry?.gridPowerW;
    final dailyKwh = ref.watch(dailySolarYieldProvider).valueOrNull;
    final gridImport = ref.watch(dailyGridImportProvider).valueOrNull;
    final gridExport = ref.watch(dailyGridExportProvider).valueOrNull;

    final socPct = soc != null ? '${soc.toStringAsFixed(0)}%' : '--';
    final socSub = soc != null
        ? (telemetry!.batteryPowerW < 0 ? '⚡ Charging' : '↓ Discharging')
        : 'No data';
    final pvKw = pv != null ? '${(pv / 1000).toStringAsFixed(1)} kW' : '--';
    // Deye register 625: positive = importing from grid, negative = exporting to grid
    final gridStatus = grid == null
        ? '--'
        : (grid > 100
            ? 'Importing'
            : (grid < -100 ? 'Exporting' : 'Stable'));

    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth > 600;
      final items = [
        _KpiItem(
          title: 'Battery SoC',
          value: socPct,
          subtitle: socSub,
          subtitleColor: AppColors.secondary,
          icon: Icons.battery_charging_full_rounded,
          iconColor: AppColors.secondary,
          child: _BatterySocBar(soc: (soc ?? 0) / 100),
        ),
        _KpiItem(
          title: 'Solar Power',
          value: pvKw,
          subtitle: 'Now',
          icon: Icons.wb_sunny_rounded,
          iconColor: AppColors.tertiary,
        ),
        _KpiItem(
          title: 'Grid',
          value: gridStatus,
          subtitle: grid != null
              ? '${(grid.abs() / 1000).toStringAsFixed(1)} kW'
              : '--',
          icon: Icons.bolt_rounded,
          iconColor: AppColors.primary,
        ),
        _KpiItem(
          title: 'Solar Today',
          value: dailyKwh != null
              ? '${dailyKwh.toStringAsFixed(1)} kWh'
              : '--',
          subtitle: 'Measured',
          icon: Icons.solar_power_rounded,
          iconColor: AppColors.tertiary,
        ),
        _KpiItem(
          title: 'Grid Import',
          value: gridImport != null
              ? '${gridImport.toStringAsFixed(1)} kWh'
              : '--',
          subtitle: 'Today',
          icon: Icons.download_rounded,
          iconColor: AppColors.primary,
        ),
        _KpiItem(
          title: 'Grid Export',
          value: gridExport != null
              ? '${gridExport.toStringAsFixed(1)} kWh'
              : '--',
          subtitle: 'Today',
          icon: Icons.upload_rounded,
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
    this.subtitleColor,
    this.child,
  });

  final String title;
  final String value;
  final String? subtitle;
  final Color? subtitleColor;
  final IconData icon;
  final Color iconColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Text(title, style: tt.bodySmall),
            ],
          ),
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
              style: tt.bodySmall?.copyWith(
                  color: subtitleColor ?? AppColors.onSurfaceVariant),
            ),
          ],
          if (child != null) ...[
            const SizedBox(height: 10),
            child!,
          ],
        ],
      ),
    );
  }
}

class _BatterySocBar extends StatelessWidget {
  const _BatterySocBar({required this.soc});
  final double soc;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      return Stack(
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            height: 6,
            width: c.maxWidth * soc,
            decoration: BoxDecoration(
              gradient: AppGradients.profitGreen,
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.4),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
