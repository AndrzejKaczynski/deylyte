import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../providers/app_providers.dart';

/// Calendar-aware navigator for history views.
/// Daily: "Mar 23, 2026", Weekly: "Mar 16 – 22, 2026", Monthly: "March 2026".
class HistoryWindowNavigator extends ConsumerWidget {
  const HistoryWindowNavigator({super.key});

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static const _fullMonths = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final period = ref.watch(historyPeriodProvider);
    final anchor = ref.watch(historyAnchorDateProvider);
    final earliest = ref.watch(earliestAllowedDateProvider).valueOrNull;

    final range = historyDateRange(period, anchor);
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    // Back: disabled if range.from would go before earliest allowed date.
    final prevAnchor = navigateHistory(period, anchor, -1);
    final prevRange = historyDateRange(period, prevAnchor);
    final canGoBack = earliest == null || !prevRange.from.isBefore(earliest);

    // Forward: disabled if range already contains yesterday or later.
    final canGoForward = range.to.isBefore(yesterday);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NavButton(
          icon: Icons.chevron_left_rounded,
          enabled: canGoBack,
          onTap: () =>
              ref.read(historyAnchorDateProvider.notifier).state = prevAnchor,
        ),
        const SizedBox(width: 8),
        Text(
          _label(period, range.from, range.to),
          style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        _NavButton(
          icon: Icons.chevron_right_rounded,
          enabled: canGoForward,
          onTap: () {
            final next = navigateHistory(period, anchor, 1);
            // Clamp so we never go past yesterday.
            final nextRange = historyDateRange(period, next);
            if (nextRange.to.isAfter(yesterday)) {
              // Stay in the period containing yesterday.
              ref.read(historyAnchorDateProvider.notifier).state = yesterday;
            } else {
              ref.read(historyAnchorDateProvider.notifier).state = next;
            }
          },
        ),
      ],
    );
  }

  String _label(HistoryPeriod period, DateTime from, DateTime to) {
    switch (period) {
      case HistoryPeriod.daily:
        return '${_months[to.month - 1]} ${to.day}, ${to.year}';
      case HistoryPeriod.weekly:
        if (from.year == to.year) {
          if (from.month == to.month) {
            return '${_months[from.month - 1]} ${from.day} – ${to.day}, ${to.year}';
          }
          return '${_months[from.month - 1]} ${from.day} – ${_months[to.month - 1]} ${to.day}, ${to.year}';
        }
        return '${_months[from.month - 1]} ${from.day}, ${from.year} – ${_months[to.month - 1]} ${to.day}, ${to.year}';
      case HistoryPeriod.monthly:
        return '${_fullMonths[from.month - 1]} ${from.year}';
    }
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.surfaceContainerHigh
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: enabled
                ? AppColors.outlineVariant.withValues(alpha: 0.4)
                : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? AppColors.onSurface : AppColors.outline,
        ),
      ),
    );
  }
}
