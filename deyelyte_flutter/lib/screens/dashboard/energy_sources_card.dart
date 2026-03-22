import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';

class EnergySourcesCard extends StatelessWidget {
  const EnergySourcesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Energy Sources', style: tt.titleMedium),
          const SizedBox(height: 16),
          const _SourceRow(
            icon: Icons.wb_sunny_rounded,
            label: 'Solar Panels',
            value: '3.2 kW',
            color: AppColors.tertiary,
            fraction: 0.68,
          ),
          const SizedBox(height: 12),
          const _SourceRow(
            icon: Icons.battery_charging_full_rounded,
            label: 'Battery Storage',
            value: '8.4 kWh @ 84%',
            color: AppColors.secondary,
            fraction: 0.84,
          ),
          const SizedBox(height: 12),
          const _SourceRow(
            icon: Icons.electric_meter_rounded,
            label: 'Public Grid',
            value: 'Idle / Exporting',
            color: AppColors.outlineVariant,
            fraction: 0.0,
          ),
        ],
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.fraction,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
              child: Text(label,
                  style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w500))),
          Text(value, style: tt.labelSmall?.copyWith(color: color)),
        ]),
        const SizedBox(height: 6),
        LayoutBuilder(builder: (_, c) {
          return Stack(children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              height: 4,
              width: c.maxWidth * fraction,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
                boxShadow: fraction > 0
                    ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 4)]
                    : null,
              ),
            ),
          ]);
        }),
      ],
    );
  }
}
