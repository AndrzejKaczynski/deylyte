import 'package:deyelyte_client/deyelyte_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../providers/app_providers.dart';

// ─── Data model ──────────────────────────────────────────────────────────────

class _HourData {
  const _HourData({
    required this.hour,
    required this.pvKw,
    required this.pvIsActual,
    this.buyPrice,
    this.sellPrice,
    this.socPct,
    this.command,
  });
  final int hour; // 0-23 local time
  final double pvKw; // kW — actual measurement for past hours, forecast for future
  final bool pvIsActual; // true = measured telemetry, false = forecast estimate
  final double? buyPrice; // PLN/kWh
  final double? sellPrice;
  final double? socPct; // 0-100
  final String? command; // 'charge' | 'discharge' | 'idle' | null
}

// ─── Layer visibility state ───────────────────────────────────────────────────

class _Layers {
  bool showPv = true;
  bool showSoc = true;
  bool showPrice = true;
  bool showPlan = true;
}

// ─── Widget ───────────────────────────────────────────────────────────────────

class ForecastBarCard extends ConsumerStatefulWidget {
  const ForecastBarCard({super.key});

  @override
  ConsumerState<ForecastBarCard> createState() => _ForecastBarCardState();
}

class _ForecastBarCardState extends ConsumerState<ForecastBarCard> {
  final _layers = _Layers();
  int? _hoveredHour;

  // ── Data aggregation ───────────────────────────────────────────────────────

  List<_HourData> _buildHours(
    List<PvForecast> forecast,
    List<EnergyPrice> prices,
    List<OptimizationFrame> frames,
    List<DeviceTelemetry> telemetry,
  ) {
    final now = DateTime.now().toLocal();
    final nowHour = now.hour;

    // Actual PV from telemetry: average pvPowerW per local hour for today.
    // Used for completed hours (h < nowHour).
    final actualPvSum = List<double>.filled(24, 0);
    final actualPvCount = List<int>.filled(24, 0);
    for (final t in telemetry) {
      final lt = t.timestamp.toLocal();
      if (lt.year == now.year && lt.month == now.month && lt.day == now.day) {
        actualPvSum[lt.hour] += t.pvPowerW;
        actualPvCount[lt.hour]++;
      }
    }

    // Forecast PV: average W per local hour for today.
    // Used for current + future hours (h >= nowHour).
    final forecastPvSum = List<double>.filled(24, 0);
    final forecastPvCount = List<int>.filled(24, 0);
    for (final r in forecast) {
      final t = r.timestamp.toLocal();
      if (t.year == now.year && t.month == now.month && t.day == now.day) {
        forecastPvSum[t.hour] += r.expectedYieldWatts;
        forecastPvCount[t.hour]++;
      }
    }

    // Prices: keyed by local hour
    final priceByHour = <int, EnergyPrice>{};
    for (final p in prices) {
      priceByHour[p.timestamp.toLocal().hour] = p;
    }

    // Schedule frames: keyed by local hour
    final frameByHour = <int, OptimizationFrame>{};
    for (final f in frames) {
      frameByHour[f.hour.toLocal().hour] = f;
    }

    return List.generate(24, (h) {
      final isActual = h < nowHour;
      final double pvKw;
      if (isActual && actualPvCount[h] > 0) {
        pvKw = (actualPvSum[h] / actualPvCount[h] / 1000.0).clamp(0.0, double.infinity);
      } else if (!isActual && forecastPvCount[h] > 0) {
        pvKw = forecastPvSum[h] / forecastPvCount[h] / 1000.0;
      } else {
        pvKw = 0.0;
      }
      final price = priceByHour[h];
      final frame = frameByHour[h];
      return _HourData(
        hour: h,
        pvKw: pvKw,
        pvIsActual: isActual,
        buyPrice: price?.buyPrice,
        sellPrice: price?.sellPrice,
        socPct: frame?.estimatedSocAtStart,
        command: frame?.command,
      );
    });
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final forecastAsync = ref.watch(pvForecastProvider);
    final pricesAsync = ref.watch(todayPricesProvider);
    final framesAsync = ref.watch(todayScheduleProvider);
    final telemetryAsync = ref.watch(telemetryHistory24hProvider);
    final tt = Theme.of(context).textTheme;

    final isLoading = forecastAsync.isLoading ||
        pricesAsync.isLoading ||
        framesAsync.isLoading;
    final hasError = forecastAsync.hasError ||
        pricesAsync.hasError ||
        framesAsync.hasError;

    final forecast = forecastAsync.valueOrNull ?? [];
    final prices = pricesAsync.valueOrNull ?? [];
    final frames = framesAsync.valueOrNull ?? [];
    final telemetry = telemetryAsync.valueOrNull ?? [];

    final hours = _buildHours(forecast, prices, frames, telemetry);
    final peak = hours.fold(0.0, (m, h) => h.pvKw > m ? h.pvKw : m);

    // Today's total PV estimate (kWh) across all 30-min periods
    final now = DateTime.now().toLocal();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final tomorrowMidnight = todayMidnight.add(const Duration(days: 1));
    final todayForecastKwh = forecast.fold(0.0, (sum, r) {
      final t = r.timestamp.toLocal();
      if (t.isBefore(todayMidnight) || !t.isBefore(tomorrowMidnight)) {
        return sum;
      }
      return sum + r.expectedYieldWatts * 0.5 / 1000;
    });

    final nowHour = now.hour;
    final hoveredData = _hoveredHour != null ? hours[_hoveredHour!] : null;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ─────────────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Today's Plan", style: tt.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      'Scheduler input & plan overview',
                      style: tt.bodySmall,
                    ),
                  ],
                ),
              ),
              if (todayForecastKwh > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.wb_sunny_rounded,
                        size: 12, color: AppColors.tertiary),
                    const SizedBox(width: 4),
                    Text(
                      '${todayForecastKwh.toStringAsFixed(1)} kWh est.',
                      style: tt.labelSmall?.copyWith(
                        color: AppColors.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Loading / Error ────────────────────────────────────────────────
          if (isLoading)
            const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (hasError)
            const SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  'Could not load plan data',
                  style: TextStyle(color: AppColors.onSurfaceVariant),
                ),
              ),
            )
          else ...[
            // ── Chart ──────────────────────────────────────────────────────
            LayoutBuilder(builder: (context, constraints) {
              final colW = constraints.maxWidth / 24;
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                onHover: (e) {
                  final h =
                      (e.localPosition.dx / colW).floor().clamp(0, 23);
                  if (_hoveredHour != h) setState(() => _hoveredHour = h);
                },
                onExit: (_) => setState(() => _hoveredHour = null),
                child: GestureDetector(
                  onTapDown: (e) {
                    final h =
                        (e.localPosition.dx / colW).floor().clamp(0, 23);
                    setState(() =>
                        _hoveredHour = _hoveredHour == h ? null : h);
                  },
                  child: SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: _DailyPlanPainter(
                        hours: hours,
                        peak: peak,
                        hoveredHour: _hoveredHour,
                        nowHour: nowHour,
                        layers: _layers,
                      ),
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 4),

            // ── Hour labels ────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final h = (i * 4) % 24;
                return Text(
                  '${h.toString().padLeft(2, '0')}:00',
                  style: tt.labelSmall
                      ?.copyWith(color: AppColors.onSurfaceVariant),
                );
              }),
            ),

            // ── Tooltip ────────────────────────────────────────────────────
            AnimatedSize(
              duration: const Duration(milliseconds: 150),
              child: hoveredData == null
                  ? const SizedBox(height: 8)
                  : Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: AppRadius.radiusMd,
                        ),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 4,
                          children: [
                            _TipChip(
                              label:
                                  '${hoveredData.hour.toString().padLeft(2, '0')}:00',
                              color: AppColors.onSurface,
                            ),
                            if (_layers.showPv)
                              _TipChip(
                                label: hoveredData.pvKw > 0
                                    ? '${hoveredData.pvKw.toStringAsFixed(2)} kW '
                                        '${hoveredData.pvIsActual ? 'solar (actual)' : 'solar (est.)'}'
                                    : 'No solar',
                                color: AppColors.tertiary,
                              ),
                            if (_layers.showPrice &&
                                hoveredData.buyPrice != null)
                              _TipChip(
                                label:
                                    'Buy ${hoveredData.buyPrice!.toStringAsFixed(2)} PLN/kWh',
                                color: _priceColor(hoveredData.buyPrice!),
                              ),
                            if (_layers.showSoc &&
                                hoveredData.socPct != null)
                              _TipChip(
                                label:
                                    '${hoveredData.socPct!.toStringAsFixed(0)}% SoC',
                                color: AppColors.primary,
                              ),
                            if (_layers.showPlan &&
                                hoveredData.command != null)
                              _TipChip(
                                label: hoveredData.command!,
                                color: hoveredData.command == 'charge'
                                    ? AppColors.secondary
                                    : hoveredData.command == 'discharge'
                                        ? AppColors.error
                                        : AppColors.onSurfaceVariant,
                              ),
                          ],
                        ),
                      ),
                    ),
            ),

            const SizedBox(height: 12),

            // ── Legend toggles ─────────────────────────────────────────────
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Tooltip(
                  message: 'Measured solar intake for past hours;\nPV forecast for current and future hours',
                  child: _LayerChip(
                    label: 'Solar Output',
                    color: AppColors.tertiary,
                    active: _layers.showPv,
                    onTap: () =>
                        setState(() => _layers.showPv = !_layers.showPv),
                  ),
                ),
                Tooltip(
                  message: 'Estimated battery state of charge\nat the start of each hour',
                  child: _LayerChip(
                    label: 'Battery SoC',
                    color: AppColors.primary,
                    active: _layers.showSoc,
                    onTap: () =>
                        setState(() => _layers.showSoc = !_layers.showSoc),
                  ),
                ),
                Tooltip(
                  message: 'Buy price per kWh — bars above the line are positive prices,\nbars below are zero or negative (grid pays you)',
                  child: _LayerChip(
                    label: 'Price Tier',
                    color: AppColors.secondary,
                    active: _layers.showPrice,
                    onTap: () => setState(
                        () => _layers.showPrice = !_layers.showPrice),
                  ),
                ),
                Tooltip(
                  message: 'Optimizer command per hour:\ngreen = charge battery, red = discharge, grey = idle',
                  child: _LayerChip(
                    label: 'Charge Plan',
                    color: AppColors.error,
                    active: _layers.showPlan,
                    onTap: () => setState(
                        () => _layers.showPlan = !_layers.showPlan),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Tooltip chip ─────────────────────────────────────────────────────────────

class _TipChip extends StatelessWidget {
  const _TipChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 5),
      Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    ]);
  }
}

// ─── Legend toggle chip ───────────────────────────────────────────────────────

class _LayerChip extends StatelessWidget {
  const _LayerChip({
    required this.label,
    required this.color,
    required this.active,
    required this.onTap,
  });
  final String label;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return GestureDetector(
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
            color: active
                ? color.withValues(alpha: 0.35)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: active ? color : AppColors.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
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
  }
}

// ─── Price colour helper ──────────────────────────────────────────────────────

Color _priceColor(double price) {
  if (price <= 0) return AppColors.secondary;
  if (price < 0.7) return AppColors.primary;
  if (price < 1.0) return AppColors.tertiary;
  return AppColors.error;
}

// ─── Painter ─────────────────────────────────────────────────────────────────

class _DailyPlanPainter extends CustomPainter {
  const _DailyPlanPainter({
    required this.hours,
    required this.peak,
    required this.hoveredHour,
    required this.nowHour,
    required this.layers,
  });

  final List<_HourData> hours;
  final double peak;
  final int? hoveredHour;
  final int nowHour;
  final _Layers layers;

  static const _n = 24;
  static const _stripH = 10.0;
  static const _stripGap = 4.0;
  static const _priceH = 40.0;
  static const _priceHalf = 20.0;
  static const _maxPriceRef = 1.5; // PLN/kWh — full-bar reference

  @override
  void paint(Canvas canvas, Size size) {
    final colW = size.width / _n;
    // Layout: [chartH] [priceH=40] [stripGap=4] [stripH=10]
    final chartH = size.height - _priceH - _stripGap - _stripH;
    final priceZeroY = chartH + _priceHalf;

    // 1 ── Price sub-chart
    if (layers.showPrice) {
      // Zero baseline
      canvas.drawLine(
        Offset(0, priceZeroY),
        Offset(size.width, priceZeroY),
        Paint()
          ..color = AppColors.outlineVariant
          ..strokeWidth = 1,
      );
      for (var i = 0; i < _n; i++) {
        final price = hours[i].buyPrice;
        if (price == null) continue;
        final barH = (price.abs() / _maxPriceRef).clamp(0.0, 1.0) * _priceHalf;
        final color = _priceColor(price);
        final rect = price <= 0
            // Negative / free: bar goes downward from baseline
            ? Rect.fromLTWH(i * colW + 2, priceZeroY, colW - 4, barH)
            // Positive: bar goes upward from baseline
            : Rect.fromLTWH(i * colW + 2, priceZeroY - barH, colW - 4, barH);
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(2)),
          Paint()..color = color.withValues(alpha: 0.75),
        );
      }
    }

    // 2 ── Hover column highlight
    if (hoveredHour != null) {
      canvas.drawRect(
        Rect.fromLTWH(hoveredHour! * colW, 0, colW, chartH + _priceH),
        Paint()..color = AppColors.primary.withValues(alpha: 0.08),
      );
    }

    // 3 ── Subtle grid lines
    final gridPaint = Paint()
      ..color = AppColors.outlineVariant.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    for (var i = 1; i <= 3; i++) {
      final y = chartH * (1 - i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 4 ── PV bars: solid amber = actual telemetry, lighter = forecast
    if (layers.showPv && peak > 0) {
      final actualPaint = Paint()..color = AppColors.tertiary.withValues(alpha: 0.90);
      final forecastPaint = Paint()..color = AppColors.tertiary.withValues(alpha: 0.45);
      for (var i = 0; i < _n; i++) {
        final kw = hours[i].pvKw;
        if (kw <= 0) continue;
        final barH = (kw / peak).clamp(0.0, 1.0) * chartH;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(i * colW + 2, chartH - barH, colW - 4, barH),
            const Radius.circular(3),
          ),
          hours[i].pvIsActual ? actualPaint : forecastPaint,
        );
      }
    }

    // 5 ── Battery SoC line with glow
    if (layers.showSoc) {
      final path = Path();
      bool started = false;
      final dots = <Offset>[];
      for (var i = 0; i < _n; i++) {
        final soc = hours[i].socPct;
        if (soc == null) continue;
        final x = i * colW + colW / 2;
        final y = chartH * (1 - soc.clamp(0.0, 100.0) / 100.0);
        dots.add(Offset(x, y));
        if (!started) {
          path.moveTo(x, y);
          started = true;
        } else {
          path.lineTo(x, y);
        }
      }
      if (started) {
        // Glow pass
        canvas.drawPath(
          path,
          Paint()
            ..color = AppColors.primary.withValues(alpha: 0.28)
            ..strokeWidth = 6
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );
        // Main line
        canvas.drawPath(
          path,
          Paint()
            ..color = AppColors.primary
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round,
        );
        // Dots at each data point
        final dotPaint = Paint()..color = AppColors.primary;
        for (final d in dots) {
          canvas.drawCircle(d, 2.5, dotPaint);
        }
      }
    }

    // 6 ── Command strip
    if (layers.showPlan) {
      final stripTop = chartH + _priceH + _stripGap;
      for (var i = 0; i < _n; i++) {
        final cmd = hours[i].command;
        final Color c;
        if (cmd == 'charge') {
          c = AppColors.secondary.withValues(alpha: 0.85);
        } else if (cmd == 'discharge') {
          c = AppColors.error.withValues(alpha: 0.75);
        } else {
          c = AppColors.outlineVariant.withValues(alpha: 0.35);
        }
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(i * colW + 1, stripTop, colW - 2, _stripH),
            const Radius.circular(2),
          ),
          Paint()..color = c,
        );
      }
    }

    // 7 ── "Now" dashed vertical marker
    final nowX = nowHour * colW + colW / 2;
    final nowPaint = Paint()
      ..color = AppColors.onSurface.withValues(alpha: 0.35)
      ..strokeWidth = 1;
    var dashY = 0.0;
    while (dashY < chartH) {
      final end = (dashY + 4.0).clamp(0.0, chartH);
      canvas.drawLine(Offset(nowX, dashY), Offset(nowX, end), nowPaint);
      dashY += 7.0;
    }
  }

  @override
  bool shouldRepaint(_DailyPlanPainter old) =>
      old.hours != hours ||
      old.hoveredHour != hoveredHour ||
      old.peak != peak ||
      old.nowHour != nowHour ||
      old.layers.showPv != layers.showPv ||
      old.layers.showSoc != layers.showSoc ||
      old.layers.showPrice != layers.showPrice ||
      old.layers.showPlan != layers.showPlan;
}
