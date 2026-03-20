import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_gradients.dart';
import 'app_radius.dart';
import 'app_shadows.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Decoration Helpers
//
// Pre-built BoxDecoration presets aligned to design system rules.
// ─────────────────────────────────────────────────────────────────────────────

class AppDecorations {
  AppDecorations._();

  // ── Glass Card ─────────────────────────────────────────────────────────────
  // For floating / real-time status modules.
  // Use BackdropFilter(filter: ImageFilter.blur(sigmaX:12, sigmaY:12)) as parent.
  static BoxDecoration glassCard({BorderRadius? borderRadius}) => BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.60),
        borderRadius: borderRadius ?? AppRadius.radiusLg,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.20),
          width: 1,
        ),
      );

  // ── Standard Interactive Card ──────────────────────────────────────────────
  static BoxDecoration card({
    Color? color,
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
  }) =>
      BoxDecoration(
        color: color ?? AppColors.surfaceContainer,
        borderRadius: borderRadius ?? AppRadius.radiusLg,
        boxShadow: shadows,
      );

  // ── Card with Ghost Border ──────────────────────────────────────────────────
  // Accessibility fallback only. Never use for decorative containment.
  static BoxDecoration cardWithGhostBorder({
    Color? color,
    BorderRadius? borderRadius,
  }) =>
      BoxDecoration(
        color: color ?? AppColors.surfaceContainer,
        borderRadius: borderRadius ?? AppRadius.radiusLg,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.20),
          width: 1,
        ),
      );

  // ── Profit / Secondary Gradient Card ──────────────────────────────────────
  static BoxDecoration profitCard({BorderRadius? borderRadius}) => BoxDecoration(
        gradient: AppGradients.profitGreen,
        borderRadius: borderRadius ?? AppRadius.radiusLg,
      );

  // ── Primary CTA Gradient Button ────────────────────────────────────────────
  static BoxDecoration ctaButton({bool hovered = false}) => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: hovered
              ? [AppColors.primaryContainer, AppColors.primary]
              : [AppColors.primary, AppColors.primaryContainer],
          transform: const GradientRotation(2.356),
        ),
        borderRadius: AppRadius.radiusMd,
        boxShadow: hovered ? AppShadows.ctaGlow : null,
      );

  // ── Disabled CTA ───────────────────────────────────────────────────────────
  static BoxDecoration ctaButtonDisabled() => BoxDecoration(
        color: AppColors.outlineVariant,
        borderRadius: AppRadius.radiusMd,
      );

  // ── Section Container (Low) ─────────────────────────────────────────────────
  // For sidebars / grouped content areas — no border, tonal depth only.
  static BoxDecoration sectionLow({BorderRadius? borderRadius}) => BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: borderRadius,
      );

  // ── Ambient Glass Sheet (Modal / Popover) ────────────────────────────────────
  static BoxDecoration modalSheet({BorderRadius? borderRadius}) => BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: borderRadius ?? AppRadius.radiusXl,
        boxShadow: AppShadows.ambientFloat,
      );

  // ── Error Banner ────────────────────────────────────────────────────────────
  static BoxDecoration errorBanner() => BoxDecoration(
        color: AppColors.errorContainer.withValues(alpha: 0.40),
        borderRadius: AppRadius.radiusMd,
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.30),
          width: 1,
        ),
      );
}
