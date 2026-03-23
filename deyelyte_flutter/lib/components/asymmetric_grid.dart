import 'package:flutter/material.dart';
import '../theme/theme.dart';

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
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final Widget primary;
  final Widget sidebar;
  final int primaryFlex;
  final int sidebarFlex;
  final double gap;
  final double mobileBreakpoint;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= mobileBreakpoint;

    if (isDesktop) {
      return Row(
        crossAxisAlignment: crossAxisAlignment,
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
