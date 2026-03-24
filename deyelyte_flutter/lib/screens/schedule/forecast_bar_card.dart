import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../providers/app_providers.dart';
import 'forecast_hour_data.dart';
import 'forecast_painter.dart';
import 'forecast_hover_card.dart';
import 'forecast_command_strip.dart';
import 'forecast_layer_chip.dart';

class ForecastBarCard extends ConsumerStatefulWidget {
  const ForecastBarCard({super.key});

  @override
  ConsumerState<ForecastBarCard> createState() => _ForecastBarCardState();
}

class _ForecastBarCardState extends ConsumerState<ForecastBarCard> {
  final _layers = Layers();
  int? _hoveredHour;

  @override
  Widget build(BuildContext context) {
    final forecastAsync = ref.watch(pvForecastProvider);
    final pricesAsync = ref.watch(todayPricesProvider);
    final framesAsync = ref.watch(todayScheduleProvider);
    final telemetryAsync = ref.watch(telemetryHistory24hProvider);
    final tt = Theme.of(context).textTheme;

    final isLoading = forecastAsync.isLoading || pricesAsync.isLoading || framesAsync.isLoading;
    final hasError = forecastAsync.hasError || pricesAsync.hasError || framesAsync.hasError;

    final hours = HourData.buildHours(
      forecastAsync.valueOrNull ?? [],
      pricesAsync.valueOrNull ?? [],
      framesAsync.valueOrNull ?? [],
      telemetryAsync.valueOrNull ?? [],
    );

    final peak = hours.fold(0.0, (m, h) {
      final pv = max(h.pvKw, h.pvActualKw ?? 0.0);
      final load = h.loadKw ?? 0.0;
      return max(m, max(pv, load));
    });

    final now = DateTime.now().toLocal();
    final nowHour = now.hour;
    final nowMinute = now.minute;
    final hoveredData = _hoveredHour != null ? hours[_hoveredHour!] : null;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────────
          Text("Today's Plan", style: tt.headlineSmall),
          const SizedBox(height: 4),
          Text('Scheduler input & plan overview', style: tt.bodySmall),

          const SizedBox(height: 20),

          if (isLoading)
            const SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (hasError)
            const SizedBox(
              height: 220,
              child: Center(
                child: Text(
                  'Could not load plan data',
                  style: TextStyle(color: AppColors.onSurfaceVariant),
                ),
              ),
            )
          else ...[
            // ── Chart ────────────────────────────────────────────────────────
            LayoutBuilder(builder: (context, constraints) {
              final colW = constraints.maxWidth / 24;
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                onHover: (e) {
                  final h = (e.localPosition.dx / colW).floor().clamp(0, 23);
                  if (_hoveredHour != h) setState(() => _hoveredHour = h);
                },
                onExit: (_) => setState(() => _hoveredHour = null),
                child: GestureDetector(
                  onTapDown: (e) {
                    final h = (e.localPosition.dx / colW).floor().clamp(0, 23);
                    setState(() => _hoveredHour = _hoveredHour == h ? null : h);
                  },
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 260,
                        width: double.infinity,
                        child: CustomPaint(
                          painter: DailyPlanPainter(
                            hours: hours,
                            peak: peak,
                            hoveredHour: _hoveredHour,
                            nowHour: nowHour,
                            nowMinute: nowMinute,
                            layers: _layers,
                          ),
                        ),
                      ),
                      // Floating tooltip
                      if (hoveredData != null)
                        Positioned(
                          top: 20,
                          left: _hoveredHour! < 12
                              ? (_hoveredHour! * colW + colW + 6)
                              : null,
                          right: _hoveredHour! >= 12
                              ? ((23 - _hoveredHour!) * colW + colW + 6)
                              : null,
                          child: HoverCard(
                            data: hoveredData,
                            layers: _layers,
                            isLive: _hoveredHour == nowHour,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 4),

            // ── Hour labels ──────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final h = (i * 4) % 24;
                return Text(
                  '${h.toString().padLeft(2, '0')}:00',
                  style: tt.labelSmall?.copyWith(color: AppColors.onSurfaceVariant),
                );
              }),
            ),

            const SizedBox(height: 12),

            // ── Planned Battery Action strip ─────────────────────────────────
            if (_layers.showPlan) CommandStrip(hours: hours),

            const SizedBox(height: 16),

            // ── Legend toggles ───────────────────────────────────────────────
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                LayerChip(
                  label: 'PV Intake',
                  color: AppColors.tertiary,
                  active: _layers.showPvIntake,
                  style: LayerChipStyle.solid,
                  tooltip: 'Measured solar intake for past hours',
                  onTap: () => setState(() => _layers.showPvIntake = !_layers.showPvIntake),
                ),
                LayerChip(
                  label: 'PV Estimate',
                  color: AppColors.tertiary,
                  active: _layers.showPvEstimate,
                  style: LayerChipStyle.dashed,
                  tooltip: 'PV forecast for current and future hours',
                  onTap: () => setState(() => _layers.showPvEstimate = !_layers.showPvEstimate),
                ),
                LayerChip(
                  label: 'Home Load',
                  color: AppColors.onSurfaceVariant,
                  active: _layers.showLoad,
                  style: LayerChipStyle.solid,
                  tooltip: 'Actual home energy consumption per hour',
                  onTap: () => setState(() => _layers.showLoad = !_layers.showLoad),
                ),
                LayerChip(
                  label: 'Battery SoC',
                  color: AppColors.primary,
                  active: _layers.showSoc,
                  style: LayerChipStyle.solid,
                  tooltip: 'Estimated battery state of charge at the start of each hour',
                  onTap: () => setState(() => _layers.showSoc = !_layers.showSoc),
                ),
                LayerChip(
                  label: 'Buy Price',
                  color: AppColors.error,
                  active: _layers.showBuyPrice,
                  style: LayerChipStyle.solid,
                  tooltip: 'Energy import price per kWh',
                  onTap: () => setState(() => _layers.showBuyPrice = !_layers.showBuyPrice),
                ),
                LayerChip(
                  label: 'Sell Price',
                  color: AppColors.secondary,
                  active: _layers.showSellPrice,
                  style: LayerChipStyle.solid,
                  tooltip: 'Energy export price per kWh',
                  onTap: () => setState(() => _layers.showSellPrice = !_layers.showSellPrice),
                ),
                LayerChip(
                  label: 'Charge Plan',
                  color: AppColors.secondary,
                  active: _layers.showPlan,
                  style: LayerChipStyle.solid,
                  tooltip: 'Optimizer command per hour: charge / discharge / idle',
                  onTap: () => setState(() => _layers.showPlan = !_layers.showPlan),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
