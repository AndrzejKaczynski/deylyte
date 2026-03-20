import 'package:flutter/material.dart';
import 'app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shadow / Elevation Tokens
//
// Standard Material elevated shadows look muddy on dark.
// Use ambient tinted shadows instead.
// ─────────────────────────────────────────────────────────────────────────────

class AppShadows {
  AppShadows._();

  /// Ambient shadow for floating panels / modals.
  /// Tinted surfaceContainerHighest at 40% opacity, heavy blur, negative spread.
  static List<BoxShadow> get ambientFloat => [
        BoxShadow(
          color: AppColors.surfaceContainerHighest.withValues(alpha: 0.40),
          blurRadius: 48,
          spreadRadius: -5,
        ),
      ];

  /// Card hover lift — subtle primary tint glow.
  static List<BoxShadow> get cardHover => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.08),
          blurRadius: 24,
          spreadRadius: -4,
        ),
      ];

  /// Glow shadow for primary CTA button.
  static List<BoxShadow> get ctaGlow => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.25),
          blurRadius: 24,
          offset: const Offset(0, 6),
        ),
      ];

  /// Neon filament glow for chart lines (via drop-shadow filter).
  /// Use with [ImageFilter] or Flutter's [BoxShadow] on a repaint boundary.
  static List<BoxShadow> get glowTrace => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.30),
          blurRadius: 8,
        ),
      ];

  /// Danger / error glow (e.g. cost spike on a chart).
  static List<BoxShadow> get errorGlow => [
        BoxShadow(
          color: AppColors.error.withValues(alpha: 0.30),
          blurRadius: 8,
        ),
      ];
}
