import 'package:flutter/material.dart';
import '../theme/theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Energy Grid Painter (Decorative)
//
// Subtle grid lines for hero / feature backgrounds.
// [Chart spec] Grid lines at outlineVariant 10% opacity.
// ─────────────────────────────────────────────────────────────────────────────

class EnergyGridPainter extends CustomPainter {
  const EnergyGridPainter({this.spacing = 72, this.opacity = 0.06});

  final double spacing;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.outlineVariant.withValues(alpha: opacity)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(EnergyGridPainter old) =>
      old.spacing != spacing || old.opacity != opacity;
}
