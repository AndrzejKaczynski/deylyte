import 'package:flutter/material.dart';
import '../../theme/theme.dart';

// ─── Legend toggle chip ───────────────────────────────────────────────────────

enum LayerChipStyle {
  solid, // filled square indicator
  dashed, // dashed-border square indicator (for PV estimate)
}

class LayerChip extends StatelessWidget {
  const LayerChip({
    super.key,
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
    this.style = LayerChipStyle.solid,
    this.tooltip,
  });

  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;
  final LayerChipStyle style;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final chip = GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active
              ? color.withValues(alpha: 0.12)
              : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: active ? color.withValues(alpha: 0.35) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          _Indicator(color: active ? color : AppColors.outline, style: style, active: active),
          const SizedBox(width: 6),
          Text(
            label,
            style: tt.labelSmall?.copyWith(
              color: active ? color : AppColors.outline,
              fontWeight: FontWeight.w600,
            ),
          ),
        ]),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: chip);
    }
    return chip;
  }
}

// ─── Square indicator (solid or dashed) ──────────────────────────────────────

class _Indicator extends StatelessWidget {
  const _Indicator({
    required this.color,
    required this.style,
    required this.active,
  });

  final Color color;
  final LayerChipStyle style;
  final bool active;

  @override
  Widget build(BuildContext context) {
    if (style == LayerChipStyle.dashed) {
      return CustomPaint(
        size: const Size(8, 8),
        painter: _DashedSquarePainter(color: color),
      );
    }
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

// ─── Dashed border square painter ────────────────────────────────────────────

class _DashedSquarePainter extends CustomPainter {
  const _DashedSquarePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const dash = 2.5;
    const gap = 1.5;
    final perimeter = [
      for (var x = 0.0; x < size.width; x += dash + gap)
        [Offset(x, 0), Offset((x + dash).clamp(0, size.width), 0)],
      for (var y = 0.0; y < size.height; y += dash + gap)
        [Offset(size.width, y), Offset(size.width, (y + dash).clamp(0, size.height))],
      for (var x = size.width; x > 0; x -= dash + gap)
        [Offset(x, size.height), Offset((x - dash).clamp(0, size.width), size.height)],
      for (var y = size.height; y > 0; y -= dash + gap)
        [Offset(0, y), Offset(0, (y - dash).clamp(0, size.height))],
    ];
    for (final seg in perimeter) {
      canvas.drawLine(seg[0], seg[1], paint);
    }
  }

  @override
  bool shouldRepaint(_DashedSquarePainter old) => old.color != color;
}
