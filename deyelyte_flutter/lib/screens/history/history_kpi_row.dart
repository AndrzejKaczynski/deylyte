import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../providers/app_providers.dart';

class HistoryKpiRow extends ConsumerWidget {
  const HistoryKpiRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final rangeIdx = ref.watch(historyRangeProvider);
    final days = rangeDays(rangeIdx);
    final summary = ref.watch(historySummaryProvider(days)).valueOrNull ?? {};

    final priceVelocity = summary['priceVelocity'] as double? ?? 0.0;
    final netRevenue = summary['netRevenuePln'] as double? ?? 0.0;
    final peakLoad = summary['peakLoadKw'] as double? ?? 0.0;
    final greenMix = summary['greenMixPercent'] as double? ?? 0.0;

    final items = [
      (label: 'Price Velocity', value: '${priceVelocity.toStringAsFixed(2)} zł/kWh', sub: 'Avg. this period', color: AppColors.primary, icon: Icons.speed_rounded),
      (label: 'Net Revenue', value: '${netRevenue >= 0 ? '+' : ''}${netRevenue.toStringAsFixed(2)} zł', sub: 'This period', color: AppColors.secondary, icon: Icons.trending_up_rounded),
      (label: 'Peak Load', value: '${peakLoad.toStringAsFixed(1)} kW', sub: 'Highest usage point', color: AppColors.tertiary, icon: Icons.flash_on_rounded),
      (label: 'Green Mix', value: '${greenMix.toStringAsFixed(0)}%', sub: 'Renewable source', color: AppColors.secondary, icon: Icons.eco_rounded),
    ];

    return LayoutBuilder(builder: (_, c) {
      final wide = c.maxWidth > 600;
      final widgets = items.map((it) {
        return SurfaceCard(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(it.icon, size: 14, color: it.color),
              const SizedBox(width: 6),
              Text(it.label, style: tt.bodySmall),
            ]),
            const SizedBox(height: 8),
            Text(it.value,
                style: tt.headlineSmall?.copyWith(
                    color: it.color, fontWeight: FontWeight.w700, letterSpacing: -0.02)),
            const SizedBox(height: 2),
            Text(it.sub, style: tt.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
          ]),
        );
      }).toList();

      if (wide) {
        return Row(
          children: widgets
              .map((w) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 12), child: w)))
              .toList(),
        );
      }
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
        children: widgets,
      );
    });
  }
}
