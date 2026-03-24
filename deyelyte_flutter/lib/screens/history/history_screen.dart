import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../providers/app_providers.dart';
import 'history_header.dart';
import 'history_kpi_row.dart';
import 'history_day_navigator.dart';
import 'net_profit_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(historyPeriodProvider);
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
                selectedPeriod: period,
                onPeriodChanged: (p) {
                  ref.read(historyPeriodProvider.notifier).state = p;
                  // Reset anchor to yesterday when switching periods.
                  final now = DateTime.now();
                  ref.read(historyAnchorDateProvider.notifier).state =
                      DateTime(now.year, now.month, now.day - 1);
                },
              ),
              const SizedBox(height: AppSpacing.sp4),
              const HistoryKpiRow(),
              const SizedBox(height: AppSpacing.sp6),
              const AsymmetricGrid(
                primaryFlex: 7,
                sidebarFlex: 3,
                gap: AppSpacing.sp4,
                primary: _HistoryChartSection(),
                sidebar: Column(children: [
                  NetProfitCard(),
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
  const _HistoryChartSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider).valueOrNull;
    final gatheringSince = config?.dataGatheringSince?.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // No history yet (first day or never received data).
    final hasHistory = gatheringSince != null &&
        DateTime(gatheringSince.year, gatheringSince.month, gatheringSince.day)
            .isBefore(today);
    if (!hasHistory) return const _NoHistoryCard();

    final period = ref.watch(historyPeriodProvider);
    final anchor = ref.watch(historyAnchorDateProvider);
    final range = historyDateRange(period, anchor);

    if (period == HistoryPeriod.daily) {
      return _DailyView(date: range.from);
    } else {
      return _PeriodView(
        period: period,
        from: range.from,
        to: range.to,
      );
    }
  }
}

// ─── Daily (24h) view ─────────────────────────────────────────────────────────

class _DailyView extends ConsumerWidget {
  const _DailyView({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(historyDayDataProvider(date));

    final isLoading = dataAsync.isLoading;
    final hasError = dataAsync.hasError;
    final data = dataAsync.valueOrNull;

    final hours = data != null ? HourData.buildFromDayData(data) : <HourData>[];

    return Column(
      children: [
        const HistoryWindowNavigator(),
        const SizedBox(height: AppSpacing.sp3),
        DailyEnergyChart(
          title: 'Day View',
          subtitle: 'Actual energy data for this day',
          hours: hours,
          isLoading: isLoading,
          hasError: hasError,
          showEstimateLayer: false,
          showPlanLayer: true,
          commandStripLabel: 'EXECUTED PLAN',
          columnCount: 24,
        ),
      ],
    );
  }
}

// ─── Period (weekly / monthly) view ───────────────────────────────────────────

class _PeriodView extends ConsumerWidget {
  const _PeriodView({
    required this.period,
    required this.from,
    required this.to,
  });

  final HistoryPeriod period;
  final DateTime from;
  final DateTime to;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync =
        ref.watch(historyPeriodDataProvider((from: from, to: to)));

    final isLoading = dataAsync.isLoading;
    final hasError = dataAsync.hasError;
    final data = dataAsync.valueOrNull;

    final columnCount = to.difference(from).inDays + 1;
    final hours = data != null
        ? HourData.buildFromPeriodData(from, to, data)
        : <HourData>[];
    final axisLabels = HourData.buildPeriodAxisLabels(from, to);
    final hoverLabels = HourData.buildDayHoverLabels(from, to);

    final subtitle = period == HistoryPeriod.weekly
        ? 'Daily averages for this week'
        : 'Daily averages for this month';

    return Column(
      children: [
        const HistoryWindowNavigator(),
        const SizedBox(height: AppSpacing.sp3),
        DailyEnergyChart(
          title: 'Period View',
          subtitle: subtitle,
          hours: hours,
          isLoading: isLoading,
          hasError: hasError,
          showEstimateLayer: false,
          showPlanLayer: false,
          columnCount: columnCount,
          axisLabels: axisLabels,
          hoverLabels: hoverLabels,
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
