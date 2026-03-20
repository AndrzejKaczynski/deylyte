import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_shadows.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Chart Tokens
// ─────────────────────────────────────────────────────────────────────────────

class AppChartTokens {
  AppChartTokens._();

  /// Grid line color — outlineVariant at 10% opacity (barely visible).
  static Color get gridLine => AppColors.outlineVariant.withValues(alpha: 0.10);

  /// Primary energy usage line — use with [glowTrace] shadow for filament effect.
  static const Color usageLine = AppColors.primary;

  /// Positive yield / export line.
  static const Color yieldLine = AppColors.secondary;

  /// Cost / grid-import line.
  static const Color costLine = AppColors.error;

  /// Warning / curtailment line.
  static const Color warningLine = AppColors.tertiary;

  /// Chart area fill — a very faint primary gradient from 20% → 0%.
  static LinearGradient get usageAreaFill => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withValues(alpha: 0.20),
          AppColors.primary.withValues(alpha: 0.00),
        ],
      );

  /// Filament glow shadow for the chart trace line.
  static List<BoxShadow> get glowTrace => AppShadows.glowTrace;
}
