import 'package:flutter/material.dart';
import '../theme/theme.dart';

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
      cursor: disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
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
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
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
