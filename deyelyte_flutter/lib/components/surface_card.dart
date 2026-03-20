import 'package:flutter/material.dart';
import '../theme/theme.dart';

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
          padding: widget.padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: decoration,
          child: widget.child,
        ),
      ),
    );
  }
}
