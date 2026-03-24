import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'hour_data.dart';
import 'daily_chart_painter.dart';

// ─── Floating hover card ──────────────────────────────────────────────────────

class HoverCard extends StatelessWidget {
  const HoverCard({
    super.key,
    required this.data,
    required this.layers,
    this.isLive = false,
    this.columnLabel,
  });

  final HourData data;
  final Layers layers;
  final bool isLive;

  /// Override label shown in the card header.
  /// When null, defaults to "HH:00 STATS" from data.hour.
  final String? columnLabel;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final hour = data.hour.toString().padLeft(2, '0');
    final title = columnLabel ?? '$hour:00 STATS';

    return Container(
      constraints: const BoxConstraints(minWidth: 168),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: tt.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                ),
              ),
              if (isLive) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Live',
                    style: tt.labelSmall?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),

          if (layers.showPvIntake || layers.showPvEstimate)
            _StatRow(
              label: 'PV Intake',
              value: data.pvActualKw != null
                  ? '${data.pvActualKw!.toStringAsFixed(2)} kW'
                  : data.pvKw > 0
                      ? '${data.pvKw.toStringAsFixed(2)} kW'
                      : '0.00 kW',
              color: AppColors.tertiary,
            ),

          if (layers.showLoad && data.loadKw != null)
            _StatRow(
              label: 'Home Load',
              value: '${data.loadKw!.toStringAsFixed(2)} kW',
              color: AppColors.onSurface,
            ),

          if (layers.showBuyPrice && data.buyPrice != null)
            _StatRow(
              label: 'Buy Price',
              value: '${data.buyPrice!.toStringAsFixed(2)} PLN/kWh',
              color: priceColor(data.buyPrice!),
            ),

          if (layers.showSellPrice && data.sellPrice != null && data.sellPrice! > 0)
            _StatRow(
              label: 'Sell Price',
              value: '${data.sellPrice!.toStringAsFixed(2)} PLN/kWh',
              color: sellPriceColor(data.sellPrice!),
            ),

          if (data.gridKw != null) ...[
            if (data.gridKw! < -0.05)
              _StatRow(
                label: 'Exporting',
                value: '+${(-data.gridKw!).toStringAsFixed(2)} kW',
                color: AppColors.secondary,
              )
            else if (data.gridKw! > 0.05)
              _StatRow(
                label: 'Importing',
                value: '${data.gridKw!.toStringAsFixed(2)} kW',
                color: AppColors.error,
              ),
          ],

          if (layers.showSoc && data.socPct != null)
            _StatRow(
              label: 'Battery SoC',
              value: '${data.socPct!.toStringAsFixed(0)}%',
              color: AppColors.primary,
            ),

          if (data.batteryKw != null && data.batteryKw!.abs() > 0.05)
            _StatRow(
              label: data.batteryKw! > 0 ? 'Charging' : 'Discharging',
              value: '${data.batteryKw!.abs().toStringAsFixed(2)} kW',
              color: data.batteryKw! > 0 ? AppColors.secondary : AppColors.error,
            ),

          if (layers.showPlan)
            _StatRow(
              label: 'Plan',
              value: data.command ?? 'idle',
              color: data.command == 'charge'
                  ? AppColors.secondary
                  : data.command == 'discharge'
                      ? AppColors.error
                      : AppColors.onSurfaceVariant,
            ),
        ],
      ),
    );
  }
}

// ─── Single stat row ──────────────────────────────────────────────────────────

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: tt.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: tt.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
