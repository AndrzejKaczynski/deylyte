import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// Shared price/numeric text field used across multiple settings cards.
class PriceField extends StatelessWidget {
  const PriceField({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
    this.suffix,
    this.hint,
    this.detail,
    this.optional = false,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<double?> onChanged;
  final String? suffix;
  final String? hint;
  final String? detail;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(label, style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        if (optional) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('optional',
                style: tt.labelSmall?.copyWith(color: AppColors.outline)),
          ),
        ],
      ]),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: tt.bodyMedium,
        onChanged: (text) =>
            onChanged(text.isEmpty ? null : double.tryParse(text)),
        decoration: InputDecoration(
          hintText: hint,
          suffixText: suffix,
          filled: true,
          fillColor: AppColors.surfaceContainerLow,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
      if (detail != null) ...[
        const SizedBox(height: 4),
        Text(detail!, style: tt.bodySmall?.copyWith(color: AppColors.outline)),
      ],
    ]);
  }
}
