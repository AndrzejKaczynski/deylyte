import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Glass Card
//
// [Glass & Gradient Rule] Use for floating elements (real-time status cards).
// Must be wrapped with BackdropFilter to apply the blur effect.
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
