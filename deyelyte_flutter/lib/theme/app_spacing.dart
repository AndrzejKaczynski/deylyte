// ─────────────────────────────────────────────────────────────────────────────
// Spacing Tokens
//
// The spec asks for generous breathing room. Use spacing-12 / spacing-16
// for major module margins. Never crowd the interface — increase spacing
// rather than adding dividers.
// ─────────────────────────────────────────────────────────────────────────────

class AppSpacing {
  AppSpacing._();

  static const double sp1  = 4.0;
  static const double sp2  = 8.0;
  static const double sp3  = 12.0;
  static const double sp4  = 16.0;   // List item separation (no dividers)
  static const double sp5  = 20.0;
  static const double sp6  = 24.0;
  static const double sp7  = 28.0;
  static const double sp8  = 32.0;
  static const double sp9  = 36.0;
  static const double sp10 = 40.0;
  static const double sp11 = 44.0;
  static const double sp12 = 48.0;   // ← major module margins
  static const double sp14 = 56.0;
  static const double sp16 = 64.0;   // ← major module margins (xl)
  static const double sp20 = 80.0;
  static const double sp24 = 96.0;

  // Semantic aliases
  static const double listItemGap     = sp4;   // "No-Divider" rule spacing
  static const double cardPadding     = sp6;
  static const double modulePadding   = sp8;
  static const double sectionMarginSm = sp12;
  static const double sectionMarginLg = sp16;
  static const double pagePaddingH    = sp6;   // horizontal safe-area
}
