import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';

class ThresholdsCard extends StatelessWidget {
  const ThresholdsCard({
    super.key,
    required this.minSoc,
    required this.onMinSocChanged,
  });

  final double minSoc;
  final ValueChanged<double> onMinSocChanged;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(title: 'Battery Reserve'),
        const SizedBox(height: 20),
        _SliderSetting(
          icon: Icons.battery_alert_rounded,
          iconColor: AppColors.error,
          label: 'Minimum SoC',
          detail:
              'The EMS will never discharge the battery below this level. Protects battery longevity.',
          value: minSoc,
          valueLabel: '${(minSoc * 100).round()}%',
          onChanged: onMinSocChanged,
          activeColor: AppColors.error,
        ),
      ]),
    );
  }
}

class _SliderSetting extends StatelessWidget {
  const _SliderSetting({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.detail,
    required this.value,
    required this.valueLabel,
    required this.onChanged,
    required this.activeColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String detail;
  final double value;
  final String valueLabel;
  final ValueChanged<double> onChanged;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label,
              style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: activeColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(valueLabel,
              style: tt.labelMedium?.copyWith(
                  color: activeColor, fontWeight: FontWeight.w700)),
        ),
      ]),
      const SizedBox(height: 4),
      Text(detail, style: tt.bodySmall),
      const SizedBox(height: 8),
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: activeColor,
          inactiveTrackColor: AppColors.surfaceContainerHigh,
          thumbColor: activeColor,
          overlayColor: activeColor.withValues(alpha: 0.12),
          trackHeight: 4,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
        ),
        child: Slider(
          value: value,
          min: 0.05,
          max: 0.80,
          divisions: 15,
          onChanged: onChanged,
        ),
      ),
    ]);
  }
}
