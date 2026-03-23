import 'package:deyelyte_client/deyelyte_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../providers/app_providers.dart';

class ForecastBarCard extends ConsumerWidget {
  const ForecastBarCard({super.key});

  /// Aggregates 30-min PvForecast rows into hourly average kW values.
  /// Returns a list of 24 entries, one per hour starting from the current hour.
  static List<double> _toHourlyKw(List<PvForecast> rows) {
    final now = DateTime.now();
    final startHour = DateTime(now.year, now.month, now.day, now.hour);
    final hours = List.generate(24, (i) => startHour.add(Duration(hours: i)));

    return hours.map((h) {
      final end = h.add(const Duration(hours: 1));
      final inHour = rows.where((r) {
        final t = r.timestamp.toLocal();
        return !t.isBefore(h) && t.isBefore(end);
      }).toList();
      if (inHour.isEmpty) return 0.0;
      final avgW = inHour.map((r) => r.expectedYieldWatts).reduce((a, b) => a + b) /
          inHour.length;
      return avgW / 1000.0; // W → kW
    }).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastAsync = ref.watch(pvForecastProvider);

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'PV Generation Forecast',
            subtitle: 'Expected solar output — next 24 hours',
          ),
          const SizedBox(height: 20),
          forecastAsync.when(
            loading: () => const SizedBox(
              height: 140,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox(
              height: 140,
              child: Center(
                child: Text('Could not load forecast',
                    style: TextStyle(color: AppColors.onSurfaceVariant)),
              ),
            ),
            data: (rows) {
              final hourlyKw = _toHourlyKw(rows);
              final peak = hourlyKw.fold(0.0, (m, v) => v > m ? v : m);
              if (peak == 0) {
                return const SizedBox(
                  height: 140,
                  child: Center(
                    child: Text('No forecast data yet',
                        style: TextStyle(color: AppColors.onSurfaceVariant)),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 120,
                    child: CustomPaint(
                      painter: _PvBarPainter(hourlyKw, peak),
                      size: Size.infinite,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (i) {
                      final h = (DateTime.now().hour + i * 4) % 24;
                      return Text(
                        '${h.toString().padLeft(2, '0')}:00',
                        style: Theme.of(context).textTheme.labelSmall,
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    Text(
                      'Peak  ${peak.toStringAsFixed(1)} kW',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.tertiary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ]),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PvBarPainter extends CustomPainter {
  const _PvBarPainter(this.hourlyKw, this.peak);
  final List<double> hourlyKw;
  final double peak;

  @override
  void paint(Canvas canvas, Size size) {
    final n = hourlyKw.length;
    final barW = size.width / n;
    const barPad = 2.0;

    final gridPaint = Paint()
      ..color = AppColors.outlineVariant.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    for (var i = 1; i <= 3; i++) {
      final y = size.height * (1 - i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    for (var i = 0; i < n; i++) {
      final ratio = peak > 0 ? (hourlyKw[i] / peak).clamp(0.0, 1.0) : 0.0;
      if (ratio == 0) continue;
      final barH = ratio * size.height;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
            i * barW + barPad, size.height - barH, barW - barPad * 2, barH),
        const Radius.circular(3),
      );
      canvas.drawRRect(
        rect,
        Paint()..color = AppColors.tertiary.withValues(alpha: 0.70),
      );
    }
  }

  @override
  bool shouldRepaint(_PvBarPainter old) => old.hourlyKw != hourlyKw;
}
