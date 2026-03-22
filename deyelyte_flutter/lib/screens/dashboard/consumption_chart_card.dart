import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';

class ConsumptionChartCard extends StatelessWidget {
  const ConsumptionChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Consumption Trends',
            subtitle: 'Last 24 hours',
            actionLabel: 'View History',
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: CustomPaint(
              painter: _SparklinePainter(),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              _ChartLegendDot(color: AppColors.primary, label: 'Consumption'),
              SizedBox(width: 20),
              _ChartLegendDot(color: AppColors.secondary, label: 'Solar'),
              SizedBox(width: 20),
              _ChartLegendDot(color: AppColors.tertiary, label: 'Grid import'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartLegendDot extends StatelessWidget {
  const _ChartLegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: AppColors.outline)),
      ],
    );
  }
}

class _SparklinePainter extends CustomPainter {
  static const _consumption = [
    0.4, 0.5, 0.45, 0.6, 0.7, 0.65, 0.55, 0.5, 0.6, 0.75,
    0.8, 0.7, 0.6, 0.5, 0.55, 0.6, 0.7, 0.8, 0.85, 0.7, 0.6, 0.5, 0.4, 0.35,
  ];
  static const _solar = [
    0.0, 0.0, 0.0, 0.0, 0.0, 0.05, 0.15, 0.3, 0.5, 0.65,
    0.75, 0.8, 0.85, 0.8, 0.75, 0.6, 0.4, 0.2, 0.1, 0.05, 0.0, 0.0, 0.0, 0.0,
  ];

  void _drawLine(Canvas canvas, Size size, List<double> data, Color color) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    for (var i = 0; i < data.length; i++) {
      final x = i / (data.length - 1) * w;
      final y = h - data[i] * h * 0.9 - 4;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.25)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    final fill = Path.from(path)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.0)],
        ).createShader(Rect.fromLTWH(0, 0, w, h))
        ..style = PaintingStyle.fill,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.outlineVariant.withValues(alpha: 0.10)
      ..strokeWidth = 1;
    for (var i = 1; i < 4; i++) {
      final y = size.height / 4 * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    _drawLine(canvas, size, _consumption, AppColors.primary);
    _drawLine(canvas, size, _solar, AppColors.secondary);
  }

  @override
  bool shouldRepaint(_SparklinePainter old) => false;
}
