import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Full ThemeData — "The Luminous Kinetic" dark theme
//
// Creative North Star: Energy as a living, breathing resource.
// Precision fintech meets atmospheric smart-home warmth.
// Built around intentional asymmetry, tonal depth, and glass-like layering.
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
          horizontal: AppSpacing.sp5,
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
        unselectedIconTheme:
            const IconThemeData(color: AppColors.onSurfaceVariant),
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
          if (states.contains(WidgetState.selected)) return AppColors.primary;
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
