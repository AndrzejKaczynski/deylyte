import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/app_styles.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedRange = 1; // 0=7d 1=30d 2=90d

  static const _ranges = ['7 days', '30 days', '90 days'];

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
              _HistoryHeader(
                selectedRange: _selectedRange,
                ranges: _ranges,
                onRangeChanged: (i) => setState(() => _selectedRange = i),
              ),
              SizedBox(height: AppSpacing.sp4),
              // KPI row
              _HistoryKpiRow(),
              SizedBox(height: AppSpacing.sp6),
              AsymmetricGrid(
                primaryFlex: 7,
                sidebarFlex: 3,
                gap: AppSpacing.sp4,
                primary: Column(children: [
                  _MarketArbitrageChart(),
                  SizedBox(height: AppSpacing.sp4),
                  _YieldVsExpenditureChart(),
                ]),
                sidebar: Column(children: [
                  _NetProfitCard(),
                  SizedBox(height: AppSpacing.sp4),
                  _RecentEventsCard(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader({
    required this.selectedRange,
    required this.ranges,
    required this.onRangeChanged,
  });
  final int selectedRange;
  final List<String> ranges;
  final ValueChanged<int> onRangeChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Deyelightful History', style: tt.headlineMedium),
            const SizedBox(height: 4),
            Text('Energy performance over time', style: tt.bodySmall),
          ]),
        ),
        // Range selector segmented control
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: AppRadius.radiusMd,
          ),
          padding: const EdgeInsets.all(3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: ranges.asMap().entries.map((e) {
              final active = selectedRange == e.key;
              return GestureDetector(
                onTap: () => onRangeChanged(e.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: active ? AppColors.surfaceContainerHighest : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    e.value,
                    style: tt.labelMedium?.copyWith(
                      color: active ? AppColors.primary : AppColors.outline,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ── KPI Row ───────────────────────────────────────────────────────────────────

class _HistoryKpiRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final items = [
      (label: 'Price Velocity', value: '\$0.14/kWh', sub: 'Avg. today', color: AppColors.primary, icon: Icons.speed_rounded),
      (label: 'Net Revenue', value: '+\$42.80', sub: 'This week', color: AppColors.secondary, icon: Icons.trending_up_rounded),
      (label: 'Peak Load', value: '12.4 kW', sub: 'Highest usage point', color: AppColors.tertiary, icon: Icons.flash_on_rounded),
      (label: 'Green Mix', value: '88%', sub: 'Renewable source', color: AppColors.secondary, icon: Icons.eco_rounded),
    ];

    return LayoutBuilder(builder: (_, c) {
      final wide = c.maxWidth > 600;
      final widgets = items.map((it) {
        return SurfaceCard(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(it.icon, size: 14, color: it.color),
              const SizedBox(width: 6),
              Text(it.label, style: tt.bodySmall),
            ]),
            const SizedBox(height: 8),
            Text(it.value,
                style: tt.headlineSmall?.copyWith(
                    color: it.color, fontWeight: FontWeight.w700, letterSpacing: -0.02)),
            const SizedBox(height: 2),
            Text(it.sub, style: tt.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
          ]),
        );
      }).toList();

      if (wide) {
        return Row(
          children: widgets
              .map((w) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 12), child: w)))
              .toList(),
        );
      }
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
        children: widgets,
      );
    });
  }
}

// ── Market Arbitrage Chart ────────────────────────────────────────────────────

class _MarketArbitrageChart extends StatelessWidget {
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
    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SectionHeader(
          title: 'Market Arbitrage & Storage',
          subtitle: 'Real-time buy/sell pressure vs battery capacity',
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 12),
        Row(children: [
          _ChartKey(color: AppColors.error, label: 'Buy pressure'),
          const SizedBox(width: 20),
          _ChartKey(color: AppColors.secondary, label: 'Battery SoC'),
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

// ── Yield vs Expenditure Chart ────────────────────────────────────────────────

class _YieldVsExpenditureChart extends StatelessWidget {
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
    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SectionHeader(
          title: 'Yield vs Expenditure',
          subtitle: 'Net balance over historical cycle',
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 12),
        Row(children: [
          _ChartKey(color: AppColors.secondary, label: 'Yield'),
          const SizedBox(width: 20),
          _ChartKey(color: AppColors.error, label: 'Expenditure'),
        ]),
      ]),
    );
  }
}

// ── Net Profit Card ───────────────────────────────────────────────────────────

class _NetProfitCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Total Net Profit', style: tt.titleMedium),
        const SizedBox(height: 8),
        HeroMetric(
          value: '+\$1,240',
          unit: '.42',
          valueColor: AppColors.secondary,
          size: HeroMetricSize.small,
        ),
        const SizedBox(height: 20),
        _StatRow(label: 'Total Savings', value: '\$4,821.00',
            color: AppColors.secondary),
        const SizedBox(height: 12),
        _StatRow(label: 'Storage Efficiency', value: '94.2%',
            color: AppColors.primary),
        const SizedBox(height: 12),
        _StatRow(label: 'Carbon Offset', value: '1.2 Tons',
            color: AppColors.secondary),
        const SizedBox(height: 12),
        _StatRow(label: 'Peak Demand', value: '4.8 kW',
            color: AppColors.tertiary),
      ]),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: tt.bodySmall),
      Text(value,
          style:
              tt.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w700)),
    ]);
  }
}

// ── Recent Market Events ──────────────────────────────────────────────────────

class _RecentEventsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Recent Market Events', style: tt.titleMedium),
        const SizedBox(height: 16),
        _EventRow(
          icon: Icons.upload_rounded,
          title: 'Feed-in Export',
          subtitle: 'Grid sale @ 0.14/kWh',
          value: '+\$12.40',
          time: 'Today, 14:20',
          valueColor: AppColors.secondary,
        ),
        const SizedBox(height: 12),
        _EventRow(
          icon: Icons.battery_charging_full_rounded,
          title: 'Smart Charging',
          subtitle: 'Battery fill @ 0.08/kWh',
          value: '-\$4.12',
          time: 'Today, 03:00',
          valueColor: AppColors.error,
        ),
        const SizedBox(height: 12),
        _EventRow(
          icon: Icons.bolt_rounded,
          title: 'Peak Load Shaving',
          subtitle: 'Battery discharge to offset AC',
          value: 'Saved \$2.15',
          time: 'Yesterday, 18:45',
          valueColor: AppColors.secondary,
        ),
      ]),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.time,
    required this.valueColor,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final String time;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadius.radiusMd,
      ),
      child: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: valueColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: valueColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
            Text(subtitle, style: tt.bodySmall),
            Text(time, style: tt.labelSmall),
          ]),
        ),
        Text(value,
            style: tt.bodyMedium
                ?.copyWith(color: valueColor, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}
