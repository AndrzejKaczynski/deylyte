import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/theme.dart';
import '../components/components.dart';
import '../providers/app_providers.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      ref.invalidate(latestTelemetryProvider);
      ref.invalidate(addonStatusProvider);
      ref.invalidate(currentScheduleProvider);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final addonAsync = ref.watch(addonStatusProvider);
    final addonStatus = addonAsync.valueOrNull;
    final connected = addonStatus?['connected'] == true;
    final lastSeen = addonStatus?['lastSeenAt'] as String?;
    final showOfflineBanner = !connected && lastSeen != null;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(latestTelemetryProvider);
            ref.invalidate(addonStatusProvider);
            ref.invalidate(currentScheduleProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding:
                EdgeInsets.all(isDesktop ? AppSpacing.sp6 : AppSpacing.sp4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DashboardHeader(),
                if (showOfflineBanner) ...[
                  const SizedBox(height: AppSpacing.sp3),
                  _OfflineBanner(),
                ],
                const SizedBox(height: AppSpacing.sp4),
                _KpiStrip(),
                const SizedBox(height: AppSpacing.sp6),
                AsymmetricGrid(
                  primaryFlex: 7,
                  sidebarFlex: 3,
                  gap: AppSpacing.sp4,
                  primary: Column(
                    children: [
                      _PowerFlowCard(),
                      const SizedBox(height: AppSpacing.sp4),
                      _ConsumptionChartCard(),
                    ],
                  ),
                  sidebar: Column(
                    children: [
                      _EnergySourcesCard(),
                      const SizedBox(height: AppSpacing.sp4),
                      _EmsStatusCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Offline Banner ─────────────────────────────────────────────────────────────

class _OfflineBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withValues(alpha: 0.10),
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.25)),
      ),
      child: Row(children: [
        const Icon(Icons.wifi_off_rounded, size: 16, color: AppColors.tertiary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Add-on offline — inverter data may be stale',
            style: tt.bodySmall?.copyWith(color: AppColors.tertiary),
          ),
        ),
        GestureDetector(
          onTap: () => context.go('/settings'),
          child: Text(
            'Troubleshoot →',
            style: tt.bodySmall?.copyWith(
              color: AppColors.tertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ]),
    );
  }
}

// ── Header ───────────────────────────────────────────────────────────────────

class _DashboardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Energy Overview', style: tt.headlineMedium),
              const SizedBox(height: 4),
              Row(
                children: [
                  const PulseIndicator(color: AppColors.secondary, size: 6),
                  const SizedBox(width: 8),
                  Text(
                    'Real-time optimization active for Household 402',
                    style: tt.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
        // Grid frequency badge
        SurfaceCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.electric_bolt_rounded,
                  size: 14, color: AppColors.secondary),
              const SizedBox(width: 6),
              Text('50.02 Hz',
                  style: tt.labelMedium?.copyWith(color: AppColors.secondary)),
            ],
          ),
        ),
      ],
    );
  }
}

// ── KPI Strip ────────────────────────────────────────────────────────────────

class _KpiStrip extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final telemetry = ref.watch(latestTelemetryProvider).valueOrNull;
    final soc = telemetry?.batterySOC;
    final pv = telemetry?.pvPowerW;
    final grid = telemetry?.gridPowerW;

    final socPct = soc != null ? '${soc.toStringAsFixed(0)}%' : '--';
    final socSub = soc != null
        ? (telemetry!.batteryPowerW < 0 ? '⚡ Charging' : '↓ Discharging')
        : 'No data';
    final pvKw = pv != null ? '${(pv / 1000).toStringAsFixed(1)} kW' : '--';
    // Deye register 625: positive = importing from grid, negative = exporting to grid
    final gridStatus = grid == null
        ? '--'
        : (grid > 100
            ? 'Importing'
            : (grid < -100 ? 'Exporting' : 'Stable'));

    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth > 600;
      final items = [
        _KpiItem(
          title: 'Battery SoC',
          value: socPct,
          subtitle: socSub,
          subtitleColor: AppColors.secondary,
          icon: Icons.battery_charging_full_rounded,
          iconColor: AppColors.secondary,
          child: _BatterySocBar(soc: (soc ?? 0) / 100),
        ),
        const _KpiItem(
          title: 'Net Balance',
          value: '--',
          subtitle: 'Today',
          icon: Icons.trending_up_rounded,
          iconColor: AppColors.secondary,
        ),
        _KpiItem(
          title: 'Grid Status',
          value: gridStatus,
          subtitle: grid != null
              ? '${(grid.abs() / 1000).toStringAsFixed(1)} kW'
              : '--',
          icon: Icons.bolt_rounded,
          iconColor: AppColors.primary,
        ),
        _KpiItem(
          title: 'Solar Yield',
          value: pvKw,
          subtitle: 'Now',
          icon: Icons.wb_sunny_rounded,
          iconColor: AppColors.tertiary,
        ),
      ];

      if (wide) {
        return Row(
          children: items
              .map((i) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: i,
                    ),
                  ))
              .toList(),
        );
      }
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
        children: items,
      );
    });
  }
}

class _KpiItem extends StatelessWidget {
  const _KpiItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.subtitle,
    this.subtitleColor,
    this.child,
  });

  final String title;
  final String value;
  final String? subtitle;
  final Color? subtitleColor;
  final IconData icon;
  final Color iconColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Text(title, style: tt.bodySmall),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: tt.headlineSmall?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.02,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: tt.bodySmall?.copyWith(
                  color: subtitleColor ?? AppColors.onSurfaceVariant),
            ),
          ],
          if (child != null) ...[
            const SizedBox(height: 10),
            child!,
          ],
        ],
      ),
    );
  }
}

class _BatterySocBar extends StatelessWidget {
  const _BatterySocBar({required this.soc});
  final double soc;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      return Stack(
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            height: 6,
            width: c.maxWidth * soc,
            decoration: BoxDecoration(
              gradient: AppGradients.profitGreen,
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.4),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

// ── Power Flow Card ───────────────────────────────────────────────────────────

class _PowerFlowCard extends StatelessWidget {
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
            // Solar – top left
            Positioned(
              top: 8, left: 20,
              child: _FlowNode(
                icon: Icons.wb_sunny_rounded,
                label: 'Solar Panels',
                value: '3.2 kW',
                color: AppColors.tertiary,
              ),
            ),
            // Battery – top right
            Positioned(
              top: 8, right: 20,
              child: _FlowNode(
                icon: Icons.battery_charging_full_rounded,
                label: 'Battery',
                value: '8.4 kWh',
                color: AppColors.secondary,
              ),
            ),
            // Home – bottom left
            Positioned(
              bottom: 8, left: 20,
              child: _FlowNode(
                icon: Icons.home_rounded,
                label: 'Home Load',
                value: '1.8 kW',
                color: AppColors.primary,
              ),
            ),
            // Grid – bottom right
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

    // Dashed cross lines from centre to each corner node
    _drawDashed(canvas, Offset(cx, cy), const Offset(80, 50), paint);
    _drawDashed(canvas, Offset(cx, cy), Offset(size.width - 80, 50), paint);
    _drawDashed(canvas, Offset(cx, cy), Offset(80, size.height - 50), paint);
    _drawDashed(canvas, Offset(cx, cy), Offset(size.width - 80, size.height - 50), paint);

    // Centre glow dot
    canvas.drawCircle(
      Offset(cx, cy), 5,
      Paint()
        ..color = AppColors.secondary
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    canvas.drawCircle(Offset(cx, cy), 3,
        Paint()..color = AppColors.secondary);
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
      canvas.drawLine(
        from + unit * pos,
        from + unit * end,
        paint,
      );
      pos += dashLen + gapLen;
    }
  }

  @override
  bool shouldRepaint(_FlowPainter old) => false;
}

// ── Consumption Chart Card ────────────────────────────────────────────────────

class _ConsumptionChartCard extends StatelessWidget {
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
              _ChartLegendDot(
                  color: AppColors.tertiary, label: 'Grid import'),
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
  // Sample data points (normalised 0..1)
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
    // Glow
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.25)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    // Line
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    // Fill
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
    // Grid lines
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

// ── Energy Sources Card ───────────────────────────────────────────────────────

class _EnergySourcesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Energy Sources', style: tt.titleMedium),
          const SizedBox(height: 16),
          const _SourceRow(
            icon: Icons.wb_sunny_rounded,
            label: 'Solar Panels',
            value: '3.2 kW',
            color: AppColors.tertiary,
            fraction: 0.68,
          ),
          const SizedBox(height: 12),
          const _SourceRow(
            icon: Icons.battery_charging_full_rounded,
            label: 'Battery Storage',
            value: '8.4 kWh @ 84%',
            color: AppColors.secondary,
            fraction: 0.84,
          ),
          const SizedBox(height: 12),
          const _SourceRow(
            icon: Icons.electric_meter_rounded,
            label: 'Public Grid',
            value: 'Idle / Exporting',
            color: AppColors.outlineVariant,
            fraction: 0.0,
          ),
        ],
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.fraction,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
              child: Text(label,
                  style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w500))),
          Text(value, style: tt.labelSmall?.copyWith(color: color)),
        ]),
        const SizedBox(height: 6),
        LayoutBuilder(builder: (_, c) {
          return Stack(children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              height: 4,
              width: c.maxWidth * fraction,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
                boxShadow: fraction > 0
                    ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 4)]
                    : null,
              ),
            ),
          ]);
        }),
      ],
    );
  }
}

// ── Appliance Status Card ─────────────────────────────────────────────────────

class _EmsStatusCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final scheduleAsync = ref.watch(currentScheduleProvider);
    final configAsync = ref.watch(appConfigProvider);
    final schedule = scheduleAsync.valueOrNull;
    final config = configAsync.valueOrNull;
    final planningOnly = config?.planningOnly ?? false;

    final minSocPct = config?.minSocPercentage != null
        ? '${((config!.minSocPercentage!) * 100).round()}%'
        : '--';

    final mode = schedule == null
        ? 'Standby'
        : switch (schedule.command.toLowerCase()) {
            'charge' => 'Charging',
            'discharge' => 'Discharging',
            'idle' => 'Standby',
            _ => 'Optimizing',
          };

    final modeColor = switch (mode) {
      'Charging' => AppColors.secondary,
      'Discharging' => AppColors.primary,
      'Optimizing' => AppColors.primary,
      _ => AppColors.onSurfaceVariant,
    };

    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(title: 'EMS Status'),
        const SizedBox(height: 16),
        // Mode chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: modeColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            PulseIndicator(color: modeColor, size: 6),
            const SizedBox(width: 6),
            Text(
              mode,
              style: tt.labelMedium
                  ?.copyWith(color: modeColor, fontWeight: FontWeight.w600),
            ),
          ]),
        ),
        if (planningOnly) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(children: [
              const Icon(Icons.visibility_outlined,
                  size: 13, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Planning Mode — inverter not controlled',
                  style: tt.labelSmall?.copyWith(color: AppColors.primary),
                ),
              ),
            ]),
          ),
        ],
        const SizedBox(height: 16),
        // Battery reserve
        Row(children: [
          const Icon(Icons.battery_alert_rounded,
              size: 14, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 6),
          Text('Battery reserve: $minSocPct', style: tt.bodySmall),
        ]),
        if (schedule == null) ...[
          const SizedBox(height: 12),
          Text(
            'No schedule yet — EMS configuring',
            style:
                tt.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => context.go('/schedule'),
          child: Text(
            'View Schedule →',
            style: tt.bodySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ]),
    );
  }
}

