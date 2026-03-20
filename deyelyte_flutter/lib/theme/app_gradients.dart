import 'package:flutter/material.dart';
import 'app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Gradient Tokens
// ─────────────────────────────────────────────────────────────────────────────

class AppGradients {
  AppGradients._();

  /// Primary CTA — "energy flow" gradient at 135°.
  static const LinearGradient primaryCta = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.primaryContainer],
    transform: GradientRotation(2.356), // ~135°
  );

  /// Profit / Positive — neon green signature gradient.
  static const LinearGradient profitGreen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.secondary, AppColors.secondaryContainer],
    transform: GradientRotation(2.356), // ~135°
  );

  /// Deep hero panel background.
  static const LinearGradient heroDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF060E20),
      Color(0xFF0B1326),
      Color(0xFF0E1A2E),
    ],
  );

  /// Warm amber warning gradient (use very sparingly).
  static const LinearGradient warning = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.tertiary, AppColors.tertiaryContainer],
    transform: GradientRotation(2.356),
  );
}
