import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_styles.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? AppSpacing.sp6 : AppSpacing.sp4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ScheduleHeader(),
              SizedBox(height: AppSpacing.sp4),
              AsymmetricGrid(
                primaryFlex: 7,
                sidebarFlex: 3,
                gap: AppSpacing.sp4,
                primary: Column(
                  children: [
                    _ForecastBarCard(),
                    SizedBox(height: AppSpacing.sp4),
                    _PowerAllocationCard(),
                  ],
                ),
                sidebar: Column(
                  children: [
                    _StrategyAnalysisCard(),
                    SizedBox(height: AppSpacing.sp4),
                    _UpcomingEventsCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _ScheduleHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Energy Schedule', style: tt.headlineMedium),
              const SizedBox(height: 4),
              Text(
                'Real-time optimization for Today, Oct 24',
                style: tt.bodySmall,
              ),
            ],
          ),
        ),
        ProfitBadge(
          label: 'Est. Net Profit · Varies \$0.08–\$0.42',
          icon: Icons.trending_up_rounded,
        ),
      ],
    );
  }
}

// ── 24-Hour Forecast Bar Chart ────────────────────────────────────────────────

class _ForecastBarCard extends StatelessWidget {
  // price tiers per hour 0–23 (low/mid/high coded as 0/1/2)
  static const _priceTiers = [
    0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 2, 2,
    2, 2, 1, 1, 2, 2, 2, 1, 1, 0, 0, 0,
  ];
  // SoC projection 0–1
  static const _soc = [
    0.5, 0.55, 0.62, 0.70, 0.75, 0.80, 0.82, 0.84, 0.84, 0.80, 0.75, 0.70,
    0.65, 0.60, 0.55, 0.52, 0.48, 0.44, 0.40, 0.45, 0.50, 0.55, 0.52, 0.50,
  ];

  static const _colors = [
    AppColors.secondary,   // low price – charge
    AppColors.tertiary,    // mid price
    AppColors.error,       // high price – discharge
  ];

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: '24-Hour Forecast',
            subtitle: 'Price tiers & battery SoC projection',
          ),
          const SizedBox(height: 8),
          // Legend
          Row(children: [
            _Legend(color: AppColors.secondary, label: 'Off-peak (charge)'),
            const SizedBox(width: 16),
            _Legend(color: AppColors.tertiary, label: 'Mid'),
            const SizedBox(width: 16),
            _Legend(color: AppColors.error, label: 'Peak (discharge)'),
          ]),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: CustomPaint(
              painter: _ForecastPainter(_priceTiers, _soc, _colors),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 6),
          // Hour labels every 4h
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

    // Grid lines
    for (var i = 1; i <= 4; i++) {
      final y = barY + barMaxH / 4 * (4 - i);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Bars
    for (var i = 0; i < n; i++) {
      final tier = tiers[i];
      const barH = 80.0;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(i * barW + 2, barY + barMaxH - barH + (2 - tier) * 22,
            barW - 4, barH - (2 - tier) * 22),
        const Radius.circular(4),
      );
      canvas.drawRRect(
        rect,
        Paint()..color = colors[tier].withValues(alpha: 0.30),
      );
    }

    // SoC line
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

    // SoC label
    final top = barY;
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '── Battery SoC',
        style: TextStyle(
          fontSize: 10,
          color: AppColors.primary,
          fontFamily: 'Inter',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(4, top));
  }

  @override
  bool shouldRepaint(_ForecastPainter old) => false;
}

// ── Power Allocation Flow ─────────────────────────────────────────────────────

class _PowerAllocationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Power Allocation Flow'),
          const SizedBox(height: 16),
          // Timeline events
          _TimelineEvent(
            time: '02:00–04:00',
            title: 'Off-Peak Pre-charge',
            body:
                'System charged 4.5 kWh at \$0.08 to offset evening peak costs.',
            icon: Icons.battery_charging_full_rounded,
            color: AppColors.secondary,
            badge: 'Completed',
          ),
          const SizedBox(height: 12),
          _TimelineEvent(
            time: '08:00–14:00',
            title: 'Solar Harvest',
            body: 'PV forecast: 12.4 kWh yield, 3.2 kW surplus for charging.',
            icon: Icons.wb_sunny_rounded,
            color: AppColors.tertiary,
            badge: 'In Progress',
            badgeColor: AppColors.tertiary,
          ),
          const SizedBox(height: 12),
          _TimelineEvent(
            time: '12:00',
            title: 'High-Yield Feed-in',
            body:
                'Scheduled discharge of excess 3.2 kWh during price spike (\$0.42/kWh).',
            icon: Icons.upload_rounded,
            color: AppColors.primary,
            badge: 'Upcoming',
            badgeColor: AppColors.primary,
          ),
          const SizedBox(height: 12),
          _TimelineEvent(
            time: '17:00–21:00',
            title: 'Evening Peak Shaving',
            body: 'Battery discharge scheduled to avoid grid import at peak rates.',
            icon: Icons.bolt_rounded,
            color: AppColors.error,
            badge: 'Planned',
          ),
        ],
      ),
    );
  }
}

class _TimelineEvent extends StatelessWidget {
  const _TimelineEvent({
    required this.time,
    required this.title,
    required this.body,
    required this.icon,
    required this.color,
    this.badge,
    this.badgeColor,
  });

  final String time;
  final String title;
  final String body;
  final IconData icon;
  final Color color;
  final String? badge;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadius.radiusMd,
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(title,
                    style: tt.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ),
              if (badge != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (badgeColor ?? AppColors.onSurfaceVariant)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge!,
                    style: tt.labelSmall?.copyWith(
                        color: badgeColor ?? AppColors.onSurfaceVariant),
                  ),
                ),
            ]),
            const SizedBox(height: 2),
            Text(time,
                style: tt.labelSmall?.copyWith(color: color)),
            const SizedBox(height: 6),
            Text(body, style: tt.bodySmall),
          ]),
        ),
      ]),
    );
  }
}

// ── Strategy Analysis Card ────────────────────────────────────────────────────

class _StrategyAnalysisCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.psychology_rounded,
              size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text('Smart Strategy', style: tt.titleMedium),
        ]),
        const SizedBox(height: 4),
        Text('AI Kinetic · Learning User Behaviour',
            style: tt.bodySmall?.copyWith(color: AppColors.secondary)),
        const SizedBox(height: 16),
        _StrategyRow(
          label: 'Morning Peak',
          detail: 'Charge at off-peak rates starts in 4h',
          icon: Icons.battery_charging_full_rounded,
          color: AppColors.secondary,
        ),
        const SizedBox(height: 12),
        _StrategyRow(
          label: 'Weather',
          detail: 'Sunny · PV forecast 12.4 kWh',
          icon: Icons.wb_sunny_rounded,
          color: AppColors.tertiary,
        ),
        const SizedBox(height: 12),
        _StrategyRow(
          label: 'Historical',
          detail: 'Based on Monday usage patterns',
          icon: Icons.history_rounded,
          color: AppColors.primary,
        ),
        const SizedBox(height: 16),
        // Est profit meter
        Text('Est. Net Profit Today',
            style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        HeroMetric(
          value: '\$0.08–\$0.42',
          size: HeroMetricSize.small,
          valueColor: AppColors.secondary,
        ),
        const SizedBox(height: 4),
        Row(children: [
          const Icon(Icons.trending_up_rounded,
              size: 12, color: AppColors.secondary),
          const SizedBox(width: 4),
          Text('15% higher than yesterday',
              style: tt.labelSmall?.copyWith(color: AppColors.secondary)),
        ]),
      ]),
    );
  }
}

class _StrategyRow extends StatelessWidget {
  const _StrategyRow({
    required this.label,
    required this.detail,
    required this.icon,
    required this.color,
  });
  final String label;
  final String detail;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 8),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style:
                  tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
          Text(detail, style: tt.bodySmall),
        ]),
      ),
    ]);
  }
}

// ── Upcoming Events ───────────────────────────────────────────────────────────

class _UpcomingEventsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Upcoming Events', style: tt.titleMedium),
        const SizedBox(height: 16),
        _UpcomingRow(
          time: '12:00',
          event: 'Feed-in spike',
          color: AppColors.secondary,
        ),
        const SizedBox(height: 12),
        _UpcomingRow(
          time: '17:00',
          event: 'Peak shaving start',
          color: AppColors.error,
        ),
        const SizedBox(height: 12),
        _UpcomingRow(
          time: '22:00',
          event: 'Tesla Wallbox charge',
          color: AppColors.primary,
        ),
        const SizedBox(height: 12),
        _UpcomingRow(
          time: '02:00',
          event: 'Next off-peak window',
          color: AppColors.secondary,
        ),
      ]),
    );
  }
}

class _UpcomingRow extends StatelessWidget {
  const _UpcomingRow({
    required this.time,
    required this.event,
    required this.color,
  });
  final String time;
  final String event;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(children: [
      Container(
        width: 44,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(time,
            textAlign: TextAlign.center,
            style:
                tt.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w700)),
      ),
      const SizedBox(width: 10),
      Expanded(child: Text(event, style: tt.bodySmall)),
    ]);
  }
}
