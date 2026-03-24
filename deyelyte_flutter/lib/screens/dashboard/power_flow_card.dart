import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../providers/app_providers.dart';

// ─── Card ─────────────────────────────────────────────────────────────────────

class PowerFlowCard extends ConsumerWidget {
  const PowerFlowCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final telemetry = ref.watch(latestTelemetryProvider).valueOrNull;
    final gridConnectionKw = ref.watch(appConfigProvider).valueOrNull?.gridConnectionKw;

    final pvKw = (telemetry?.pvPowerW ?? 0.0) / 1000.0;
    final loadKw = (telemetry?.loadPowerW ?? 0.0) / 1000.0;
    final gridKw = (telemetry?.gridPowerW ?? 0.0) / 1000.0;
    // batteryPowerW < 0 = charging, > 0 = discharging
    final batteryKw = (telemetry?.batteryPowerW ?? 0.0) / 1000.0;
    final soc = telemetry?.batterySOC ?? 0.0;

    final gridStatus = gridKw > 0.1
        ? 'Importing'
        : (gridKw < -0.1 ? 'Exporting' : 'Idle');
    final batteryStatus = batteryKw < -0.05
        ? 'Charging'
        : (batteryKw > 0.05 ? 'Discharging' : 'Idle');

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Power Flow',
            subtitle: 'Live energy routing',
          ),
          const SizedBox(height: 24),
          _PowerFlowDiagram(
            pvKw: pvKw,
            loadKw: loadKw,
            gridKw: gridKw,
            batteryKw: batteryKw,
            soc: soc,
            gridStatus: gridStatus,
            batteryStatus: batteryStatus,
            hasData: telemetry != null,
            gridConnectionKw: gridConnectionKw,
          ),
        ],
      ),
    );
  }
}

// ─── Diagram ──────────────────────────────────────────────────────────────────

class _PowerFlowDiagram extends StatefulWidget {
  const _PowerFlowDiagram({
    required this.pvKw,
    required this.loadKw,
    required this.gridKw,
    required this.batteryKw,
    required this.soc,
    required this.gridStatus,
    required this.batteryStatus,
    required this.hasData,
    this.gridConnectionKw,
  });

  final double pvKw;
  final double loadKw;
  final double gridKw;
  final double batteryKw;
  final double soc;
  final String gridStatus;
  final String batteryStatus;
  final bool hasData;
  final double? gridConnectionKw;

  @override
  State<_PowerFlowDiagram> createState() => _PowerFlowDiagramState();
}

class _PowerFlowDiagramState extends State<_PowerFlowDiagram>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pvLabel =
        widget.hasData ? '${widget.pvKw.toStringAsFixed(1)} kW' : '--';
    final loadLabel =
        widget.hasData ? '${widget.loadKw.toStringAsFixed(1)} kW' : '--';
    final gridLabel = widget.hasData
        ? '${widget.gridKw.abs().toStringAsFixed(1)} kW'
        : '--';
    final batteryPowerLabel = widget.hasData
        ? '${widget.batteryKw.abs().toStringAsFixed(1)} kW'
        : '--';
    final batterySocLabel =
        widget.hasData ? '${widget.soc.toStringAsFixed(0)}% SoC' : '--';

    return SizedBox(
      height: 260,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) => CustomPaint(
          painter: _FlowPainter(
            animValue: _ctrl.value,
            pvKw: widget.pvKw,
            loadKw: widget.loadKw,
            gridKw: widget.gridKw,
            batteryKw: widget.batteryKw,
            gridConnectionKw: widget.gridConnectionKw,
          ),
          child: Stack(
            children: [
              // ── Sources (left) ──────────────────────────────────
              Positioned(
                top: 8, left: 20,
                child: _FlowNode(
                  icon: Icons.wb_sunny_rounded,
                  label: 'Solar Panels',
                  value: pvLabel,
                  color: AppColors.tertiary,
                ),
              ),
              Positioned(
                bottom: 8, left: 20,
                child: _FlowNode(
                  icon: Icons.electric_meter_rounded,
                  label: 'Public Grid',
                  value: gridLabel,
                  color: AppColors.onSurfaceVariant,
                  badge: widget.gridStatus,
                  textAbove: true,
                ),
              ),
              // ── Consumers / holders (right) ──────────────────────
              Positioned(
                top: 8, right: 20,
                child: _FlowNode(
                  icon: Icons.battery_charging_full_rounded,
                  label: 'Battery',
                  value: batteryPowerLabel,
                  subValue: batterySocLabel,
                  color: AppColors.secondary,
                  badge: widget.batteryStatus,
                ),
              ),
              Positioned(
                bottom: 8, right: 20,
                child: _FlowNode(
                  icon: Icons.home_rounded,
                  label: 'Home Load',
                  value: loadLabel,
                  color: AppColors.primary,
                  textAbove: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Node widget ──────────────────────────────────────────────────────────────

class _FlowNode extends StatelessWidget {
  const _FlowNode({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.subValue,
    this.badge,
    this.textAbove = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String? subValue;
  final String? badge;
  /// When true, text renders above the circle (for bottom-positioned nodes so
  /// the circle bottom aligns with the Positioned anchor and the painter's
  /// node-centre calculation stays consistent).
  final bool textAbove;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    final circle = Container(
      width: 52, height: 52,
      decoration: BoxDecoration(
        // Opaque blend so the icon covers line endpoints drawn behind it.
        color: Color.alphaBlend(color.withValues(alpha: 0.15), AppColors.surface),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Icon(icon, color: color, size: 22),
    );

    final texts = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: tt.labelSmall),
        Text(
          value,
          style: tt.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (subValue != null)
          Text(
            subValue!,
            style: tt.labelSmall?.copyWith(color: color.withValues(alpha: 0.7)),
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: textAbove
          ? [texts, const SizedBox(height: 6), circle]
          : [circle, const SizedBox(height: 6), texts],
    );
  }
}

// ─── Connection model ─────────────────────────────────────────────────────────

class _Connection {
  const _Connection({
    required this.from,
    required this.to,
    required this.color,
    required this.active,
    this.speedMultiplier = 1.0,
  });
  final Offset from;
  final Offset to;
  final Color color;
  final bool active;
  /// Multiplier applied to animValue for this connection's particles.
  /// 1.0 = default speed. Higher = faster (more power).
  final double speedMultiplier;
}

// ─── Painter ──────────────────────────────────────────────────────────────────

class _FlowPainter extends CustomPainter {
  const _FlowPainter({
    required this.animValue,
    required this.pvKw,
    required this.loadKw,
    required this.gridKw,
    required this.batteryKw,
    this.gridConnectionKw,
  });

  final double animValue;
  final double pvKw;
  final double loadKw;
  final double gridKw;
  final double batteryKw;
  /// When provided, particle speed scales with power / connection ratio.
  /// Without it, all active connections use speed 1.0 (default).
  final double? gridConnectionKw;

  // Node circle radius is 26 (52/2); positioned at left/right:20, top/bottom:8
  // → centre of icon at x=46, y=34 from respective corners
  static const _nx = 46.0; // horizontal distance from edge to node centre
  static const _ny = 34.0; // vertical distance from edge to node centre

  /// Returns a particle speed multiplier based on the power ratio to the grid
  /// connection capacity. 50% load → 1.0 (default), 100% → 2.0, ~0% → 0.2.
  /// Falls back to 1.0 when no connection capacity is configured.
  double _speedFor(double powerKw) {
    final cap = gridConnectionKw;
    if (cap == null || cap <= 0) return 1.0;
    return (powerKw.abs() / cap * 2.0).clamp(0.2, 2.0);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final hub = Offset(cx, cy);

    // Node centres matching Positioned widgets
    const solar   = Offset(_nx, _ny);
    final grid    = Offset(_nx, size.height - _ny);
    final battery = Offset(size.width - _nx, _ny);
    final load    = Offset(size.width - _nx, size.height - _ny);

    // Build connections with correct energy-flow direction:
    //   solar → hub                (when generating)
    //   grid  → hub or hub → grid  (importing / exporting)
    //   hub   → battery or battery → hub  (charging / discharging)
    //   hub   → load               (when consuming)
    final connections = [
      _Connection(
        from: solar, to: hub,
        color: AppColors.tertiary,
        active: pvKw > 0.05,
        speedMultiplier: _speedFor(pvKw),
      ),
      _Connection(
        from: gridKw > 0.1 ? grid : hub,
        to:   gridKw > 0.1 ? hub  : grid,
        color: AppColors.primary,
        active: gridKw.abs() > 0.05,
        speedMultiplier: _speedFor(gridKw),
      ),
      _Connection(
        // batteryKw < 0 = charging (hub→battery), > 0 = discharging (battery→hub)
        from: batteryKw > 0.05 ? battery : hub,
        to:   batteryKw > 0.05 ? hub     : battery,
        color: AppColors.secondary,
        active: batteryKw.abs() > 0.05,
        speedMultiplier: _speedFor(batteryKw),
      ),
      _Connection(
        from: hub, to: load,
        color: AppColors.primary,
        active: loadKw > 0.05,
        speedMultiplier: _speedFor(loadKw),
      ),
    ];

    // 1 ── Dashed lines
    for (final c in connections) {
      final paint = Paint()
        ..color = c.active
            ? c.color.withValues(alpha: 0.35)
            : AppColors.outlineVariant.withValues(alpha: 0.18)
        ..strokeWidth = c.active ? 1.5 : 1.0
        ..style = PaintingStyle.stroke;
      _drawDashed(canvas, c.from, c.to, paint);
    }

    // 2 ── Animated particles on active connections
    for (final c in connections) {
      if (!c.active) continue;
      const numParticles = 3;
      for (int i = 0; i < numParticles; i++) {
        final tVal = (animValue * c.speedMultiplier + i / numParticles) % 1.0;
        final pos = Offset.lerp(c.from, c.to, tVal)!;
        // Glow
        canvas.drawCircle(
          pos, 4,
          Paint()
            ..color = c.color.withValues(alpha: 0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        );
        // Core dot
        canvas.drawCircle(pos, 2.5, Paint()..color = c.color);
      }
    }

    // 3 ── Centre hub
    canvas.drawCircle(
      hub, 7,
      Paint()
        ..color = AppColors.secondary.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawCircle(hub, 4, Paint()..color = AppColors.secondary);
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
  bool shouldRepaint(_FlowPainter old) =>
      old.animValue != animValue ||
      old.pvKw != pvKw ||
      old.loadKw != loadKw ||
      old.gridKw != gridKw ||
      old.batteryKw != batteryKw ||
      old.gridConnectionKw != gridConnectionKw;
}
