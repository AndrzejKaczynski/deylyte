import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Deyelightful – "The Luminous Kinetic" Component Library
//
// This file contains reusable Widget-level building blocks derived directly
// from the design system rules. Import alongside app_theme.dart.
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// Glass Card
//
// [Glass & Gradient Rule] Use for floating elements (real-time status cards).
// Must be wrapped wit BackdropFilter to apply the blur effect.
// ─────────────────────────────────────────────────────────────────────────────

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppRadius.radiusLg;
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: width,
          height: height,
          margin: margin,
          padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: AppDecorations.glassCard(borderRadius: radius),
          child: child,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Surface Card
//
// Standard interactive data module. No border by default (tonal depth).
// Pass [withGhostBorder] for accessibility fallback only.
// ─────────────────────────────────────────────────────────────────────────────

class SurfaceCard extends StatefulWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.color,
    this.borderRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.withGhostBorder = false,
    this.onTap,
  });

  final Widget child;
  final Color? color;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final bool withGhostBorder;
  final VoidCallback? onTap;

  @override
  State<SurfaceCard> createState() => _SurfaceCardState();
}

class _SurfaceCardState extends State<SurfaceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? AppRadius.radiusLg;

    BoxDecoration decoration;
    if (widget.withGhostBorder) {
      decoration = AppDecorations.cardWithGhostBorder(
        color: widget.color,
        borderRadius: radius,
      ).copyWith(
        boxShadow: _hovered ? AppShadows.cardHover : null,
      );
    } else {
      decoration = AppDecorations.card(
        color: _hovered
            ? (widget.color ?? AppColors.surfaceContainer).withValues(alpha: 0.95)
            : widget.color,
        borderRadius: radius,
        shadows: _hovered ? AppShadows.cardHover : null,
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          padding:
              widget.padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: decoration,
          child: widget.child,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Gradient Button (Primary CTA)
//
// [Button spec] Gradient fill (primary → primaryContainer) at 135°.
// Radius: md (12px). On-primary text. Hover reverses gradient + glow.
// ─────────────────────────────────────────────────────────────────────────────

class GradientButton extends StatefulWidget {
  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width = double.infinity,
    this.height = 56.0,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double width;
  final double height;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null && !widget.isLoading;

    return MouseRegion(
      cursor: disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: (widget.isLoading || disabled) ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: widget.width,
          height: widget.height,
          decoration: disabled
              ? AppDecorations.ctaButtonDisabled()
              : AppDecorations.ctaButton(hovered: _hovered),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.onPrimary),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: 18, color: AppColors.onPrimary),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.label,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.02,
                            ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Ghost Button (Secondary CTA)
//
// No fill. Ghost border (outlineVariant at 20% opacity). Primary text.
// ─────────────────────────────────────────────────────────────────────────────

class GhostButton extends StatefulWidget {
  const GhostButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.width,
    this.height = 48.0,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final double height;

  @override
  State<GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<GhostButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.surfaceContainerHigh
                : Colors.transparent,
            borderRadius: AppRadius.radiusMd,
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.20),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
              ],
              Text(
                widget.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pulse Indicator
//
// [Real-time Indicator spec] 4px animated dot using secondary (positive) or
// error (cost/negative) color tokens.
// ─────────────────────────────────────────────────────────────────────────────

class PulseIndicator extends StatefulWidget {
  const PulseIndicator({
    super.key,
    this.color = AppColors.secondary,
    this.size = 8.0,
  });

  final Color color;
  final double size;

  @override
  State<PulseIndicator> createState() => _PulseIndicatorState();
}

class _PulseIndicatorState extends State<PulseIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _scaleAnim = Tween<double>(begin: 1.0, end: 2.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacityAnim = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 3,
      height: widget.size * 3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ripple ring
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => Transform.scale(
              scale: _scaleAnim.value,
              child: Opacity(
                opacity: _opacityAnim.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                  ),
                ),
              ),
            ),
          ),
          // Core dot
          Container(
            width: widget.size * 0.6,
            height: widget.size * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Metric
//
// [Display typography] For "art installation" KPI numbers — tight spacing,
// primary colour, optional unit suffix in labelMedium.
// ─────────────────────────────────────────────────────────────────────────────

class HeroMetric extends StatelessWidget {
  const HeroMetric({
    super.key,
    required this.value,
    this.unit,
    this.label,
    this.valueColor,
    this.size = HeroMetricSize.medium,
  });

  final String value;
  final String? unit;
  final String? label;
  final Color? valueColor;
  final HeroMetricSize size;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final baseStyle = switch (size) {
      HeroMetricSize.large  => tt.displayLarge,
      HeroMetricSize.medium => tt.displayMedium,
      HeroMetricSize.small  => tt.displaySmall,
    };
    final valueStyle = (baseStyle ?? const TextStyle()).copyWith(
      color: valueColor ?? AppColors.primary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: valueStyle),
            if (unit != null) ...[
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  unit!,
                  style: tt.labelMedium?.copyWith(
                    color: AppColors.outline,
                    letterSpacing: 0.05,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (label != null) ...[
          const SizedBox(height: 4),
          Text(
            label!.toUpperCase(),
            style: tt.labelSmall?.copyWith(
              color: AppColors.outline,
              letterSpacing: 0.08,
            ),
          ),
        ],
      ],
    );
  }
}

enum HeroMetricSize { large, medium, small }

// ─────────────────────────────────────────────────────────────────────────────
// Label Text (Chart legend / timestamp style)
//
// [Label spec] outline color, uppercase, +0.05em tracking.
// ─────────────────────────────────────────────────────────────────────────────

class LabelText extends StatelessWidget {
  const LabelText(
    this.text, {
    super.key,
    this.color,
    this.small = false,
  });

  final String text;
  final Color? color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final style = (small ? tt.labelSmall : tt.labelMedium)?.copyWith(
      color: color ?? AppColors.outline,
      letterSpacing: 0.05,
    );
    return Text(text.toUpperCase(), style: style);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sidebar Nav Item (Desktop)
//
// [Navigation spec] Icon: onSurfaceVariant inactive → primary active.
// Active state: primary icon + left "light bar" indicator (3px, primary).
// ─────────────────────────────────────────────────────────────────────────────

class SidebarNavItem extends StatefulWidget {
  const SidebarNavItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
    this.badge,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;
  final String? badge;

  @override
  State<SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<SidebarNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive;
    final iconColor = active ? AppColors.primary : AppColors.onSurfaceVariant;
    final bgColor = active || _hovered
        ? AppColors.surfaceContainerHigh
        : Colors.transparent;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 48,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Row(
            children: [
              // Active light bar (left edge)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 3,
                height: active ? 24 : 0,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(4),
                  ),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.40),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              // Icon
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(widget.icon, size: 22, color: iconColor),
                  if (widget.badge != null)
                    Positioned(
                      top: -4,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.badge!,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSecondary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              // Label
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    color: iconColor,
                    letterSpacing: active ? 0.01 : 0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat Chip
//
// Glass-morphic stat chip used in stats rows. Displays a headline value
// with a secondary label.
// ─────────────────────────────────────────────────────────────────────────────

class StatChip extends StatelessWidget {
  const StatChip({
    super.key,
    required this.value,
    required this.label,
    this.valueColor,
  });

  final String value;
  final String label;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: AppDecorations.glassCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: valueColor ?? AppColors.secondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  letterSpacing: -0.02,
                ),
          ),
          const SizedBox(height: 2),
          LabelText(label, small: true),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Header
//
// Consistent heading + optional action (tertiary text button) for card rows.
// Enforces the "No-Divider" layout — spacing only.
// ─────────────────────────────────────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: tt.headlineSmall),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: tt.bodySmall),
              ],
            ],
          ),
        ),
        if (actionLabel != null)
          TextButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.arrow_forward_rounded, size: 14),
            label: Text(actionLabel!),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Glow Orb (Decorative)
//
// Radial gradient "ambient light" orb for hero backgrounds.
// ─────────────────────────────────────────────────────────────────────────────

class GlowOrb extends StatelessWidget {
  const GlowOrb({
    super.key,
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}

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

// ─────────────────────────────────────────────────────────────────────────────
// Profit / Positive Gradient Badge
//
// Small pill-shaped badge for positive values (e.g. "+12.4 kWh").
// Uses the secondary → secondaryContainer gradient.
// ─────────────────────────────────────────────────────────────────────────────

class ProfitBadge extends StatelessWidget {
  const ProfitBadge({
    super.key,
    required this.label,
    this.icon,
  });

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: AppGradients.profitGreen,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: AppColors.onSecondary),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.onSecondary,
              letterSpacing: 0.02,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Warning Badge
//
// Uses tertiary (amber) — sparingly — for non-critical warnings.
// ─────────────────────────────────────────────────────────────────────────────

class WarningBadge extends StatelessWidget {
  const WarningBadge({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.tertiary.withValues(alpha: 0.30),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber_rounded, size: 13,
              color: AppColors.tertiary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.tertiary,
              letterSpacing: 0.02,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error Banner Widget
//
// Consistent error display for auth and form screens.
// ─────────────────────────────────────────────────────────────────────────────

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: AppDecorations.errorBanner(),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Asymmetric Grid Layout Helper
//
// [Do spec] "70% chart / 30% Quick Stats" asymmetric layout widget.
// Switches to stacked on mobile.
// ─────────────────────────────────────────────────────────────────────────────

class AsymmetricGrid extends StatelessWidget {
  const AsymmetricGrid({
    super.key,
    required this.primary,
    required this.sidebar,
    this.primaryFlex = 7,
    this.sidebarFlex = 3,
    this.gap = AppSpacing.sp4,
    this.mobileBreakpoint = 900,
  });

  final Widget primary;
  final Widget sidebar;
  final int primaryFlex;
  final int sidebarFlex;
  final double gap;
  final double mobileBreakpoint;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= mobileBreakpoint;

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: primaryFlex, child: primary),
          SizedBox(width: gap),
          Expanded(flex: sidebarFlex, child: sidebar),
        ],
      );
    }

    return Column(
      children: [
        primary,
        SizedBox(height: gap),
        sidebar,
      ],
    );
  }
}
