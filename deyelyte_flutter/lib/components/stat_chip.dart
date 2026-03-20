import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'label_text.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Stat Chip
//
// Glass-morphic stat chip used in stats rows. Displays a headline value
// with a secondary label.
// ─────────────────────────────────────────────────────────────────────────────

class StatChip extends StatelessWidget {
  const StatChip({
    super.key,
    required this.value,
    required this.label,
    this.valueColor,
  });

  final String value;
  final String label;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: AppDecorations.glassCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: valueColor ?? AppColors.secondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  letterSpacing: -0.02,
                ),
          ),
          const SizedBox(height: 2),
          LabelText(label, small: true),
        ],
      ),
    );
  }
}
