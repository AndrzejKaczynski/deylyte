import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../providers/app_providers.dart';
import '../../providers/settings_provider.dart';

class StrategySummaryCard extends ConsumerWidget {
  const StrategySummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final settings = ref.watch(settingsProvider);
    final config = ref.watch(appConfigProvider).valueOrNull;

    final activeStrategy = switch (settings.priceSource) {
      'pstryk' || 'rce' => settings.pvOnlySelling ? 'Solar-only selling' : 'Grid arbitrage allowed',
      'manual' || 'fixed' => 'Manual',
      _ => 'Grid arbitrage allowed',
    };

    final weatherInput = settings.solcast
        ? 'Solcast forecast active'
        : 'No weather data (Open-Meteo fallback)';

    final since = config?.dataGatheringSince;
    final String historicalBasis;
    if (since == null) {
      historicalBasis = 'Baseline collecting (0/7 days)';
    } else {
      final days = DateTime.now().toUtc().difference(since).inDays;
      if (days < 7) {
        historicalBasis = 'Baseline collecting ($days/7 days)';
      } else {
        historicalBasis = 'Based on $days days of data';
      }
    }

    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.psychology_rounded, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(child: Text('Strategy Summary', style: tt.titleMedium, overflow: TextOverflow.ellipsis)),
        ]),
        const SizedBox(height: 16),
        _StrategyRow(
          label: 'Active strategy',
          detail: activeStrategy,
          icon: Icons.auto_graph_rounded,
          color: AppColors.primary,
        ),
        const SizedBox(height: 12),
        _StrategyRow(
          label: 'Weather input',
          detail: weatherInput,
          icon: Icons.wb_sunny_rounded,
          color: AppColors.tertiary,
        ),
        const SizedBox(height: 12),
        _StrategyRow(
          label: 'Historical basis',
          detail: historicalBasis,
          icon: Icons.history_rounded,
          color: AppColors.primary,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: AppRadius.radiusMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How decisions are made',
                style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                'The optimizer combines hourly energy buy/sell prices, '
                'the solar generation forecast, and your historical load '
                'baseline to schedule battery charge and discharge cycles '
                'that minimise grid cost and maximise feed-in revenue.',
                style: tt.bodySmall
                    ?.copyWith(color: AppColors.onSurfaceVariant, height: 1.5),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class _StrategyRow extends StatelessWidget {
  const _StrategyRow({
    required this.label,
    required this.detail,
    required this.icon,
    required this.color,
  });
  final String label;
  final String detail;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 8),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
          Text(detail, style: tt.bodySmall),
        ]),
      ),
    ]);
  }
}
