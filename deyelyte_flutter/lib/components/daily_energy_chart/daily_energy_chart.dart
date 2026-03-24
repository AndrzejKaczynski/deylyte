import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../surface_card.dart';
import 'hour_data.dart';
import 'daily_chart_painter.dart';
import 'hover_card.dart';
import 'command_strip.dart';
import 'layer_chip.dart';

export 'hour_data.dart';

/// A 24-hour energy chart card that can be used in both the schedule and
/// history screens.
///
/// Pass [nowHour] and [nowMinute] for the live schedule view — they drive
/// the "NOW" pill and the actual/forecast split. Omit them (leave null) for
/// a history view where all hours are treated as actual data.
///
/// Set [showEstimateLayer] to false for history so the PV Estimate toggle
/// chip is hidden and the dashed forecast curve is never drawn.
class DailyEnergyChart extends StatefulWidget {
  const DailyEnergyChart({
    super.key,
    required this.title,
    required this.subtitle,
    required this.hours,
    this.nowHour,
    this.nowMinute,
    this.isLoading = false,
    this.hasError = false,
    this.showEstimateLayer = true,
    this.showPlanLayer = true,
    this.commandStripLabel = 'PLANNED BATTERY ACTION',
    this.columnCount = 24,
    this.axisLabels,
  });

  final String title;
  final String subtitle;
  final List<HourData> hours;

  /// Current hour (0-23). Null = history mode — no NOW pill.
  final int? nowHour;

  /// Current minute (0-59). Null = history mode.
  final int? nowMinute;

  final bool isLoading;
  final bool hasError;

  /// Whether to show the PV Estimate toggle chip and dashed curve.
  /// Set to false for history where there is no forecast data.
  final bool showEstimateLayer;

  /// Whether to show the command strip and Charge Plan toggle chip.
  /// Set to false for multi-day history where per-day commands aren't meaningful.
  final bool showPlanLayer;

  /// Label shown above the command strip.
  final String commandStripLabel;

  /// Number of columns. 24 = hourly day view. N = N-day aggregated view.
  final int columnCount;

  /// 7 axis labels shown at the bottom. Null = default hour labels (00:00…20:00).
  final List<String>? axisLabels;

  @override
  State<DailyEnergyChart> createState() => _DailyEnergyChartState();
}

class _DailyEnergyChartState extends State<DailyEnergyChart> {
  final _layers = Layers();
  int? _hoveredHour;

  @override
  void initState() {
    super.initState();
    if (!widget.showEstimateLayer) {
      _layers.showPvEstimate = false;
    }
    if (!widget.showPlanLayer) {
      _layers.showPlan = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    final peak = widget.hours.fold(0.0, (m, h) {
      final pv = max(h.pvKw, h.pvActualKw ?? 0.0);
      final load = h.loadKw ?? 0.0;
      return max(m, max(pv, load));
    });

    final hoveredData = _hoveredHour != null ? widget.hours[_hoveredHour!] : null;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Text(widget.title, style: tt.headlineSmall),
          const SizedBox(height: 4),
          Text(widget.subtitle, style: tt.bodySmall),

          const SizedBox(height: 20),

          if (widget.isLoading)
            const SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (widget.hasError)
            const SizedBox(
              height: 220,
              child: Center(
                child: Text(
                  'Could not load data',
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
                            hours: widget.hours,
                            peak: peak,
                            hoveredHour: _hoveredHour,
                            nowHour: widget.nowHour,
                            nowMinute: widget.nowMinute,
                            layers: _layers,
                            columnCount: widget.columnCount,
                          ),
                        ),
                      ),
                      if (hoveredData != null)
                        Positioned(
                          top: 20,
                          left: _hoveredHour! < widget.columnCount ~/ 2
                              ? (_hoveredHour! * colW + colW + 6)
                              : null,
                          right: _hoveredHour! >= widget.columnCount ~/ 2
                              ? ((widget.columnCount - 1 - _hoveredHour!) * colW + colW + 6)
                              : null,
                          child: HoverCard(
                            data: hoveredData,
                            layers: _layers,
                            isLive: widget.nowHour != null && _hoveredHour == widget.nowHour,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 4),

            // ── Axis labels ────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: (widget.axisLabels ??
                      List.generate(7, (i) {
                        final h = (i * 4) % 24;
                        return '${h.toString().padLeft(2, '0')}:00';
                      }))
                  .map((l) => Text(
                        l,
                        style: tt.labelSmall?.copyWith(color: AppColors.onSurfaceVariant),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 12),

            // ── Command strip ──────────────────────────────────────────────
            if (widget.showPlanLayer && _layers.showPlan)
              CommandStrip(hours: widget.hours, label: widget.commandStripLabel),

            const SizedBox(height: 16),

            // ── Legend toggles ─────────────────────────────────────────────
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                LayerChip(
                  label: 'PV Intake',
                  color: AppColors.tertiary,
                  active: _layers.showPvIntake,
                  style: LayerChipStyle.solid,
                  tooltip: 'Measured solar intake',
                  onTap: () => setState(() => _layers.showPvIntake = !_layers.showPvIntake),
                ),
                if (widget.showEstimateLayer)
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
                  tooltip: 'Battery state of charge at the start of each hour',
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
                if (widget.showPlanLayer)
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
