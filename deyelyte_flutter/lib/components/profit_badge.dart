import 'package:flutter/material.dart';
import '../theme/theme.dart';

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
