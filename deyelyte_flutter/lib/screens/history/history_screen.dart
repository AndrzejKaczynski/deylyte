import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../providers/app_providers.dart';
import 'history_header.dart';
import 'history_kpi_row.dart';
import 'history_day_navigator.dart';
import 'net_profit_card.dart';
import 'recent_events_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  static const _ranges = ['1 day', '7 days', '30 days', '60 days', '90 days'];
  static const _rangeDays = [1, 7, 30, 60, 90];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRange = ref.watch(historyRangeProvider);
    final maxDays = ref.watch(userHistoryDurationDaysProvider).valueOrNull ?? 7;
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? AppSpacing.sp6 : AppSpacing.sp4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HistoryHeader(
                selectedRange: selectedRange,
                ranges: _ranges,
                rangeDays: _rangeDays,
                maxDays: maxDays,
                onRangeChanged: (i) {
                  if (_rangeDays[i] > maxDays && i != 0) return;
                  ref.read(historyRangeProvider.notifier).state = i;
                  // Reset window to yesterday when switching periods.
                  final now = DateTime.now().toLocal();
                  ref.read(historyWindowEndProvider.notifier).state =
                      DateTime(now.year, now.month, now.day - 1);
                },
              ),
              const SizedBox(height: AppSpacing.sp4),
              const HistoryKpiRow(),
              const SizedBox(height: AppSpacing.sp6),
              AsymmetricGrid(
                primaryFlex: 7,
                sidebarFlex: 3,
                gap: AppSpacing.sp4,
                primary: _HistoryChartSection(
                  rangeIndex: selectedRange,
                  maxDays: maxDays,
                ),
                sidebar: const Column(children: [
                  NetProfitCard(),
                  SizedBox(height: AppSpacing.sp4),
                  RecentEventsCard(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Chart section ────────────────────────────────────────────────────────────

class _HistoryChartSection extends ConsumerWidget {
  const _HistoryChartSection({
    required this.rangeIndex,
    required this.maxDays,
  });

  final int rangeIndex;
  final int maxDays;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider).valueOrNull;
    final gatheringSince = config?.dataGatheringSince?.toLocal();
    final now = DateTime.now().toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    // No history yet (first day or never received data).
    final hasHistory = gatheringSince != null &&
        DateTime(gatheringSince.year, gatheringSince.month, gatheringSince.day)
            .isBefore(today);
    if (!hasHistory) {
      return const _NoHistoryCard();
    }

    final periodDays = rangeDays(rangeIndex);
    final winSize = windowSize(rangeIndex);
    final windowEnd = ref.watch(historyWindowEndProvider);
    // Clamp window end so it never exceeds yesterday or the oldest allowed date.
    final oldestAllowed = today.subtract(Duration(days: maxDays));
    final effectiveEnd = windowEnd.isAfter(yesterday)
        ? yesterday
        : windowEnd.isBefore(oldestAllowed.add(Duration(days: winSize - 1)))
            ? oldestAllowed.add(Duration(days: winSize - 1))
            : windowEnd;
    final windowStart = rangeIndex == 0
        ? effectiveEnd
        : effectiveEnd.subtract(Duration(days: winSize - 1));

    // Oldest browsable date = max(dataGatheringSince, today - maxDays)
    final gatheringDate =
        DateTime(gatheringSince.year, gatheringSince.month, gatheringSince.day);
    final minDate = gatheringDate.isAfter(oldestAllowed) ? gatheringDate : oldestAllowed;

    // Cap all fetches to the user's tier limit — no point requesting 90 days
    // if the license only allows 30. For 1-day mode, fetch prices/frames for
    // the full browsable window so navigating any past date has data.
    final cappedDays = periodDays.clamp(1, maxDays);
    final priceDays = rangeIndex == 0 ? maxDays : cappedDays;
    final pricesAsync = ref.watch(historyPeriodPricesProvider(priceDays));
    final framesAsync = ref.watch(historyPeriodFramesProvider(priceDays));

    // 1-day view: raw per-date telemetry (~96 rows).
    // Multi-day view: server-side daily aggregates (~N rows, no heavy fetch).
    final dayTelemetryAsync = rangeIndex == 0
        ? ref.watch(historyDayTelemetryProvider(effectiveEnd))
        : null;
    final aggregatesAsync = rangeIndex != 0
        ? ref.watch(historyDailyAggregatesProvider(cappedDays))
        : null;

    final isLoading = pricesAsync.isLoading ||
        framesAsync.isLoading ||
        (dayTelemetryAsync?.isLoading ?? false) ||
        (aggregatesAsync?.isLoading ?? false);
    final hasError = pricesAsync.hasError ||
        framesAsync.hasError ||
        (dayTelemetryAsync?.hasError ?? false) ||
        (aggregatesAsync?.hasError ?? false);

    final prices = pricesAsync.valueOrNull ?? [];
    final frames = framesAsync.valueOrNull ?? [];

    // Build chart data for the current window.
    final List<HourData> hours;
    final List<String>? axisLabels;
    final List<String>? hoverLabels;
    final int columnCount;

    if (rangeIndex == 0) {
      // Single-day 24h view — raw telemetry for this specific date.
      final telemetry = dayTelemetryAsync?.valueOrNull ?? [];
      hours = HourData.buildForDate(effectiveEnd, prices, frames, telemetry);
      axisLabels = null;
      hoverLabels = null; // default "HH:00 STATS"
      columnCount = 24;
    } else {
      // Multi-day aggregated view (up to 30 columns).
      final aggregates = aggregatesAsync?.valueOrNull ?? [];
      hours = HourData.buildFromAggregates(windowStart, effectiveEnd, aggregates, prices, frames);
      axisLabels = HourData.buildPeriodAxisLabels(windowStart, effectiveEnd);
      hoverLabels = HourData.buildDayHoverLabels(windowStart, effectiveEnd);
      columnCount = winSize;
    }

    return Column(
      children: [
        HistoryWindowNavigator(
          windowDays: winSize,
          minDate: minDate,
          maxDate: yesterday,
        ),
        const SizedBox(height: AppSpacing.sp3),
        DailyEnergyChart(
          title: rangeIndex == 0 ? 'Day View' : 'Period View',
          subtitle: rangeIndex == 0
              ? 'Actual energy data for this day'
              : 'Daily averages across the selected period',
          hours: hours,
          isLoading: isLoading,
          hasError: hasError,
          showEstimateLayer: false,
          showPlanLayer: rangeIndex == 0,
          commandStripLabel: 'EXECUTED PLAN',
          columnCount: columnCount,
          axisLabels: axisLabels,
          hoverLabels: hoverLabels,
          // No nowHour/nowMinute — history mode.
        ),
      ],
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _NoHistoryCard extends StatelessWidget {
  const _NoHistoryCard();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: SizedBox(
        height: 320,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history_rounded,
                size: 48,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 16),
              Text('No history yet', style: tt.titleMedium),
              const SizedBox(height: 8),
              Text(
                'Data will appear here once your add-on\nhas been running for at least one full day.',
                style: tt.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
