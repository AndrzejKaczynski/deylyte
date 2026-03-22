import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';

class EmsStatusCard extends StatelessWidget {
  const EmsStatusCard({
    super.key,
    required this.chargingEnabled,
    required this.sellingEnabled,
    required this.pvOnlySelling,
    required this.maxBuyPrice,
    required this.minSoc,
  });

  final bool chargingEnabled;
  final bool sellingEnabled;
  final bool pvOnlySelling;
  final double maxBuyPrice;
  final double minSoc;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    final String modeLabel;
    final String modeDetail;
    final Color modeColor;
    final bool isActive;

    if (chargingEnabled && sellingEnabled) {
      modeLabel = 'Full EMS';
      modeDetail = 'Charging & selling optimised';
      modeColor = AppColors.secondary;
      isActive = true;
    } else if (chargingEnabled) {
      modeLabel = 'Charging Only';
      modeDetail = 'Grid buying active';
      modeColor = AppColors.primary;
      isActive = true;
    } else if (sellingEnabled) {
      modeLabel = 'Selling Only';
      modeDetail = 'Grid discharge active';
      modeColor = AppColors.secondary;
      isActive = true;
    } else {
      modeLabel = 'EMS Standby';
      modeDetail = 'Inverter self-managed';
      modeColor = AppColors.outline;
      isActive = false;
    }

    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.auto_mode_rounded,
              size: 18, color: isActive ? modeColor : AppColors.outline),
          const SizedBox(width: 8),
          Text('EMS Status', style: tt.titleMedium),
        ]),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: isActive
                ? LinearGradient(
                    colors: [
                      modeColor.withValues(alpha: 0.15),
                      modeColor.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isActive ? null : AppColors.surfaceContainerHigh,
            borderRadius: AppRadius.radiusMd,
            border: isActive
                ? Border.all(color: modeColor.withValues(alpha: 0.25))
                : null,
          ),
          child: Column(children: [
            Text(
              modeLabel,
              style: tt.headlineSmall?.copyWith(
                color: isActive ? modeColor : AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              modeDetail,
              style: tt.bodySmall?.copyWith(
                color: isActive
                    ? modeColor.withValues(alpha: 0.8)
                    : AppColors.outline,
              ),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        _StatusRow(
          label: 'Battery reserve',
          value: '${(minSoc * 100).round()}%',
          color: AppColors.error,
        ),
        const SizedBox(height: 8),
        _StatusRow(
          label: 'Grid charging',
          value: chargingEnabled
              ? '≤ ${maxBuyPrice.toStringAsFixed(4)} PLN/kWh'
              : 'Off',
          color: chargingEnabled ? AppColors.primary : AppColors.outline,
        ),
        const SizedBox(height: 8),
        _StatusRow(
          label: 'Selling mode',
          value: !sellingEnabled
              ? 'Off'
              : pvOnlySelling
                  ? 'PV only'
                  : 'Grid arbitrage',
          color: sellingEnabled
              ? (pvOnlySelling ? AppColors.secondary : AppColors.tertiary)
              : AppColors.outline,
        ),
      ]),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: tt.bodySmall),
      Text(value,
          style: tt.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600)),
    ]);
  }
}
