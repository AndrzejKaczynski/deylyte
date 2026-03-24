import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../providers/app_providers.dart';

// ─── History window navigator ─────────────────────────────────────────────────
//
// Shared by both 1-day mode (prev/next one day at a time) and multi-day mode
// (prev/next one full window at a time).
//
// [windowDays]  — number of days in the window (1 = single-day 24h view).
// [minDate]     — oldest date the user can navigate to.
// [maxDate]     — newest date allowed (typically yesterday).

class HistoryWindowNavigator extends ConsumerWidget {
  const HistoryWindowNavigator({
    super.key,
    required this.windowDays,
    required this.minDate,
    required this.maxDate,
  });

  final int windowDays;
  final DateTime minDate;
  final DateTime maxDate;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final windowEnd = ref.watch(historyWindowEndProvider);
    final windowStart = _windowStart(windowEnd);

    final canGoBack = windowStart.isAfter(minDate);
    final canGoForward = windowEnd.isBefore(maxDate);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NavButton(
          icon: Icons.chevron_left_rounded,
          enabled: canGoBack,
          onTap: () {
            final newEnd = windowEnd.subtract(Duration(days: windowDays));
            final clamped = newEnd.isBefore(minDate.add(Duration(days: windowDays - 1)))
                ? minDate.add(Duration(days: windowDays - 1))
                : newEnd;
            ref.read(historyWindowEndProvider.notifier).state = clamped;
          },
        ),
        const SizedBox(width: 8),
        Text(
          _label(windowStart, windowEnd),
          style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        _NavButton(
          icon: Icons.chevron_right_rounded,
          enabled: canGoForward,
          onTap: () {
            final newEnd = windowEnd.add(Duration(days: windowDays));
            final clamped = newEnd.isAfter(maxDate) ? maxDate : newEnd;
            ref.read(historyWindowEndProvider.notifier).state = clamped;
          },
        ),
      ],
    );
  }

  DateTime _windowStart(DateTime windowEnd) =>
      windowDays == 1 ? windowEnd : windowEnd.subtract(Duration(days: windowDays - 1));

  String _label(DateTime start, DateTime end) {
    if (windowDays == 1) {
      return '${_months[end.month - 1]} ${end.day}, ${end.year}';
    }
    if (start.year == end.year) {
      if (start.month == end.month) {
        return '${_months[start.month - 1]} ${start.day} – ${end.day}, ${end.year}';
      }
      return '${_months[start.month - 1]} ${start.day} – ${_months[end.month - 1]} ${end.day}, ${end.year}';
    }
    return '${_months[start.month - 1]} ${start.day}, ${start.year} – ${_months[end.month - 1]} ${end.day}, ${end.year}';
  }
}

// ─── Nav button ───────────────────────────────────────────────────────────────

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
