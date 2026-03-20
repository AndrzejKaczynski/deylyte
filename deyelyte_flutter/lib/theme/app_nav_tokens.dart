import 'package:flutter/material.dart';
import 'app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Navigation Tokens
// ─────────────────────────────────────────────────────────────────────────────

class AppNavTokens {
  AppNavTokens._();

  // Sidebar (Desktop)
  static const Color sidebarBackground   = AppColors.surfaceContainerLowest;
  static const Color sidebarIconInactive = AppColors.onSurfaceVariant;
  static const Color sidebarIconActive   = AppColors.primary;
  static const Color sidebarActiveBadge  = AppColors.primary; // left "light bar"

  // Bottom Bar (Mobile) — 80% transparent, heavy backdrop blur (20px). No top border.
  static Color get bottomBarBackground =>
      AppColors.surfaceContainer.withValues(alpha: 0.80);
}
