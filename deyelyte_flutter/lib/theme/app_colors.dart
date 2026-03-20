import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Color Tokens
//
// The palette is built around deep nocturnal foundations so that vibrant
// "energy" accents pop with functional intent.
//
// [No-Line Rule] 1px solid borders for sectioning are PROHIBITED.
// Use background-color shifts or tonal transitions instead.
// If a boundary is strictly required for accessibility, use a
// "Ghost Border": outlineVariant at 20% opacity, weight 1px.
// ─────────────────────────────────────────────────────────────────────────────

class AppColors {
  AppColors._();

  // ── Surface Hierarchy ──────────────────────────────────────────────────────
  // Think of the UI as physical layers of smoked glass.
  //
  //   surfaceContainerLowest  →  darkest — deep hero backgrounds
  //   surfaceContainerLow     →  sidebars, grouped content
  //   surface                 →  overall application canvas (base layer)
  //   surfaceContainer        →  primary interactive data cards
  //   surfaceContainerHigh    →  subtle hover / pressed card states
  //   surfaceContainerHighest →  active states, floating modals
  //   surfaceBright           →  maximum surface brightness (rarely used)
  //   surfaceVariant          →  glass containers (use at 60% opacity)

  static const Color surfaceContainerLowest  = Color(0xFF060E20);
  static const Color surfaceContainerLow     = Color(0xFF131B2E);
  static const Color surface                 = Color(0xFF0B1326);
  static const Color surfaceContainer        = Color(0xFF171F33);
  static const Color surfaceContainerHigh    = Color(0xFF222A3D);
  static const Color surfaceContainerHighest = Color(0xFF2D3449);
  static const Color surfaceBright           = Color(0xFF31394D);
  static const Color surfaceVariant          = Color(0xFF2D3449);

  // ── Primary — Deep Blue ────────────────────────────────────────────────────
  static const Color primary          = Color(0xFFADC6FF);
  static const Color primaryContainer = Color(0xFF4D8EFF);
  static const Color onPrimary        = Color(0xFF002E6A);
  static const Color inversePrimary   = Color(0xFF005AC2);

  // ── Secondary — Neon Green (Energy / Profit) ───────────────────────────────
  // For Profit / positive highlights use a linear gradient from
  // [secondary] to [secondaryContainer] at 135°.
  static const Color secondary          = Color(0xFF4AE176);
  static const Color secondaryContainer = Color(0xFF00B954);
  static const Color onSecondary        = Color(0xFF003915);

  // ── Tertiary — Amber (Warning — use sparingly) ─────────────────────────────
  static const Color tertiary          = Color(0xFFFFB95F);
  static const Color tertiaryContainer = Color(0xFFCA8100);

  // ── On-Surface ────────────────────────────────────────────────────────────
  static const Color onSurface        = Color(0xFFDAE2FD);
  static const Color onSurfaceVariant = Color(0xFFC2C6D6);

  // ── Outline ───────────────────────────────────────────────────────────────
  // "Ghost Border" uses outlineVariant at opacity 0.20.
  static const Color outline        = Color(0xFF8C909F);
  static const Color outlineVariant = Color(0xFF424754);

  // ── Error ─────────────────────────────────────────────────────────────────
  static const Color error          = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
}
