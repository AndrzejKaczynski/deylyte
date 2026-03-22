import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';

class ForecastBarCard extends StatelessWidget {
  const ForecastBarCard({super.key});

  static const _priceTiers = [
    0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 2, 2,
    2, 2, 1, 1, 2, 2, 2, 1, 1, 0, 0, 0,
  ];
  static const _soc = [
    0.5, 0.55, 0.62, 0.70, 0.75, 0.80, 0.82, 0.84, 0.84, 0.80, 0.75, 0.70,
    0.65, 0.60, 0.55, 0.52, 0.48, 0.44, 0.40, 0.45, 0.50, 0.55, 0.52, 0.50,
  ];
  static const _colors = [
    AppColors.secondary,
    AppColors.tertiary,
    AppColors.error,
  ];

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: '24-Hour Forecast',
            subtitle: 'Price tiers & battery SoC projection',
          ),
          const SizedBox(height: 8),
          const Row(children: [
            _Legend(color: AppColors.secondary, label: 'Off-peak (charge)'),
            SizedBox(width: 16),
            _Legend(color: AppColors.tertiary, label: 'Mid'),
            SizedBox(width: 16),
            _Legend(color: AppColors.error, label: 'Peak (discharge)'),
          ]),
          const SizedBox(height: 20),
          const SizedBox(
            height: 160,
            child: CustomPaint(
              painter: _ForecastPainter(_priceTiers, _soc, _colors),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final h = i * 4;
              return Text('${h.toString().padLeft(2, '0')}:00',
                  style: tt.labelSmall);
            }),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 10, height: 10,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
      ),
      const SizedBox(width: 4),
      Text(label, style: Theme.of(context).textTheme.labelSmall),
    ]);
  }
}

class _ForecastPainter extends CustomPainter {
  const _ForecastPainter(this.tiers, this.soc, this.colors);
  final List<int> tiers;
  final List<double> soc;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final n = tiers.length;
    final barW = size.width / n;
    const barMaxH = 100.0;
    const barY = 10.0;
    final gridPaint = Paint()
      ..color = AppColors.outlineVariant.withValues(alpha: 0.10)
      ..strokeWidth = 1;

    for (var i = 1; i <= 4; i++) {
      final y = barY + barMaxH / 4 * (4 - i);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    for (var i = 0; i < n; i++) {
      final tier = tiers[i];
      const barH = 80.0;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(i * barW + 2, barY + barMaxH - barH + (2 - tier) * 22,
            barW - 4, barH - (2 - tier) * 22),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, Paint()..color = colors[tier].withValues(alpha: 0.30));
    }

    final socPath = Path();
    for (var i = 0; i < soc.length; i++) {
      final x = (i + 0.5) * barW;
      final y = barY + barMaxH - soc[i] * barMaxH;
      i == 0 ? socPath.moveTo(x, y) : socPath.lineTo(x, y);
    }
    canvas.drawPath(
      socPath,
      Paint()
        ..color = AppColors.primary.withValues(alpha: 0.3)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawPath(
      socPath,
      Paint()
        ..color = AppColors.primary
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    const top = barY;
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '── Battery SoC',
        style: TextStyle(fontSize: 10, color: AppColors.primary, fontFamily: 'Inter'),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, const Offset(4, top));
  }

  @override
  bool shouldRepaint(_ForecastPainter old) => false;
}
