import 'package:flutter/material.dart';
import '../theme/theme.dart';

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
