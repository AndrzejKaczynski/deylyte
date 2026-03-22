import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';

class PowerFlowCard extends StatelessWidget {
  const PowerFlowCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Power Flow',
            subtitle: 'Live energy routing',
          ),
          const SizedBox(height: 24),
          _PowerFlowDiagram(),
        ],
      ),
    );
  }
}

class _PowerFlowDiagram extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CustomPaint(
        painter: _FlowPainter(),
        child: const Stack(
          children: [
            Positioned(
              top: 8, left: 20,
              child: _FlowNode(
                icon: Icons.wb_sunny_rounded,
                label: 'Solar Panels',
                value: '3.2 kW',
                color: AppColors.tertiary,
              ),
            ),
            Positioned(
              top: 8, right: 20,
              child: _FlowNode(
                icon: Icons.battery_charging_full_rounded,
                label: 'Battery',
                value: '8.4 kWh',
                color: AppColors.secondary,
              ),
            ),
            Positioned(
              bottom: 8, left: 20,
              child: _FlowNode(
                icon: Icons.home_rounded,
                label: 'Home Load',
                value: '1.8 kW',
                color: AppColors.primary,
              ),
            ),
            Positioned(
              bottom: 8, right: 20,
              child: _FlowNode(
                icon: Icons.electric_meter_rounded,
                label: 'Public Grid',
                value: '0.0 kW',
                color: AppColors.onSurfaceVariant,
                badge: 'Idle',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlowNode extends StatelessWidget {
  const _FlowNode({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.badge,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 6),
        Text(label, style: tt.labelSmall),
        Text(
          value,
          style: tt.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (badge != null)
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(badge!, style: tt.labelSmall),
          ),
      ],
    );
  }
}

class _FlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.15)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height / 2;

    _drawDashed(canvas, Offset(cx, cy), const Offset(80, 50), paint);
    _drawDashed(canvas, Offset(cx, cy), Offset(size.width - 80, 50), paint);
    _drawDashed(canvas, Offset(cx, cy), Offset(80, size.height - 50), paint);
    _drawDashed(canvas, Offset(cx, cy), Offset(size.width - 80, size.height - 50), paint);

    canvas.drawCircle(
      Offset(cx, cy), 5,
      Paint()
        ..color = AppColors.secondary
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(Offset(cx, cy), 3, Paint()..color = AppColors.secondary);
  }

  void _drawDashed(Canvas canvas, Offset from, Offset to, Paint paint) {
    final delta = to - from;
    final length = delta.distance;
    const dashLen = 6.0;
    const gapLen = 4.0;
    final unit = delta / length;
    var pos = 0.0;
    while (pos < length) {
      final end = math.min(pos + dashLen, length);
      canvas.drawLine(from + unit * pos, from + unit * end, paint);
      pos += dashLen + gapLen;
    }
  }

  @override
  bool shouldRepaint(_FlowPainter old) => false;
}
