import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';

class HardwareCard extends StatefulWidget {
  const HardwareCard({
    super.key,
    required this.batteryCapacityKwh,
    required this.batteryCost,
    required this.batteryLifecycles,
    required this.maxDischargeRateKw,
    required this.maxChargeRateKw,
    required this.gridConnectionKw,
    required this.onCapacityChanged,
    required this.onCostChanged,
    required this.onLifecyclesChanged,
    required this.onDischargeRateChanged,
    required this.onChargeRateChanged,
    required this.onGridConnectionChanged,
  });

  final double batteryCapacityKwh;
  final double? batteryCost;
  final int batteryLifecycles;
  final double maxDischargeRateKw;
  final double? maxChargeRateKw;
  final double? gridConnectionKw;
  final ValueChanged<double> onCapacityChanged;
  final ValueChanged<double?> onCostChanged;
  final ValueChanged<int> onLifecyclesChanged;
  final ValueChanged<double> onDischargeRateChanged;
  final ValueChanged<double?> onChargeRateChanged;
  final ValueChanged<double?> onGridConnectionChanged;

  @override
  State<HardwareCard> createState() => _HardwareCardState();
}

class _HardwareCardState extends State<HardwareCard> {
  late final TextEditingController _capacityCtrl;
  late final TextEditingController _costCtrl;
  late final TextEditingController _lifecyclesCtrl;
  late final TextEditingController _dischargeRateCtrl;
  late final TextEditingController _chargeRateCtrl;
  late final TextEditingController _gridConnectionCtrl;

  @override
  void initState() {
    super.initState();
    _capacityCtrl = TextEditingController(
        text: widget.batteryCapacityKwh.toStringAsFixed(1));
    _costCtrl = TextEditingController(
        text: widget.batteryCost?.toStringAsFixed(0) ?? '');
    _lifecyclesCtrl = TextEditingController(
        text: widget.batteryLifecycles.toString());
    _dischargeRateCtrl = TextEditingController(
        text: widget.maxDischargeRateKw.toStringAsFixed(1));
    _chargeRateCtrl = TextEditingController(
        text: widget.maxChargeRateKw?.toStringAsFixed(1) ?? '');
    _gridConnectionCtrl = TextEditingController(
        text: widget.gridConnectionKw?.toStringAsFixed(1) ?? '');
  }

  @override
  void dispose() {
    _capacityCtrl.dispose();
    _costCtrl.dispose();
    _lifecyclesCtrl.dispose();
    _dischargeRateCtrl.dispose();
    _chargeRateCtrl.dispose();
    _gridConnectionCtrl.dispose();
    super.dispose();
  }

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
              controller: _capacityCtrl,
              suffix: 'kWh',
              onChanged: (v) {
                if (v != null) widget.onCapacityChanged(v);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _NumericField(
              label: 'Grid Connection',
              controller: _gridConnectionCtrl,
              suffix: 'kW',
              onChanged: widget.onGridConnectionChanged,
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
              controller: _chargeRateCtrl,
              suffix: 'kW',
              onChanged: widget.onChargeRateChanged,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _NumericField(
              label: 'Max Discharge Rate',
              controller: _dischargeRateCtrl,
              suffix: 'kW',
              onChanged: (v) {
                if (v != null) widget.onDischargeRateChanged(v);
              },
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
              controller: _costCtrl,
              suffix: 'PLN',
              optional: true,
              onChanged: widget.onCostChanged,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _NumericField(
              label: 'Rated Cycles',
              controller: _lifecyclesCtrl,
              hint: '6000',
              optional: true,
              onChanged: (v) {
                if (v != null) widget.onLifecyclesChanged(v.toInt());
              },
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
    required this.onChanged,
    this.suffix,
    this.hint,
    this.optional = false,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<double?> onChanged;
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
        onChanged: (text) =>
            onChanged(text.isEmpty ? null : double.tryParse(text)),
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
