import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../providers/app_providers.dart';

class HistoryHeader extends StatelessWidget {
  const HistoryHeader({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  final HistoryPeriod selectedPeriod;
  final ValueChanged<HistoryPeriod> onPeriodChanged;

  static const _labels = {
    HistoryPeriod.daily: 'Daily',
    HistoryPeriod.weekly: 'Weekly',
    HistoryPeriod.monthly: 'Monthly',
  };

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('DeyLyte History', style: tt.headlineMedium),
            const SizedBox(height: 4),
            Text('Energy performance over time', style: tt.bodySmall),
          ]),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: AppRadius.radiusMd,
          ),
          padding: const EdgeInsets.all(3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: HistoryPeriod.values.map((period) {
              final active = selectedPeriod == period;
              return GestureDetector(
                onTap: () => onPeriodChanged(period),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: active ? AppColors.surfaceContainerHighest : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    _labels[period]!,
                    style: tt.labelMedium?.copyWith(
                      color: active ? AppColors.primary : AppColors.outline,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
