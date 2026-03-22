import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class HistoryHeader extends StatelessWidget {
  const HistoryHeader({
    super.key,
    required this.selectedRange,
    required this.ranges,
    required this.rangeDays,
    required this.maxDays,
    required this.onRangeChanged,
  });

  final int selectedRange;
  final List<String> ranges;
  final List<int> rangeDays;
  final int maxDays;
  final ValueChanged<int> onRangeChanged;

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
            children: ranges.asMap().entries.map((e) {
              final active = selectedRange == e.key;
              final locked = rangeDays[e.key] > maxDays;
              return Tooltip(
                message: locked ? 'Upgrade to Pro to unlock extended history' : '',
                triggerMode: locked ? TooltipTriggerMode.tap : TooltipTriggerMode.longPress,
                child: GestureDetector(
                  onTap: () => onRangeChanged(e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: active ? AppColors.surfaceContainerHighest : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (locked) ...[
                          const Icon(Icons.lock_rounded, size: 11, color: AppColors.outline),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          e.value,
                          style: tt.labelMedium?.copyWith(
                            color: locked
                                ? AppColors.outline.withValues(alpha: 0.5)
                                : active
                                    ? AppColors.primary
                                    : AppColors.outline,
                            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
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
