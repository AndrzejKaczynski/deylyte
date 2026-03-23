import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../providers/settings_provider.dart';
import 'schedule_header.dart';
import 'schedule_kpi_strip.dart';
import 'forecast_bar_card.dart';
import 'strategy_summary_card.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final planningOnly = ref.watch(settingsProvider.select((s) => s.planningOnly));

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? AppSpacing.sp6 : AppSpacing.sp4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ScheduleHeader(),
              if (planningOnly) ...[
                const SizedBox(height: AppSpacing.sp3),
                const PlanningModeBanner(),
              ],
              const SizedBox(height: AppSpacing.sp4),
              const ScheduleKpiStrip(),
              const SizedBox(height: AppSpacing.sp4),
              const AsymmetricGrid(
                primaryFlex: 7,
                sidebarFlex: 3,
                gap: AppSpacing.sp4,
                primary: ForecastBarCard(),
                sidebar: StrategySummaryCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
