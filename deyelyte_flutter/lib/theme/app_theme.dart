import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DeyLyte Design System — "The Luminous Kinetic"
//
// Creative North Star: Energy as a living, breathing resource.
// Precision fintech meets atmospheric smart-home warmth.
// Built around intentional asymmetry, tonal depth, and glass-like layering.
// ─────────────────────────────────────────────────────────────────────────────

/// ── Color Tokens ─────────────────────────────────────────────────────────────
///
/// The palette is built around deep nocturnal foundations so that vibrant
/// "energy" accents pop with functional intent.
///
/// [No-Line Rule] 1px solid borders for sectioning are PROHIBITED.
/// Use background-color shifts or tonal transitions instead.
/// If a boundary is strictly required for accessibility, use a
/// "Ghost Border": outlineVariant at 20% opacity, weight 1px.
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

  static const Color surfaceContainerLowest = Color(0xFF060E20);
  static const Color surfaceContainerLow    = Color(0xFF131B2E);
  static const Color surface                = Color(0xFF0B1326);
  static const Color surfaceContainer       = Color(0xFF171F33);
  static const Color surfaceContainerHigh   = Color(0xFF222A3D);
  static const Color surfaceContainerHighest = Color(0xFF2D3449);
  static const Color surfaceBright          = Color(0xFF31394D);
  static const Color surfaceVariant         = Color(0xFF2D3449);

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
  static const double listItemGap    = sp4;   // "No-Divider" rule spacing
  static const double cardPadding    = sp6;
  static const double modulePadding  = sp8;
  static const double sectionMarginSm = sp12;
  static const double sectionMarginLg = sp16;
  static const double pagePaddingH   = sp6;   // horizontal safe-area
}

// ─────────────────────────────────────────────────────────────────────────────
// Border Radius Tokens
// ─────────────────────────────────────────────────────────────────────────────

class AppRadius {
  AppRadius._();

  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 12.0;   // Buttons, inputs
  static const double lg  = 16.0;   // Cards
  static const double xl  = 24.0;   // Large modal sheets
  static const double xxl = 32.0;

  static BorderRadius circle = BorderRadius.circular(999);

  static BorderRadius radiusMd  = BorderRadius.circular(md);
  static BorderRadius radiusLg  = BorderRadius.circular(lg);
  static BorderRadius radiusXl  = BorderRadius.circular(xl);
  static BorderRadius radiusXxl = BorderRadius.circular(xxl);
}

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
  }) => BoxDecoration(
        color: color ?? AppColors.surfaceContainer,
        borderRadius: borderRadius ?? AppRadius.radiusLg,
        boxShadow: shadows,
      );

  // ── Card with Ghost Border ──────────────────────────────────────────────────
  // Accessibility fallback only. Never use for decorative containment.
  static BoxDecoration cardWithGhostBorder({Color? color, BorderRadius? borderRadius}) =>
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

// ─────────────────────────────────────────────────────────────────────────────
// Navigation Tokens
// ─────────────────────────────────────────────────────────────────────────────

class AppNavTokens {
  AppNavTokens._();

  // Sidebar (Desktop)
  static const Color sidebarBackground    = AppColors.surfaceContainerLowest;
  static const Color sidebarIconInactive  = AppColors.onSurfaceVariant;
  static const Color sidebarIconActive    = AppColors.primary;
  static const Color sidebarActiveBadge   = AppColors.primary; // left "light bar"

  // Bottom Bar (Mobile) — 80% transparent, heavy backdrop blur (20px). No top border.
  static Color get bottomBarBackground =>
      AppColors.surfaceContainer.withValues(alpha: 0.80);
}

// ─────────────────────────────────────────────────────────────────────────────
// Full ThemeData — "The Luminous Kinetic" dark theme
// ─────────────────────────────────────────────────────────────────────────────

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      // Primary
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: const Color(0xFF00285D),
      // Secondary
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: const Color(0xFF004119),
      // Tertiary
      tertiary: AppColors.tertiary,
      onTertiary: const Color(0xFF472A00),
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: const Color(0xFF3E2400),
      // Error
      error: AppColors.error,
      onError: const Color(0xFF690005),
      errorContainer: AppColors.errorContainer,
      onErrorContainer: const Color(0xFFFFDAD6),
      // Surface
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      // Outline
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      // Inverse
      inverseSurface: const Color(0xFFDAE2FD),
      onInverseSurface: const Color(0xFF283044),
      inversePrimary: AppColors.inversePrimary,
    );

    // ── Typography ──────────────────────────────────────────────────────────
    // Inter, extreme weight contrast. Display roles: tight letter-spacing
    // (-0.02em), primary colour. Headline: SemiBold authoritative anchors.
    // Title: onSurfaceVariant (secondary to data). Body: 1.5+ line-height.
    // Labels: outline, UPPERCASE tracking (+0.05em).

    final base = GoogleFonts.interTextTheme(const TextTheme());
    final textTheme = base.copyWith(
      // Display — Hero Metrics ("art installation" feel)
      displayLarge: base.displayLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.02,
        height: 1.1,
        color: AppColors.primary,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.02,
        height: 1.1,
        color: AppColors.primary,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.02,
        height: 1.15,
        color: AppColors.primary,
      ),
      // Headline — Page / section titles (Fintech anchor, SemiBold)
      headlineLarge: base.headlineLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.01,
        color: AppColors.onSurface,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.01,
        color: AppColors.onSurface,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.01,
        color: AppColors.onSurface,
      ),
      // Title — Card headers (secondary to data, onSurfaceVariant)
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColors.onSurfaceVariant,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColors.onSurfaceVariant,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColors.onSurfaceVariant,
      ),
      // Body — Descriptions / reading copy (generous line height for dark bg)
      bodyLarge: base.bodyLarge?.copyWith(
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: AppColors.onSurface,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: AppColors.onSurface,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.onSurfaceVariant,
      ),
      // Label — Chart legends, timestamps (outline, uppercase tracking)
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.05,
        color: AppColors.outline,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.05,
        color: AppColors.outline,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.06,
        color: AppColors.outline,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surface,
      textTheme: textTheme,

      // ── AppBar ─────────────────────────────────────────────────────────────
      // Solid surfaceContainerLowest, no elevation, no tint.
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceContainerLowest,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
          letterSpacing: -0.4,
        ),
      ),

      // ── Card ───────────────────────────────────────────────────────────────
      // Elevation 0; tonal depth provides lift. Radius: lg (16px).
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainer,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Input Fields ───────────────────────────────────────────────────────
      // Background: surfaceContainerLow. Ghost border at 20%.
      // Focus: ghost border transitions to 50% primary.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.20),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.20),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.50),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        labelStyle: GoogleFonts.inter(
          color: AppColors.onSurfaceVariant,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.inter(
          color: AppColors.onSurfaceVariant.withValues(alpha: 0.60),
          fontSize: 14,
        ),
        prefixIconColor: AppColors.onSurfaceVariant,
        suffixIconColor: AppColors.onSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        errorStyle: GoogleFonts.inter(
          color: AppColors.error,
          fontSize: 12,
        ),
      ),

      // ── Elevated Button (Primary CTA) ──────────────────────────────────────
      // Gradient fill applied via custom widget; this configures fallback.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 0.02,
          ),
        ),
      ),

      // ── Outlined Button (Secondary — Ghost style) ──────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.20),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.01,
          ),
        ),
      ),

      // ── Text Button (Tertiary — text + icon, low emphasis) ─────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),

      // ── Icon ───────────────────────────────────────────────────────────────
      iconTheme: const IconThemeData(
        color: AppColors.onSurfaceVariant,
        size: 24,
      ),

      // ── Chip ───────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceContainerHigh,
        selectedColor: AppColors.primaryContainer,
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceVariant,
        ),
        side: BorderSide(
          color: AppColors.outlineVariant.withValues(alpha: 0.20),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // ── Divider ────────────────────────────────────────────────────────────
      // [No-Divider Rule] Dividers are forbidden for list item separation.
      // This theme entry is kept but should never be used for card lists.
      dividerTheme: DividerThemeData(
        color: AppColors.outlineVariant.withValues(alpha: 0.10),
        thickness: 1,
        space: 0,
      ),

      // ── Bottom Navigation Bar ──────────────────────────────────────────────
      // 80% transparent surfaceContainer + heavy backdrop blur (20px). No border.
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceContainer.withValues(alpha: 0.80),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.05,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),

      // ── Navigation Rail (Sidebar, Desktop) ────────────────────────────────
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.surfaceContainerLowest,
        indicatorColor: AppColors.primaryContainer.withValues(alpha: 0.15),
        selectedIconTheme: const IconThemeData(color: AppColors.primary),
        unselectedIconTheme: const IconThemeData(color: AppColors.onSurfaceVariant),
        selectedLabelTextStyle: GoogleFonts.inter(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.03,
        ),
        unselectedLabelTextStyle: GoogleFonts.inter(
          color: AppColors.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelType: NavigationRailLabelType.selected,
        elevation: 0,
        groupAlignment: -1,
      ),

      // ── Popup / Menu ───────────────────────────────────────────────────────
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.surfaceContainerHighest,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.20),
            width: 1,
          ),
        ),
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.inter(
            color: AppColors.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),

      // ── SnackBar ───────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceContainerHighest,
        contentTextStyle: GoogleFonts.inter(
          color: AppColors.onSurface,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      // ── Dialog / Bottom Sheet ──────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceContainerHighest,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        contentTextStyle: GoogleFonts.inter(
          color: AppColors.onSurfaceVariant,
          fontSize: 14,
          height: 1.6,
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surfaceContainerHigh,
        modalBackgroundColor: AppColors.surfaceContainerHigh,
        elevation: 0,
        modalElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),

      // ── Switch / Checkbox / Radio ──────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.onPrimary;
          return AppColors.onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.surfaceContainerHigh;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.transparent;
          return AppColors.outlineVariant.withValues(alpha: 0.40);
        }),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        checkColor: const WidgetStatePropertyAll(AppColors.onPrimary),
        side: BorderSide(
          color: AppColors.outlineVariant.withValues(alpha: 0.40),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
      ),

      // ── Progress / Loading ─────────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.surfaceContainerHigh,
        circularTrackColor: AppColors.surfaceContainerHigh,
      ),

      // ── Tooltip ────────────────────────────────────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.20),
            width: 1,
          ),
        ),
        textStyle: GoogleFonts.inter(
          color: AppColors.onSurface,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        preferBelow: true,
        verticalOffset: 12,
        waitDuration: const Duration(milliseconds: 600),
      ),

      // ── Slider ────────────────────────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.surfaceContainerHigh,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withValues(alpha: 0.12),
        valueIndicatorColor: AppColors.surfaceContainerHighest,
        valueIndicatorTextStyle: GoogleFonts.inter(
          color: AppColors.onSurface,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
