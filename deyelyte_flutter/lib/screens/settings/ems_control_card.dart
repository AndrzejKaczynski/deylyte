import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import 'settings_inputs.dart';

class EmsControlCard extends StatefulWidget {
  const EmsControlCard({
    super.key,
    required this.chargingEnabled,
    required this.sellingEnabled,
    required this.pvOnlySelling,
    required this.planningOnly,
    required this.hasBaseline,
    required this.priceSourceReady,
    required this.priceSource,
    required this.maxBuyPrice,
    required this.minSellPrice,
    required this.baselineLocked,
    required this.baselineUnlockDate,
    required this.onChargingChanged,
    required this.onSellingChanged,
    required this.onPvOnlySellingChanged,
    required this.onPlanningOnlyChanged,
    required this.onMaxBuyPriceChanged,
    required this.onMinSellPriceChanged,
    required this.onRestoreBaseline,
  });

  final bool chargingEnabled;
  final bool sellingEnabled;
  final bool pvOnlySelling;
  final bool planningOnly;
  final bool hasBaseline;
  final bool priceSourceReady;
  final String priceSource;
  final double maxBuyPrice;
  final double? minSellPrice;
  final bool baselineLocked;
  final DateTime? baselineUnlockDate;
  final ValueChanged<bool> onChargingChanged;
  final ValueChanged<bool> onSellingChanged;
  final ValueChanged<bool> onPvOnlySellingChanged;
  final ValueChanged<bool> onPlanningOnlyChanged;
  final ValueChanged<double> onMaxBuyPriceChanged;
  final ValueChanged<double?> onMinSellPriceChanged;
  final VoidCallback onRestoreBaseline;

  @override
  State<EmsControlCard> createState() => _EmsControlCardState();
}

class _EmsControlCardState extends State<EmsControlCard> {
  late final TextEditingController _buyPriceCtrl;
  late final TextEditingController _sellPriceCtrl;

  @override
  void initState() {
    super.initState();
    _buyPriceCtrl = TextEditingController(
        text: widget.maxBuyPrice.toStringAsFixed(4));
    _sellPriceCtrl = TextEditingController(
        text: widget.minSellPrice?.toStringAsFixed(4) ?? '');
  }

  @override
  void dispose() {
    _buyPriceCtrl.dispose();
    _sellPriceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(title: 'EMS Control'),
        const SizedBox(height: 20),

        // ── Planning Mode ──────────────────────────────────────────────────────
        IgnorePointer(
          ignoring: widget.baselineLocked,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: widget.baselineLocked ? 0.5 : 1.0,
            child: _ToggleSetting(
              icon: Icons.visibility_outlined,
              iconColor: AppColors.primary,
              label: 'Planning Mode',
              detail: widget.planningOnly
                  ? 'Optimizer runs and generates schedule — no commands sent to inverter.'
                  : 'Live mode: optimizer controls the inverter directly.',
              value: widget.planningOnly,
              onChanged: widget.onPlanningOnlyChanged,
            ),
          ),
        ),
        if (widget.baselineLocked) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.06),
              borderRadius: AppRadius.radiusMd,
              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.25)),
            ),
            child: Row(children: [
              const Icon(Icons.hourglass_top_rounded, size: 14, color: AppColors.secondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.baselineUnlockDate != null
                      ? 'Collecting 7-day baseline — EMS control unlocks on '
                        '${widget.baselineUnlockDate!.day.toString().padLeft(2, '0')}.'
                        '${widget.baselineUnlockDate!.month.toString().padLeft(2, '0')}.'
                        '${widget.baselineUnlockDate!.year}.'
                      : 'Collecting 7-day baseline — EMS control unlocks soon.',
                  style: tt.bodySmall?.copyWith(color: AppColors.secondary),
                ),
              ),
            ]),
          ),
        ] else if (widget.planningOnly) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: AppRadius.radiusMd,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(children: [
              const Icon(Icons.info_outline_rounded,
                  size: 14, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Charging and selling settings below are saved but ignored '
                  'until you disable Planning Mode.',
                  style: tt.bodySmall?.copyWith(color: AppColors.primary),
                ),
              ),
            ]),
          ),
          if (widget.hasBaseline) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.restore_rounded, size: 16),
              label: const Text('Restore to baseline settings'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
                textStyle: tt.labelSmall,
              ),
              onPressed: widget.onRestoreBaseline,
            ),
          ],
        ],

        const SizedBox(height: 20),
        const Divider(height: 1),
        const SizedBox(height: 20),

        // ── Charging / selling (dimmed in planning mode) ───────────────────────
        IgnorePointer(
          ignoring: widget.planningOnly,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: widget.planningOnly ? 0.4 : 1.0,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ── Price source not ready warning ─────────────────────────────────
          if (!widget.priceSourceReady) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.tertiary.withValues(alpha: 0.08),
                borderRadius: AppRadius.radiusMd,
                border: Border.all(
                    color: AppColors.tertiary.withValues(alpha: 0.3)),
              ),
              child: Row(children: [
                const Icon(Icons.warning_amber_rounded,
                    size: 14, color: AppColors.tertiary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    switch (widget.priceSource) {
                      'pstryk' => 'Connect your Pstryk account in the integrations section below to enable grid charging and selling.',
                      'rce' => 'Add at least one distribution charge range in the Pricing Source card to enable grid charging and selling.',
                      _ => 'Enter fixed buy and sell rates in the Pricing Source card to enable grid charging and selling.',
                    },
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.tertiary),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),
          ],

          // ── Charging section ───────────────────────────────────────────────
          IgnorePointer(
            ignoring: !widget.priceSourceReady,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: widget.priceSourceReady ? 1.0 : 0.4,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _ToggleSetting(
              icon: Icons.bolt_rounded,
              iconColor: AppColors.primary,
              label: 'Charge from Grid',
              detail: widget.chargingEnabled
                  ? 'Buying at or below the price threshold below.'
                  : 'Grid charging disabled. Inverter charges from PV only.',
              value: widget.chargingEnabled,
              onChanged: widget.onChargingChanged,
            ),
            if (widget.chargingEnabled) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: PriceField(
                  label: 'Max buy price',
                  controller: _buyPriceCtrl,
                  suffix: 'PLN/kWh',
                  hint: '0.0000',
                  detail: 'Charge when grid price is at or below this. Use 0.00 for free/negative energy only.',
                  onChanged: (v) => widget.onMaxBuyPriceChanged(v ?? 0.0),
                ),
              ),
            ],

            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 20),

            // ── Selling section ────────────────────────────────────────────
            _ToggleSetting(
              icon: Icons.upload_rounded,
              iconColor: AppColors.secondary,
              label: 'Sell to Grid',
              detail: widget.sellingEnabled
                  ? 'Discharging when selling is profitable.'
                  : 'Grid selling disabled. Battery used for self-consumption only.',
              value: widget.sellingEnabled,
              onChanged: widget.onSellingChanged,
            ),
            if (widget.sellingEnabled) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Grid arbitrage opt-in
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: AppRadius.radiusMd,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Grid Arbitrage',
                                      style: tt.bodyMedium
                                          ?.copyWith(fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.pvOnlySelling
                                        ? 'Off — only selling energy generated by PV.'
                                        : 'On — may buy from grid cheaply to sell at peak.',
                                    style: tt.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: !widget.pvOnlySelling,
                              onChanged: (v) =>
                                  widget.onPvOnlySellingChanged(!v),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ]),
                          if (!widget.pvOnlySelling) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                color: AppColors.tertiary.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color:
                                        AppColors.tertiary.withValues(alpha: 0.25)),
                              ),
                              child: Row(children: [
                                const Icon(Icons.info_outline_rounded,
                                    size: 13, color: AppColors.tertiary),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Grid arbitrage enabled. The EMS may charge from cheap grid energy and sell it at peak prices.',
                                    style: tt.labelSmall
                                        ?.copyWith(color: AppColors.tertiary),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    PriceField(
                      label: 'Min sell price',
                      controller: _sellPriceCtrl,
                      suffix: 'PLN/kWh',
                      hint: 'any profitable price',
                      optional: true,
                      detail: 'Only sell when grid price exceeds this. Leave empty to sell at any profitable spread.',
                      onChanged: widget.onMinSellPriceChanged,
                    ),
                  ],
                ),
              ),
            ],
              ]),    // inner Column children (charge + sell)
            ),       // AnimatedOpacity
          ),         // IgnorePointer (priceSourceReady gate)
        ]),          // outer Column children (planning mode + charge/sell)
        ),           // outer AnimatedOpacity
        ),           // outer IgnorePointer (planningOnly gate)
      ]),            // SurfaceCard Column children
    );
  }
}

class _ToggleSetting extends StatelessWidget {
  const _ToggleSetting({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.detail,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String detail;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Icon(icon,
            size: 16, color: value ? iconColor : AppColors.outline),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(detail, style: tt.bodySmall),
        ]),
      ),
      Switch(
        value: value,
        onChanged: onChanged,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ]);
  }
}
