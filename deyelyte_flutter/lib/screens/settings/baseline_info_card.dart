import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../providers/settings_provider.dart';

class BaselineInfoCard extends StatelessWidget {
  const BaselineInfoCard({super.key, required this.settings});
  final SettingsState settings;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final chargingLabel =
        (settings.baselineChargingEnabled ?? false) ? 'On' : 'Off';
    final sellingLabel =
        (settings.baselineSellingEnabled ?? false) ? 'On' : 'Off';
    final priceLabel = settings.baselineMaxBuyPrice != null
        ? '${settings.baselineMaxBuyPrice!.toStringAsFixed(4)} PLN/kWh'
        : '—';
    final sourceLabel = settings.baselinePriceSource ?? 'pstryk';

    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.safety_check_rounded,
              size: 16, color: AppColors.secondary),
          const SizedBox(width: 8),
          Text('Offline Fallback',
              style: tt.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 6),
        Text(
          'If the add-on loses server connection for >15 min it reverts to '
          'these baseline settings to prevent runaway charges.',
          style: tt.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        _BaselineRow(label: 'Charge from grid', value: chargingLabel),
        _BaselineRow(label: 'Sell to grid', value: sellingLabel),
        _BaselineRow(label: 'Max buy price', value: priceLabel),
        _BaselineRow(label: 'Price source', value: sourceLabel),
      ]),
    );
  }
}

class _BaselineRow extends StatelessWidget {
  const _BaselineRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: tt.bodySmall
                  ?.copyWith(color: AppColors.onSurfaceVariant)),
          Text(value,
              style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
