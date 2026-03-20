import 'package:flutter/material.dart';
import '../theme/theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Hero Metric
//
// [Display typography] For "art installation" KPI numbers — tight spacing,
// primary colour, optional unit suffix in labelMedium.
// ─────────────────────────────────────────────────────────────────────────────

enum HeroMetricSize { large, medium, small }

class HeroMetric extends StatelessWidget {
  const HeroMetric({
    super.key,
    required this.value,
    this.unit,
    this.label,
    this.valueColor,
    this.size = HeroMetricSize.medium,
  });

  final String value;
  final String? unit;
  final String? label;
  final Color? valueColor;
  final HeroMetricSize size;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final baseStyle = switch (size) {
      HeroMetricSize.large  => tt.displayLarge,
      HeroMetricSize.medium => tt.displayMedium,
      HeroMetricSize.small  => tt.displaySmall,
    };
    final valueStyle = (baseStyle ?? const TextStyle()).copyWith(
      color: valueColor ?? AppColors.primary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: valueStyle),
            if (unit != null) ...[
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  unit!,
                  style: tt.labelMedium?.copyWith(
                    color: AppColors.outline,
                    letterSpacing: 0.05,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (label != null) ...[
          const SizedBox(height: 4),
          Text(
            label!.toUpperCase(),
            style: tt.labelSmall?.copyWith(
              color: AppColors.outline,
              letterSpacing: 0.08,
            ),
          ),
        ],
      ],
    );
  }
}
