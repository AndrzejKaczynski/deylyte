import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';

class MarketArbitrageChart extends StatelessWidget {
  const MarketArbitrageChart({super.key});

  static const _buyPressure = [
    0.3, 0.25, 0.2, 0.18, 0.22, 0.4, 0.6, 0.75, 0.85, 0.9,
    0.88, 0.85, 0.7, 0.6, 0.55, 0.65, 0.8, 0.9, 0.95, 0.75,
    0.5, 0.35, 0.28, 0.25,
  ];
  static const _batteryCap = [
    0.5, 0.55, 0.62, 0.70, 0.75, 0.80, 0.82, 0.84, 0.82, 0.78,
    0.72, 0.66, 0.60, 0.55, 0.50, 0.52, 0.56, 0.48, 0.40, 0.45,
    0.52, 0.56, 0.54, 0.50,
  ];

  @override
  Widget build(BuildContext context) {
    return const SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SectionHeader(
          title: 'Market Arbitrage & Storage',
          subtitle: 'Real-time buy/sell pressure vs battery capacity',
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: CustomPaint(
            painter: _DoubleLineChart(
              series1: _buyPressure,
              color1: AppColors.error,
              label1: 'Buy pressure',
              series2: _batteryCap,
              color2: AppColors.secondary,
              label2: 'Battery SoC',
            ),
            size: Size.infinite,
          ),
        ),
        SizedBox(height: 12),
        Row(children: [
          _ChartKey(color: AppColors.error, label: 'Buy pressure'),
          SizedBox(width: 20),
          _ChartKey(color: AppColors.secondary, label: 'Battery SoC'),
        ]),
      ]),
    );
  }
}

class YieldVsExpenditureChart extends StatelessWidget {
  const YieldVsExpenditureChart({super.key});

  static const _yield = [
    0.3, 0.35, 0.4, 0.45, 0.5, 0.6, 0.65, 0.7, 0.72, 0.75,
    0.78, 0.80, 0.82, 0.80, 0.78, 0.75, 0.72, 0.70, 0.65, 0.60,
    0.55, 0.50, 0.45, 0.40, 0.38, 0.42, 0.46, 0.50, 0.55, 0.60,
  ];
  static const _expenditure = [
    0.5, 0.45, 0.4, 0.38, 0.35, 0.3, 0.28, 0.25, 0.22, 0.20,
    0.18, 0.20, 0.22, 0.25, 0.28, 0.30, 0.32, 0.35, 0.38, 0.40,
    0.42, 0.45, 0.48, 0.50, 0.48, 0.45, 0.42, 0.40, 0.38, 0.35,
  ];

  @override
  Widget build(BuildContext context) {
    return const SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SectionHeader(
          title: 'Yield vs Expenditure',
          subtitle: 'Net balance over historical cycle',
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: CustomPaint(
            painter: _DoubleLineChart(
              series1: _yield,
              color1: AppColors.secondary,
              label1: 'Yield',
              series2: _expenditure,
              color2: AppColors.error,
              label2: 'Expenditure',
            ),
            size: Size.infinite,
          ),
        ),
        SizedBox(height: 12),
        Row(children: [
          _ChartKey(color: AppColors.secondary, label: 'Yield'),
          SizedBox(width: 20),
          _ChartKey(color: AppColors.error, label: 'Expenditure'),
        ]),
      ]),
    );
  }
}

class _ChartKey extends StatelessWidget {
  const _ChartKey({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 16, height: 2, color: color),
      const SizedBox(width: 6),
      Text(label, style: Theme.of(context).textTheme.labelSmall),
    ]);
  }
}

class _DoubleLineChart extends CustomPainter {
  const _DoubleLineChart({
    required this.series1,
    required this.color1,
    required this.label1,
    required this.series2,
    required this.color2,
    required this.label2,
  });

  final List<double> series1;
  final Color color1;
  final String label1;
  final List<double> series2;
  final Color color2;
  final String label2;

  void _drawSeries(Canvas canvas, Size size, List<double> data, Color color) {
    final w = size.width;
    final h = size.height - 8;
    final path = Path();
    for (var i = 0; i < data.length; i++) {
      final x = i / (data.length - 1) * w;
      final y = 4 + (1 - data[i]) * h;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.25)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
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
      ..lineTo(w, h + 4)
      ..lineTo(0, h + 4)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.0)],
        ).createShader(Rect.fromLTWH(0, 0, w, h))
        ..style = PaintingStyle.fill,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.outlineVariant.withValues(alpha: 0.10)
      ..strokeWidth = 1;
    for (var i = 1; i <= 4; i++) {
      final y = size.height / 4 * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    _drawSeries(canvas, size, series1, color1);
    _drawSeries(canvas, size, series2, color2);
  }

  @override
  bool shouldRepaint(_DoubleLineChart old) => false;
}
