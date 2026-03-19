import 'package:flutter/material.dart';
import '../main.dart';
import '../theme/app_theme.dart';
import '../theme/app_styles.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Threshold sliders
  double _minSoc = 0.20;
  double _exportSoc = 0.80;
  bool _aiEnabled = true;
  bool _deye = true;
  bool _solcast = true;
  bool _pstryk = true;

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
              _SettingsHeader(),
              SizedBox(height: AppSpacing.sp4),
              AsymmetricGrid(
                primaryFlex: 6,
                sidebarFlex: 4,
                gap: AppSpacing.sp4,
                primary: Column(children: [
                  _ThresholdsCard(
                    minSoc: _minSoc,
                    exportSoc: _exportSoc,
                    onMinSocChanged: (v) => setState(() => _minSoc = v),
                    onExportSocChanged: (v) => setState(() => _exportSoc = v),
                  ),
                  SizedBox(height: AppSpacing.sp4),
                  _AiOptimizerCard(
                    enabled: _aiEnabled,
                    onChanged: (v) => setState(() => _aiEnabled = v),
                  ),
                  SizedBox(height: AppSpacing.sp4),
                  _HardwareCard(),
                ]),
                sidebar: Column(children: [
                  _AiStatusCard(aiEnabled: _aiEnabled),
                  SizedBox(height: AppSpacing.sp4),
                  _ApiIntegrationsCard(
                    deye: _deye,
                    solcast: _solcast,
                    pstryk: _pstryk,
                    onDeyeChanged: (v) => setState(() => _deye = v),
                    onSolcastChanged: (v) => setState(() => _solcast = v),
                    onPstrykChanged: (v) => setState(() => _pstryk = v),
                  ),
                  SizedBox(height: AppSpacing.sp4),
                  _DangerZoneCard(),
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

class _SettingsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('System Settings', style: tt.headlineMedium),
      const SizedBox(height: 4),
      Text(
        'Configure inverter thresholds, hardware specs, and AI parameters.',
        style: tt.bodySmall,
      ),
    ]);
  }
}

// ── Thresholds & Logic ────────────────────────────────────────────────────────

class _ThresholdsCard extends StatelessWidget {
  const _ThresholdsCard({
    required this.minSoc,
    required this.exportSoc,
    required this.onMinSocChanged,
    required this.onExportSocChanged,
  });

  final double minSoc;
  final double exportSoc;
  final ValueChanged<double> onMinSocChanged;
  final ValueChanged<double> onExportSocChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SectionHeader(title: 'Thresholds & Logic'),
        const SizedBox(height: 20),
        _SliderSetting(
          icon: Icons.battery_alert_rounded,
          iconColor: AppColors.error,
          label: 'Battery Floor (Grid Pull)',
          detail: 'Inverter pulls from grid if battery drops below this level.',
          value: minSoc,
          valueLabel: '${(minSoc * 100).round()}%',
          onChanged: onMinSocChanged,
          activeColor: AppColors.error,
        ),
        const SizedBox(height: 24),
        _SliderSetting(
          icon: Icons.upload_rounded,
          iconColor: AppColors.secondary,
          label: 'Export Threshold (Feed-in)',
          detail: 'Excess PV energy is exported to grid after this SoC.',
          value: exportSoc,
          valueLabel: '${(exportSoc * 100).round()}%',
          onChanged: onExportSocChanged,
          activeColor: AppColors.secondary,
        ),
      ]),
    );
  }
}

class _SliderSetting extends StatelessWidget {
  const _SliderSetting({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.detail,
    required this.value,
    required this.valueLabel,
    required this.onChanged,
    required this.activeColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String detail;
  final double value;
  final String valueLabel;
  final ValueChanged<double> onChanged;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label,
              style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: activeColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(valueLabel,
              style: tt.labelMedium?.copyWith(
                  color: activeColor, fontWeight: FontWeight.w700)),
        ),
      ]),
      const SizedBox(height: 4),
      Text(detail, style: tt.bodySmall),
      const SizedBox(height: 8),
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: activeColor,
          inactiveTrackColor: AppColors.surfaceContainerHigh,
          thumbColor: activeColor,
          overlayColor: activeColor.withValues(alpha: 0.12),
          trackHeight: 4,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
        ),
        child: Slider(
          value: value,
          min: 0.05,
          max: 1.0,
          divisions: 19,
          onChanged: onChanged,
        ),
      ),
    ]);
  }
}

// ── AI Optimizer ──────────────────────────────────────────────────────────────

class _AiOptimizerCard extends StatelessWidget {
  const _AiOptimizerCard({
    required this.enabled,
    required this.onChanged,
  });
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: SectionHeader(title: 'AI Optimizer')),
          Switch(
            value: enabled,
            onChanged: onChanged,
            activeColor: AppColors.secondary,
          ),
        ]),
        const SizedBox(height: 4),
        Text(
          enabled
              ? 'System is learning your consumption patterns to minimise peak-rate grid usage.'
              : 'AI optimizer disabled — using fixed schedule only.',
          style: tt.bodySmall,
        ),
        if (enabled) ...[
          const SizedBox(height: 20),
          Text('7-Day Training Progress', style: tt.titleMedium),
          const SizedBox(height: 4),
          Text('Refining forecasting models based on PV history.',
              style: tt.bodySmall),
          const SizedBox(height: 12),
          _TrainingProgressBar(
            label: 'Consumption patterns',
            fraction: 0.84,
            color: AppColors.primary,
          ),
          const SizedBox(height: 8),
          _TrainingProgressBar(
            label: 'PV yield model',
            fraction: 0.71,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 8),
          _TrainingProgressBar(
            label: 'Price forecasting',
            fraction: 0.62,
            color: AppColors.tertiary,
          ),
        ],
      ]),
    );
  }
}

class _TrainingProgressBar extends StatelessWidget {
  const _TrainingProgressBar({
    required this.label,
    required this.fraction,
    required this.color,
  });
  final String label;
  final double fraction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(label, style: tt.bodySmall)),
        Text('${(fraction * 100).round()}%',
            style: tt.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w700)),
      ]),
      const SizedBox(height: 4),
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
            duration: const Duration(milliseconds: 600),
            height: 4,
            width: c.maxWidth * fraction,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 4)],
            ),
          ),
        ]);
      }),
    ]);
  }
}

// ── Hardware Setup ────────────────────────────────────────────────────────────

class _HardwareCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SectionHeader(title: 'Hardware Setup'),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: AppRadius.radiusMd,
          ),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                gradient: AppGradients.profitGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.developer_board_rounded,
                  color: AppColors.onSecondary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Deye SUN-12K-SG04LP3',
                    style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('Firmware: v2.3.4.1-Stable',
                    style: tt.bodySmall?.copyWith(color: AppColors.outline)),
              ]),
            ),
            ProfitBadge(label: 'Online'),
          ]),
        ),
        const SizedBox(height: 12),
        _HardwareRow(label: 'Max Charge Rate', value: '6.0 kW'),
        const SizedBox(height: 8),
        _HardwareRow(label: 'Max Discharge Rate', value: '6.0 kW'),
        const SizedBox(height: 8),
        _HardwareRow(label: 'Nominal Capacity', value: '15.0 kWh'),
        const SizedBox(height: 8),
        _HardwareRow(label: 'Usable Capacity', value: '13.5 kWh'),
      ]),
    );
  }
}

class _HardwareRow extends StatelessWidget {
  const _HardwareRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: tt.bodySmall),
      Text(value,
          style: tt.bodySmall?.copyWith(
              color: AppColors.onSurface, fontWeight: FontWeight.w600)),
    ]);
  }
}

// ── AI Status Card (sidebar) ──────────────────────────────────────────────────

class _AiStatusCard extends StatelessWidget {
  const _AiStatusCard({required this.aiEnabled});
  final bool aiEnabled;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.psychology_rounded,
              size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text('Work Mode', style: tt.titleMedium),
          ),
        ]),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: aiEnabled ? AppGradients.primaryCta : null,
            color: aiEnabled ? null : AppColors.surfaceContainerHigh,
            borderRadius: AppRadius.radiusMd,
          ),
          child: Column(children: [
            Text(
              aiEnabled ? 'AI Kinetic' : 'Manual Mode',
              style: tt.headlineSmall?.copyWith(
                color: aiEnabled ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              aiEnabled ? 'Learning User Behavior' : 'Fixed schedule active',
              style: tt.bodySmall?.copyWith(
                color: aiEnabled
                    ? AppColors.onPrimary.withValues(alpha: 0.8)
                    : AppColors.outline,
              ),
            ),
          ]),
        ),
        if (aiEnabled) ...[
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Cycles analysed', style: tt.bodySmall),
            Text('247',
                style: tt.bodySmall
                    ?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Model accuracy', style: tt.bodySmall),
            Text('93.4%',
                style: tt.bodySmall
                    ?.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w700)),
          ]),
        ],
      ]),
    );
  }
}

// ── API Integrations ──────────────────────────────────────────────────────────

class _ApiIntegrationsCard extends StatelessWidget {
  const _ApiIntegrationsCard({
    required this.deye,
    required this.solcast,
    required this.pstryk,
    required this.onDeyeChanged,
    required this.onSolcastChanged,
    required this.onPstrykChanged,
  });

  final bool deye;
  final bool solcast;
  final bool pstryk;
  final ValueChanged<bool> onDeyeChanged;
  final ValueChanged<bool> onSolcastChanged;
  final ValueChanged<bool> onPstrykChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SectionHeader(title: 'API Integrations'),
        const SizedBox(height: 16),
        _IntegrationRow(
          icon: Icons.developer_board_rounded,
          label: 'Deye Cloud Sync',
          detail: 'Last sync: 2 mins ago',
          enabled: deye,
          onChanged: onDeyeChanged,
          color: AppColors.secondary,
        ),
        const SizedBox(height: 12),
        _IntegrationRow(
          icon: Icons.wb_sunny_rounded,
          label: 'Solcast Forecasting',
          detail: 'Solar irradiance prediction',
          enabled: solcast,
          onChanged: onSolcastChanged,
          color: AppColors.tertiary,
        ),
        const SizedBox(height: 12),
        _IntegrationRow(
          icon: Icons.price_change_rounded,
          label: 'Pstryk Pricing Hub',
          detail: 'Connected: Warsaw Zone 1',
          enabled: pstryk,
          onChanged: onPstrykChanged,
          color: AppColors.primary,
        ),
      ]),
    );
  }
}

class _IntegrationRow extends StatelessWidget {
  const _IntegrationRow({
    required this.icon,
    required this.label,
    required this.detail,
    required this.enabled,
    required this.onChanged,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String detail;
  final bool enabled;
  final ValueChanged<bool> onChanged;
  final Color color;

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
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: enabled ? color.withValues(alpha: 0.12) : AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon,
              size: 18,
              color: enabled ? color : AppColors.onSurfaceVariant),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
            Text(detail, style: tt.bodySmall),
          ]),
        ),
        Switch(
          value: enabled,
          onChanged: onChanged,
          activeColor: color,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ]),
    );
  }
}

// ── Danger Zone ───────────────────────────────────────────────────────────────

class _DangerZoneCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.warning_amber_rounded,
              size: 16, color: AppColors.tertiary),
          const SizedBox(width: 8),
          Text('Danger Zone',
              style: tt.titleMedium?.copyWith(color: AppColors.tertiary)),
        ]),
        const SizedBox(height: 16),
        GhostButton(
          label: 'Reset AI Model',
          icon: Icons.refresh_rounded,
          width: double.infinity,
          onPressed: () {},
        ),
        const SizedBox(height: 10),
        // Sign out button
        GestureDetector(
          onTap: () => sessionManager.signOutDevice(),
          child: Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.errorContainer.withValues(alpha: 0.20),
              borderRadius: AppRadius.radiusMd,
              border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.25), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout_rounded,
                    size: 16, color: AppColors.error),
                const SizedBox(width: 8),
                Text('Sign Out',
                    style: tt.bodyMedium?.copyWith(
                        color: AppColors.error, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
