import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../providers/app_providers.dart';
import 'history_header.dart';
import 'history_kpi_row.dart';
import 'history_charts.dart';
import 'net_profit_card.dart';
import 'recent_events_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  static const _ranges = ['7 days', '30 days', '60 days', '90 days'];
  static const _rangeDays = [7, 30, 60, 90];

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
                  if (_rangeDays[i] > maxDays) return;
                  ref.read(historyRangeProvider.notifier).state = i;
                },
              ),
              const SizedBox(height: AppSpacing.sp4),
              const HistoryKpiRow(),
              const SizedBox(height: AppSpacing.sp6),
              const AsymmetricGrid(
                primaryFlex: 7,
                sidebarFlex: 3,
                gap: AppSpacing.sp4,
                primary: Column(children: [
                  MarketArbitrageChart(),
                  SizedBox(height: AppSpacing.sp4),
                  YieldVsExpenditureChart(),
                ]),
                sidebar: Column(children: [
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
