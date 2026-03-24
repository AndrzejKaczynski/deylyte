import 'package:deyelyte_client/deyelyte_client.dart';
import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import 'settings_inputs.dart';

class PricingSourceCard extends StatefulWidget {
  const PricingSourceCard({
    super.key,
    required this.priceSource,
    required this.fixedBuyRate,
    required this.priceTimeRanges,
    required this.onSourceChanged,
    required this.onFixedBuyChanged,
    required this.onRangesChanged,
  });

  final String priceSource;
  final double? fixedBuyRate;
  final List<PriceTimeRange> priceTimeRanges;
  final ValueChanged<String> onSourceChanged;
  final ValueChanged<double?> onFixedBuyChanged;
  final ValueChanged<List<PriceTimeRange>> onRangesChanged;

  @override
  State<PricingSourceCard> createState() => _PricingSourceCardState();
}

class _PricingSourceCardState extends State<PricingSourceCard> {
  late final TextEditingController _fixedBuyCtrl;

  @override
  void initState() {
    super.initState();
    _fixedBuyCtrl = TextEditingController(
        text: widget.fixedBuyRate?.toStringAsFixed(4) ?? '');
  }

  @override
  void dispose() {
    _fixedBuyCtrl.dispose();
    super.dispose();
  }

  void _addRange() async {
    final result = await showDialog<PriceTimeRange>(
      context: context,
      builder: (_) => const _RangeEditorDialog(),
    );
    if (result != null) {
      widget.onRangesChanged([...widget.priceTimeRanges, result]);
    }
  }

  void _deleteRange(int index) {
    final updated = List<PriceTimeRange>.from(widget.priceTimeRanges)
      ..removeAt(index);
    widget.onRangesChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final showRanges = widget.priceSource == 'rce' || widget.priceSource == 'fixed';

    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(title: 'Pricing Source'),
        const SizedBox(height: 16),
        _PriceSourcePicker(
          selected: widget.priceSource,
          onChanged: widget.onSourceChanged,
        ),
        const SizedBox(height: 4),
        Text(
          switch (widget.priceSource) {
            'pstryk' => 'Hourly buy/sell prices from the Pstryk API.',
            'rce' =>
              'RCE wholesale market prices (PSE) plus per-range distribution charges.',
            _ => 'Fixed buy rates, optionally varied by time range.',
          },
          style: tt.bodySmall?.copyWith(color: AppColors.outline),
        ),
        if (widget.priceSource == 'rce' || widget.priceSource == 'fixed') ...[
          const SizedBox(height: 6),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.info_outline_rounded,
                size: 13, color: AppColors.outline),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'Sell prices always use RCE market rates regardless of this setting.',
                style: tt.bodySmall?.copyWith(color: AppColors.outline),
              ),
            ),
          ]),
        ],

        // ── Fixed: fallback rates ──────────────────────────────────────────
        if (widget.priceSource == 'fixed' || widget.priceSource == 'manual') ...[
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Text('Fallback rates (used when no range covers the hour)',
              style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          PriceField(
            label: 'Buy rate',
            controller: _fixedBuyCtrl,
            suffix: 'PLN/kWh',
            hint: '0.0000',
            detail: 'Default buy price when no time range covers that hour.',
            onChanged: (v) => widget.onFixedBuyChanged(v),
          ),
          const SizedBox(height: 12),
        ],

        // ── RCE / Fixed: time ranges ───────────────────────────────────────
        if (showRanges) ...[
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Text(
            widget.priceSource == 'rce'
                ? 'Distribution charge ranges'
                : 'Per-hour rate ranges',
            style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            widget.priceSource == 'rce'
                ? 'Each range adds a distribution charge on top of the RCE price for those hours.'
                : 'Each range sets a buy rate for those hours.',
            style: tt.bodySmall?.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 8),
          if (widget.priceTimeRanges.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'No ranges defined.',
                style: tt.bodySmall?.copyWith(color: AppColors.outline),
              ),
            )
          else
            ...widget.priceTimeRanges.asMap().entries.map((entry) {
              final i = entry.key;
              final r = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: AppRadius.radiusMd,
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Text(
                        'Hour ${r.hourStart.toString().padLeft(2, '0')}–'
                        '${r.hourEnd.toString().padLeft(2, '0')}  '
                        '${r.distributionRatePln.toStringAsFixed(4)} PLN/kWh',
                        style: tt.bodySmall,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _deleteRange(i),
                      child: const Icon(Icons.close_rounded,
                          size: 16, color: AppColors.outline),
                    ),
                  ]),
                ),
              );
            }),
          const SizedBox(height: 4),
          TextButton.icon(
            onPressed: _addRange,
            icon: const Icon(Icons.add_rounded, size: 16),
            label: const Text('Add range'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
        ],
      ]),
    );
  }
}

class _PriceSourcePicker extends StatelessWidget {
  const _PriceSourcePicker({
    required this.selected,
    required this.onChanged,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  static const _options = [
    ('pstryk', 'Pstryk'),
    ('rce', 'RCE'),
    ('fixed', 'Fixed'),
  ];

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: _options.map((opt) {
          final (value, label) = opt;
          final isSelected = selected == value;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: tt.bodySmall?.copyWith(
                    color: isSelected
                        ? AppColors.surface
                        : AppColors.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _RangeEditorDialog extends StatefulWidget {
  const _RangeEditorDialog();

  @override
  State<_RangeEditorDialog> createState() => _RangeEditorDialogState();
}

class _RangeEditorDialogState extends State<_RangeEditorDialog> {
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text('Add time range'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Expanded(
            child: _HourField(
              label: 'From hour',
              controller: _fromCtrl,
              onChanged: (_) {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _HourField(
              label: 'To hour',
              controller: _toCtrl,
              onChanged: (_) {},
            ),
          ),
        ]),
        const SizedBox(height: 12),
        PriceField(
          label: 'Rate',
          controller: _rateCtrl,
          suffix: 'PLN/kWh',
          hint: '0.0000',
          detail: 'Buy rate for this window.',
          onChanged: (_) {},
        ),
      ]),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final from = int.tryParse(_fromCtrl.text);
            final to = int.tryParse(_toCtrl.text);
            final rate = double.tryParse(_rateCtrl.text);
            if (from == null || to == null || rate == null) return;
            Navigator.of(context).pop(PriceTimeRange(
              userInfoId: 0, // server overwrites
              hourStart: from,
              hourEnd: to,
              distributionRatePln: rate,
            ));
          },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class _HourField extends StatelessWidget {
  const _HourField({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
      const SizedBox(height: 4),
      TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: AppColors.onSurface),
        decoration: InputDecoration(
          hintText: '0–23',
          hintStyle:
              const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
          filled: true,
          fillColor: AppColors.surfaceContainerHigh,
          border: OutlineInputBorder(
            borderRadius: AppRadius.radiusMd,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.radiusMd,
            borderSide:
                const BorderSide(color: AppColors.outlineVariant, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.radiusMd,
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        onChanged: (v) {
          final parsed = int.tryParse(v);
          onChanged(parsed != null && parsed >= 0 && parsed <= 23
              ? parsed
              : null);
        },
      ),
    ]);
  }
}
