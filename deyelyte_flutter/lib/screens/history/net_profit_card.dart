import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../providers/app_providers.dart';

class NetProfitCard extends ConsumerWidget {
  const NetProfitCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final period = ref.watch(historyPeriodProvider);
    final anchor = ref.watch(historyAnchorDateProvider);
    final range = historyDateRange(period, anchor);
    final summary =
        ref.watch(historySummaryProvider((from: range.from, to: range.to))).valueOrNull ?? {};

    final totalSavings = summary['totalSavingsPln'] as double? ?? 0.0;
    final storageEff = summary['storageEfficiencyPercent'] as double? ?? 0.0;
    final peakDemand = summary['peakDemandKw'] as double? ?? 0.0;
    final netRevenue = summary['netRevenuePln'] as double? ?? 0.0;
    final netStr = '${netRevenue >= 0 ? '+' : ''}${netRevenue.toStringAsFixed(2)}';

    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Total Net Profit', style: tt.titleMedium),
        const SizedBox(height: 8),
        HeroMetric(
          value: '$netStr zł',
          valueColor: netRevenue >= 0 ? AppColors.secondary : AppColors.error,
          size: HeroMetricSize.small,
        ),
        const SizedBox(height: 20),
        _StatRow(label: 'Total Savings', value: '${totalSavings.toStringAsFixed(2)} zł',
            color: AppColors.secondary),
        const SizedBox(height: 12),
        _StatRow(label: 'Storage Efficiency', value: '${storageEff.toStringAsFixed(1)}%',
            color: AppColors.primary),
        const SizedBox(height: 12),
        // TODO: requires grid carbon intensity API integration (e.g. Electricity Maps API)
        const _StatRow(label: 'Carbon Offset', value: '—',
            color: AppColors.onSurfaceVariant),
        const SizedBox(height: 12),
        _StatRow(label: 'Peak Demand', value: '${peakDemand.toStringAsFixed(1)} kW',
            color: AppColors.tertiary),
      ]),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(children: [
      Expanded(child: Text(label, style: tt.bodySmall, overflow: TextOverflow.ellipsis)),
      const SizedBox(width: 8),
      Text(value, style: tt.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w700)),
    ]);
  }
}
