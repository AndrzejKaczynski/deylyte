import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/components.dart';
import '../../providers/app_providers.dart';

class ForecastBarCard extends ConsumerWidget {
  const ForecastBarCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastAsync = ref.watch(pvForecastProvider);
    final pricesAsync = ref.watch(todayPricesProvider);
    final framesAsync = ref.watch(todayScheduleProvider);
    final telemetryAsync = ref.watch(telemetryHistory24hProvider);

    final now = DateTime.now().toLocal();

    return DailyEnergyChart(
      title: "Today's Plan",
      subtitle: 'Scheduler input & plan overview',
      hours: HourData.buildHours(
        forecastAsync.valueOrNull ?? [],
        pricesAsync.valueOrNull ?? [],
        framesAsync.valueOrNull ?? [],
        telemetryAsync.valueOrNull ?? [],
      ),
      nowHour: now.hour,
      nowMinute: now.minute,
      isLoading: forecastAsync.isLoading || pricesAsync.isLoading || framesAsync.isLoading,
      hasError: forecastAsync.hasError || pricesAsync.hasError || framesAsync.hasError,
    );
  }
}
