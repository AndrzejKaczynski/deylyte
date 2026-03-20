import 'package:flutter/material.dart';
import '../theme/theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Label Text (Chart legend / timestamp style)
//
// [Label spec] outline color, uppercase, +0.05em tracking.
// ─────────────────────────────────────────────────────────────────────────────

class LabelText extends StatelessWidget {
  const LabelText(
    this.text, {
    super.key,
    this.color,
    this.small = false,
  });

  final String text;
  final Color? color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final style = (small ? tt.labelSmall : tt.labelMedium)?.copyWith(
      color: color ?? AppColors.outline,
      letterSpacing: 0.05,
    );
    return Text(text.toUpperCase(), style: style);
  }
}
