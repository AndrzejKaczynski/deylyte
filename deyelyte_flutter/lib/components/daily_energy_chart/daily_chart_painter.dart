import 'dart:math' as math;
import 'package:flutter/material.dart' hide Path;
import 'package:flutter/material.dart' as material show Path;
import '../../theme/theme.dart';
import 'hour_data.dart';

// ─── Price colour helpers ─────────────────────────────────────────────────────

Color priceColor(double price) {
  if (price <= 0) return AppColors.secondary;
  if (price < 0.7) return AppColors.primary;
  if (price < 1.0) return AppColors.tertiary;
  return AppColors.error;
}

Color sellPriceColor(double price) {
  if (price <= 0) return AppColors.error;
  if (price < 0.3) return AppColors.tertiary;
  if (price < 0.5) return AppColors.primary;
  return AppColors.secondary;
}

// ─── Path helpers ─────────────────────────────────────────────────────────────

/// Monotone cubic interpolation (Fritsch–Carlson). Smooth curves that never
/// overshoot between data points — ideal for noisy data like home load.
material.Path monotoneCubicPath(List<Offset> points) {
  if (points.isEmpty) return material.Path();
  if (points.length == 1) return material.Path()..moveTo(points[0].dx, points[0].dy);
  if (points.length == 2) {
    return material.Path()
      ..moveTo(points[0].dx, points[0].dy)
      ..lineTo(points[1].dx, points[1].dy);
  }

  final n = points.length;

  // 1. Compute slopes of secant lines.
  final dx = List<double>.filled(n - 1, 0);
  final dy = List<double>.filled(n - 1, 0);
  final slopes = List<double>.filled(n - 1, 0);
  for (var i = 0; i < n - 1; i++) {
    dx[i] = points[i + 1].dx - points[i].dx;
    dy[i] = points[i + 1].dy - points[i].dy;
    slopes[i] = dx[i] == 0 ? 0 : dy[i] / dx[i];
  }

  // 2. Compute tangent slopes at each point.
  final m = List<double>.filled(n, 0);
  m[0] = slopes[0];
  m[n - 1] = slopes[n - 2];
  for (var i = 1; i < n - 1; i++) {
    if (slopes[i - 1].sign != slopes[i].sign) {
      m[i] = 0;
    } else {
      m[i] = (slopes[i - 1] + slopes[i]) / 2;
    }
  }

  // 3. Fritsch–Carlson monotonicity correction.
  for (var i = 0; i < n - 1; i++) {
    if (slopes[i] == 0) {
      m[i] = 0;
      m[i + 1] = 0;
    } else {
      final alpha = m[i] / slopes[i];
      final beta = m[i + 1] / slopes[i];
      final s = alpha * alpha + beta * beta;
      if (s > 9) {
        final t = 3.0 / math.sqrt(s);
        m[i] = t * alpha * slopes[i];
        m[i + 1] = t * beta * slopes[i];
      }
    }
  }

  // 4. Build cubic bezier segments from Hermite tangents.
  final path = material.Path()..moveTo(points[0].dx, points[0].dy);
  for (var i = 0; i < n - 1; i++) {
    final third = dx[i] / 3;
    path.cubicTo(
      points[i].dx + third, points[i].dy + m[i] * third,
      points[i + 1].dx - third, points[i + 1].dy - m[i + 1] * third,
      points[i + 1].dx, points[i + 1].dy,
    );
  }
  return path;
}

/// Draws [path] as a dashed stroke on [canvas].
void drawDashedPath(
  Canvas canvas,
  material.Path path,
  Paint paint, {
  double dash = 8,
  double gap = 5,
}) {
  for (final metric in path.computeMetrics()) {
    var distance = 0.0;
    var drawing = true;
    while (distance < metric.length) {
      final len = drawing ? dash : gap;
      if (drawing) {
        canvas.drawPath(
          metric.extractPath(distance, (distance + len).clamp(0.0, metric.length)),
          paint,
        );
      }
      distance += len;
      drawing = !drawing;
    }
  }
}

// ─── Painter ─────────────────────────────────────────────────────────────────

class DailyPlanPainter extends CustomPainter {
  const DailyPlanPainter({
    required this.hours,
    required this.peak,
    required this.hoveredHour,
    required this.layers,
    this.nowHour,
    this.nowMinute,
    this.columnCount = 24,
  });

  final List<HourData> hours;
  final double peak;
  final int? hoveredHour;
  final Layers layers;
  /// When null the chart is in history mode: no NOW pill, all hours treated as actual.
  final int? nowHour;
  final int? nowMinute;
  /// Number of columns to render. 24 for a single-day view, N for an N-day aggregated view.
  final int columnCount;

  static const _topPad = 24.0;
  static const _priceGap = 8.0;
  static const _priceH = 58.0;
  static const _priceHalf = 25.0;
  static const _maxPriceRef = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final colW = size.width / columnCount;
    const chartTop = _topPad;
    final chartH = size.height - _topPad - _priceH;
    final chartBottom = chartTop + chartH;
    final priceZeroY = chartBottom + _priceGap + _priceHalf;

    // 1 ── Price sub-chart
    canvas.drawLine(
      Offset(0, chartBottom),
      Offset(size.width, chartBottom),
      Paint()
        ..color = AppColors.outlineVariant.withValues(alpha: 0.30)
        ..strokeWidth = 1,
    );
    canvas.drawLine(
      Offset(0, priceZeroY),
      Offset(size.width, priceZeroY),
      Paint()
        ..color = AppColors.outlineVariant
        ..strokeWidth = 1,
    );
    if (layers.showBuyPrice || layers.showSellPrice) {
      for (var i = 0; i < columnCount; i++) {
        if (layers.showBuyPrice) {
          final price = hours[i].buyPrice;
          if (price != null) {
            final barH = (price.abs() / _maxPriceRef).clamp(0.0, 1.0) * _priceHalf;
            final color = priceColor(price);
            final rect = price <= 0
                ? Rect.fromLTWH(i * colW + 2, priceZeroY, colW - 4, barH)
                : Rect.fromLTWH(i * colW + 2, priceZeroY - barH, colW - 4, barH);
            canvas.drawRRect(
              RRect.fromRectAndRadius(rect, const Radius.circular(2)),
              Paint()..color = color.withValues(alpha: 0.75),
            );
          }
        }
        if (layers.showSellPrice) {
          final sellPrice = hours[i].sellPrice;
          if (sellPrice != null && sellPrice > 0) {
            final sellBarH = (sellPrice / _maxPriceRef).clamp(0.0, 1.0) * _priceHalf;
            canvas.drawRRect(
              RRect.fromRectAndRadius(
                Rect.fromLTWH(i * colW + 2, priceZeroY, colW - 4, sellBarH),
                const Radius.circular(2),
              ),
              Paint()..color = sellPriceColor(sellPrice).withValues(alpha: 0.75),
            );
          }
        }
      }
    }

    // 2 ── Hover column highlight
    if (hoveredHour != null) {
      canvas.drawRect(
        Rect.fromLTWH(hoveredHour! * colW, 0, colW, size.height),
        Paint()..color = AppColors.primary.withValues(alpha: 0.08),
      );
    }

    // 3 ── Subtle horizontal grid lines
    final gridPaint = Paint()
      ..color = AppColors.outlineVariant.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    for (var i = 1; i <= 3; i++) {
      final y = chartTop + chartH * (1 - i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (peak > 0) {
      // 4 ── Home Load area
      if (layers.showLoad) {
        final loadPoints = <Offset>[];
        for (var i = 0; i < columnCount; i++) {
          final kw = hours[i].loadKw;
          if (kw == null) continue;
          final y = chartBottom - (kw / peak).clamp(0.0, 1.0) * chartH;
          loadPoints.add(Offset(i * colW + colW / 2, y));
        }
        if (loadPoints.isNotEmpty) {
          final loadCurve = monotoneCubicPath(loadPoints);
          final loadArea = material.Path.from(loadCurve)
            ..lineTo(loadPoints.last.dx, chartBottom)
            ..lineTo(loadPoints.first.dx, chartBottom)
            ..close();
          canvas.drawPath(
            loadArea,
            Paint()..color = AppColors.onSurfaceVariant.withValues(alpha: 0.22),
          );
        }
      }

      // 5 ── PV Estimate dashed curve (schedule mode only — skipped when nowHour is null)
      if (layers.showPvEstimate && nowHour != null) {
        final estPoints = <Offset>[];
        for (var i = 0; i < columnCount; i++) {
          final kw = (i == nowHour && hours[i].pvActualKw != null)
              ? hours[i].pvActualKw!
              : hours[i].pvKw;
          final y = chartBottom - (kw / peak).clamp(0.0, 1.0) * chartH;
          estPoints.add(Offset(i * colW + colW / 2, y));
        }
        final estCurve = monotoneCubicPath(estPoints);
        drawDashedPath(
          canvas,
          estCurve,
          Paint()
            ..color = AppColors.tertiary.withValues(alpha: 0.70)
            ..strokeWidth = 1.5
            ..style = PaintingStyle.stroke,
          dash: 7,
          gap: 5,
        );
      }

      // 6 ── PV Intake filled area
      // Schedule: up to current hour. History (nowHour == null): all 24 hours.
      if (layers.showPvIntake) {
        final intakeEnd = nowHour ?? (columnCount - 1);
        final intakePoints = <Offset>[];
        for (var i = 0; i <= intakeEnd; i++) {
          final kw = (nowHour != null && i == nowHour)
              ? (hours[i].pvActualKw ?? hours[i].pvKw)
              : hours[i].pvKw;
          final y = chartBottom - (kw / peak).clamp(0.0, 1.0) * chartH;
          intakePoints.add(Offset(i * colW + colW / 2, y));
        }
        if (intakePoints.isNotEmpty) {
          final intakeCurve = monotoneCubicPath(intakePoints);
          final intakeArea = material.Path.from(intakeCurve)
            ..lineTo(intakePoints.last.dx, chartBottom)
            ..lineTo(intakePoints.first.dx, chartBottom)
            ..close();
          canvas.drawPath(
            intakeArea,
            Paint()..color = AppColors.tertiary.withValues(alpha: 0.78),
          );
        }
      }
    }

    // 7 ── Battery SoC line with glow
    if (layers.showSoc) {
      final dots = <Offset>[];
      for (var i = 0; i < columnCount; i++) {
        final soc = hours[i].socPct;
        if (soc == null) continue;
        final x = i * colW + colW / 2;
        final y = chartTop + chartH * (1 - soc.clamp(0.0, 100.0) / 100.0);
        dots.add(Offset(x, y));
      }
      if (dots.isNotEmpty) {
        final path = monotoneCubicPath(dots);
        canvas.drawPath(
          path,
          Paint()
            ..color = AppColors.primary.withValues(alpha: 0.28)
            ..strokeWidth = 6
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );
        canvas.drawPath(
          path,
          Paint()
            ..color = AppColors.primary
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round,
        );
        final dotPaint = Paint()..color = AppColors.primary;
        for (final d in dots) {
          canvas.drawCircle(d, 2.5, dotPaint);
        }
      }
    }

    // 8 ── "NOW" pill + vertical line (schedule mode only)
    if (nowHour != null && nowMinute != null) {
      final nowFraction = (nowHour! + nowMinute! / 60.0) / 24.0;
      final nowX = nowFraction * size.width;
      final label =
          'NOW ${nowHour.toString().padLeft(2, '0')}:${nowMinute.toString().padLeft(2, '0')}';
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      const pillH = 16.0;
      final pillW = tp.width + 10;
      final pillX = (nowX - pillW / 2).clamp(0.0, size.width - pillW);
      canvas.drawLine(
        Offset(nowX, pillH),
        Offset(nowX, size.height),
        Paint()
          ..color = AppColors.secondary
          ..strokeWidth = 1.5,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(pillX, 0, pillW, pillH), const Radius.circular(4)),
        Paint()..color = AppColors.secondary,
      );
      tp.paint(canvas, Offset(pillX + 5, (pillH - tp.height) / 2));
    }
  }

  @override
  bool shouldRepaint(DailyPlanPainter old) =>
      old.hours != hours ||
      old.hoveredHour != hoveredHour ||
      old.peak != peak ||
      old.nowHour != nowHour ||
      old.nowMinute != nowMinute ||
      old.columnCount != columnCount ||
      old.layers.showPvIntake != layers.showPvIntake ||
      old.layers.showPvEstimate != layers.showPvEstimate ||
      old.layers.showLoad != layers.showLoad ||
      old.layers.showSoc != layers.showSoc ||
      old.layers.showBuyPrice != layers.showBuyPrice ||
      old.layers.showSellPrice != layers.showSellPrice ||
      old.layers.showPlan != layers.showPlan;
}
