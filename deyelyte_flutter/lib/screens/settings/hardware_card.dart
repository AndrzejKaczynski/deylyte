import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';

class HardwareCard extends StatelessWidget {
  const HardwareCard({
    super.key,
    required this.capacityCtrl,
    required this.gridConnectionCtrl,
    required this.chargeRateCtrl,
    required this.dischargeRateCtrl,
    required this.costCtrl,
    required this.lifecyclesCtrl,
  });

  final TextEditingController capacityCtrl;
  final TextEditingController gridConnectionCtrl;
  final TextEditingController chargeRateCtrl;
  final TextEditingController dischargeRateCtrl;
  final TextEditingController costCtrl;
  final TextEditingController lifecyclesCtrl;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(title: 'Hardware Setup'),
        const SizedBox(height: 16),

        // Inverter display row
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: AppRadius.radiusMd,
          ),
          child: Row(children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppGradients.profitGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.developer_board_rounded,
                  color: AppColors.onSecondary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Deye Inverter',
                        style: tt.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text('Enter your inverter model and battery specs below.',
                        style:
                            tt.bodySmall?.copyWith(color: AppColors.outline)),
                  ]),
            ),
          ]),
        ),

        const SizedBox(height: 20),
        Text('Battery Specifications',
            style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(
          'Used by the optimizer for scheduling and wear cost calculations.',
          style: tt.bodySmall?.copyWith(color: AppColors.outline),
        ),
        const SizedBox(height: 16),

        Row(children: [
          Expanded(
            child: _NumericField(
              label: 'Capacity',
              controller: capacityCtrl,
              suffix: 'kWh',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _NumericField(
              label: 'Grid Connection',
              controller: gridConnectionCtrl,
              suffix: 'kW',
            ),
          ),
        ]),
        const SizedBox(height: 4),
        Text(
          'Grid connection limit. Battery charging scales down to keep total draw within breaker capacity.',
          style: tt.bodySmall?.copyWith(color: AppColors.outline),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: _NumericField(
              label: 'Max Charge Rate',
              controller: chargeRateCtrl,
              suffix: 'kW',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _NumericField(
              label: 'Max Discharge Rate',
              controller: dischargeRateCtrl,
              suffix: 'kW',
            ),
          ),
        ]),
        const SizedBox(height: 4),
        Text(
          'Used for calculations only — these values are not sent to the inverter.',
          style: tt.bodySmall?.copyWith(color: AppColors.outline),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: _NumericField(
              label: 'Battery Cost',
              controller: costCtrl,
              suffix: 'PLN',
              optional: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _NumericField(
              label: 'Rated Cycles',
              controller: lifecyclesCtrl,
              hint: '6000',
              optional: true,
            ),
          ),
        ]),
      ]),
    );
  }
}

class _NumericField extends StatelessWidget {
  const _NumericField({
    required this.label,
    required this.controller,
    this.suffix,
    this.hint,
    this.optional = false,
  });

  final String label;
  final TextEditingController controller;
  final String? suffix;
  final String? hint;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(label,
            style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        if (optional) ...[
          const SizedBox(width: 6),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('optional',
                style: tt.labelSmall
                    ?.copyWith(color: AppColors.outline)),
          ),
        ],
      ]),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
        style: tt.bodyMedium,
        decoration: InputDecoration(
          hintText: hint,
          suffixText: suffix,
          filled: true,
          fillColor: AppColors.surfaceContainerLow,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: AppRadius.radiusMd,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.radiusMd,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.radiusMd,
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    ]);
  }
}
