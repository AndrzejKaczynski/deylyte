import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../providers/app_providers.dart';
import 'dashboard_header.dart';
import 'kpi_strip.dart';
import 'power_flow_card.dart';
import 'consumption_chart_card.dart';
import 'energy_sources_card.dart';
import 'ems_status_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      ref.invalidate(latestTelemetryProvider);
      ref.invalidate(addonStatusProvider);
      ref.invalidate(currentScheduleProvider);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final addonAsync = ref.watch(addonStatusProvider);
    final addonStatus = addonAsync.valueOrNull;
    final connected = addonStatus?['connected'] == true;
    final lastSeen = addonStatus?['lastSeenAt'] as String?;
    final showOfflineBanner = !connected && lastSeen != null;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(latestTelemetryProvider);
            ref.invalidate(addonStatusProvider);
            ref.invalidate(currentScheduleProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding:
                EdgeInsets.all(isDesktop ? AppSpacing.sp6 : AppSpacing.sp4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DashboardHeader(),
                if (showOfflineBanner) ...[
                  const SizedBox(height: AppSpacing.sp3),
                  const OfflineBanner(),
                ],
                const SizedBox(height: AppSpacing.sp4),
                const KpiStrip(),
                const SizedBox(height: AppSpacing.sp6),
                const AsymmetricGrid(
                  primaryFlex: 7,
                  sidebarFlex: 3,
                  gap: AppSpacing.sp4,
                  primary: Column(
                    children: [
                      PowerFlowCard(),
                      SizedBox(height: AppSpacing.sp4),
                      ConsumptionChartCard(),
                    ],
                  ),
                  sidebar: Column(
                    children: [
                      EnergySourcesCard(),
                      SizedBox(height: AppSpacing.sp4),
                      EmsStatusCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
