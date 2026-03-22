import 'dart:convert';

import 'package:deyelyte_client/deyelyte_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../theme/theme.dart';
import '../utils/date_format.dart';
import '../components/components.dart';
import '../providers/app_providers.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _configLoaded = false;
  bool _statusLoaded = false;
  bool _rangesLoaded = false; // ignore: unused_field
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    // Populate local settings from server config once on first load.
    ref.listen<AsyncValue<AppConfig?>>(appConfigProvider, (_, next) {
      if (_configLoaded) return;
      final config = next.valueOrNull;
      if (config != null) {
        _configLoaded = true;
        ref.read(settingsProvider.notifier).loadFrom(config);
      } else if (next is AsyncData) {
        // Server returned null — no config yet, use defaults.
        _configLoaded = true;
      }
    });

    // Populate integration-enabled flags from server once on first load.
    ref.listen<AsyncValue<Map<String, bool>>>(integrationStatusProvider,
        (_, next) {
      if (_statusLoaded) return;
      final status = next.valueOrNull;
      if (status != null) {
        _statusLoaded = true;
        ref.read(settingsProvider.notifier).loadIntegrationStatus(status);
      } else if (next is AsyncData) {
        _statusLoaded = true;
      }
    });

    // Populate price time ranges from server once on first load.
    ref.listen<AsyncValue<List<PriceTimeRange>>>(priceTimeRangesProvider,
        (_, next) {
      if (_rangesLoaded) return;
      final ranges = next.valueOrNull;
      if (ranges != null) {
        _rangesLoaded = true;
        ref.read(settingsProvider.notifier).setPriceTimeRanges(ranges);
      } else if (next is AsyncData) {
        _rangesLoaded = true;
      }
    });

    final configAsync = ref.watch(appConfigProvider);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final config = configAsync.valueOrNull;
    final addonStatus = ref.watch(addonStatusProvider).valueOrNull;
    final addonEverConnected = addonStatus?['lastSeenAt'] != null;
    final lockInfo = _emsLockInfo(config, addonEverConnected: addonEverConnected);
    final since = config?.dataGatheringSince;
    final unlockDate = since?.add(const Duration(days: 7));
    final baselineLocked = addonEverConnected &&
        (since == null ||
            (unlockDate != null &&
                DateTime.now().toUtc().isBefore(unlockDate)));

    if (configAsync.isLoading && !_configLoaded) {
      return const Scaffold(
        backgroundColor: AppColors.surface,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saving ? null : _save,
        icon: _saving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.save_rounded),
        label: const Text('Save'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? AppSpacing.sp6 : AppSpacing.sp4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SettingsHeader(),
              const SizedBox(height: AppSpacing.sp4),
              if (lockInfo != null) ...[
                _EmsLockBanner(message: lockInfo),
                const SizedBox(height: AppSpacing.sp4),
              ],
              AsymmetricGrid(
                primaryFlex: 6,
                sidebarFlex: 4,
                gap: AppSpacing.sp4,
                primary: Column(children: [
                  IgnorePointer(
                    ignoring: lockInfo != null,
                    child: Opacity(
                      opacity: lockInfo != null ? 0.45 : 1.0,
                      child: _EmsControlCard(
                        chargingEnabled: settings.chargingEnabled,
                        sellingEnabled: settings.sellingEnabled,
                        pvOnlySelling: settings.pvOnlySelling,
                        planningOnly: settings.planningOnly,
                        hasBaseline: settings.hasBaseline,
                        priceSourceReady: settings.isPriceSourceReady,
                        priceSource: settings.priceSource,
                        maxBuyPrice: settings.maxBuyPrice,
                        minSellPrice: settings.minSellPrice,
                        baselineLocked: baselineLocked,
                        baselineUnlockDate: unlockDate,
                        onChargingChanged: notifier.setChargingEnabled,
                        onSellingChanged: notifier.setSellingEnabled,
                        onPvOnlySellingChanged: notifier.setPvOnlySelling,
                        onPlanningOnlyChanged: notifier.setPlanningOnly,
                        onMaxBuyPriceChanged: notifier.setMaxBuyPrice,
                        onMinSellPriceChanged: notifier.setMinSellPrice,
                        onRestoreBaseline: notifier.restoreToBaseline,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sp4),
                  _ThresholdsCard(
                    minSoc: settings.minSoc,
                    onMinSocChanged: notifier.setMinSoc,
                  ),
                  const SizedBox(height: AppSpacing.sp4),
                  _HardwareCard(
                    batteryCapacityKwh: settings.batteryCapacityKwh,
                    batteryCost: settings.batteryCost,
                    batteryLifecycles: settings.batteryLifecycles,
                    maxDischargeRateKw: settings.maxDischargeRateKw,
                    maxChargeRateKw: settings.maxChargeRateKw,
                    gridConnectionKw: settings.gridConnectionKw,
                    onCapacityChanged: notifier.setBatteryCapacityKwh,
                    onCostChanged: notifier.setBatteryCost,
                    onLifecyclesChanged: notifier.setBatteryLifecycles,
                    onDischargeRateChanged: notifier.setMaxDischargeRateKw,
                    onChargeRateChanged: notifier.setMaxChargeRateKw,
                    onGridConnectionChanged: notifier.setGridConnectionKw,
                  ),
                ]),
                sidebar: Column(children: [
                  _EmsStatusCard(
                    chargingEnabled: settings.chargingEnabled,
                    sellingEnabled: settings.sellingEnabled,
                    pvOnlySelling: settings.pvOnlySelling,
                    maxBuyPrice: settings.maxBuyPrice,
                    minSoc: settings.minSoc,
                  ),
                  const SizedBox(height: AppSpacing.sp4),
                  _PricingSourceCard(
                    priceSource: settings.priceSource,
                    fixedBuyRate: settings.fixedBuyRatePln,
                    fixedSellRate: settings.fixedSellRatePln,
                    priceTimeRanges: settings.priceTimeRanges,
                    onSourceChanged: notifier.setPriceSource,
                    onFixedBuyChanged: notifier.setFixedBuyRatePln,
                    onFixedSellChanged: notifier.setFixedSellRatePln,
                    onRangesChanged: notifier.setPriceTimeRanges,
                  ),
                  const SizedBox(height: AppSpacing.sp4),
                  _ApiIntegrationsCard(
                    solcast: settings.solcast,
                    pstryk: settings.pstryk,
                    cityName: settings.cityName,
                    onSolcastChanged: notifier.setSolcast,
                    onCityNameChanged: notifier.setCityName,
                  ),
                  if (settings.hasBaseline) ...[
                    const SizedBox(height: AppSpacing.sp4),
                    _BaselineInfoCard(settings: settings),
                  ],
                  const SizedBox(height: AppSpacing.sp4),
                  const _DangerZoneCard(),
                ]),
              ),
              // Extra bottom padding so FAB doesn't overlap last card.
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns a human-readable reason why EMS control is locked, or null if
  /// the controls are available.
  String? _emsLockInfo(AppConfig? config, {bool addonEverConnected = false}) {
    if (config == null || config.dataGatheringSince == null) {
      if (addonEverConnected) return null; // add-on connected, baseline not started yet — no banner
      return 'Install the DeyLyte add-on in Home Assistant to enable EMS control. '
          'After connecting, a 7-day baseline collection period begins.';
    }
    final since = config.dataGatheringSince!;
    final unlockDate = since.add(const Duration(days: 7));
    if (DateTime.now().toUtc().isBefore(unlockDate)) {
      final day = '${unlockDate.day.toString().padLeft(2, '0')}.'
          '${unlockDate.month.toString().padLeft(2, '0')}.'
          '${unlockDate.year}';
      return 'Add-on connected. Collecting baseline data — EMS control unlocks on $day. '
          'Your inverter continues operating normally during this period.';
    }
    return null;
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final s = ref.read(settingsProvider);
      // Preserve topUpRequested from the existing config if available.
      final existing = ref.read(appConfigProvider).valueOrNull;
      final config = AppConfig(
        userInfoId: 0, // server always overwrites with authenticated user's id
        chargingEnabled: s.chargingEnabled,
        sellingEnabled: s.sellingEnabled,
        pvOnlySelling: s.pvOnlySelling,
        topUpRequested: existing?.topUpRequested ?? false,
        alwaysChargePriceThreshold: s.maxBuyPrice,
        minSellPriceThreshold: s.minSellPrice,
        batteryCapacityKwh: s.batteryCapacityKwh,
        batteryCost: s.batteryCost,
        batteryLifecycles: s.batteryLifecycles,
        minSocPercentage: s.minSoc,
        maxDischargeRateKw: s.maxDischargeRateKw,
        maxChargeRateKw: s.maxChargeRateKw,
        gridConnectionKw: s.gridConnectionKw,
        cityName: s.cityName,
        latitude: existing?.latitude,
        longitude: existing?.longitude,
        priceSource: s.priceSource,
        fixedBuyRatePln: s.fixedBuyRatePln,
        fixedSellRatePln: s.fixedSellRatePln,
        planningOnly: s.planningOnly,
        pstrykEnabled: existing?.pstrykEnabled ?? false,
      );
      await ref.read(appConfigProvider.notifier).save(config);
      await ref
          .read(clientProvider)
          .priceTimeRanges
          .saveTimeRanges(s.priceTimeRanges);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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
        'Configure charging and selling rules, battery specs, and integrations.',
        style: tt.bodySmall,
      ),
    ]);
  }
}

// ── EMS Control ───────────────────────────────────────────────────────────────

class _EmsControlCard extends StatefulWidget {
  const _EmsControlCard({
    required this.chargingEnabled,
    required this.sellingEnabled,
    required this.pvOnlySelling,
    required this.planningOnly,
    required this.hasBaseline,
    required this.priceSourceReady,
    required this.priceSource,
    required this.maxBuyPrice,
    required this.minSellPrice,
    required this.baselineLocked,
    required this.baselineUnlockDate,
    required this.onChargingChanged,
    required this.onSellingChanged,
    required this.onPvOnlySellingChanged,
    required this.onPlanningOnlyChanged,
    required this.onMaxBuyPriceChanged,
    required this.onMinSellPriceChanged,
    required this.onRestoreBaseline,
  });

  final bool chargingEnabled;
  final bool sellingEnabled;
  final bool pvOnlySelling;
  final bool planningOnly;
  final bool hasBaseline;
  final bool priceSourceReady;
  final String priceSource;
  final double maxBuyPrice;
  final double? minSellPrice;
  final bool baselineLocked;
  final DateTime? baselineUnlockDate;
  final ValueChanged<bool> onChargingChanged;
  final ValueChanged<bool> onSellingChanged;
  final ValueChanged<bool> onPvOnlySellingChanged;
  final ValueChanged<bool> onPlanningOnlyChanged;
  final ValueChanged<double> onMaxBuyPriceChanged;
  final ValueChanged<double?> onMinSellPriceChanged;
  final VoidCallback onRestoreBaseline;

  @override
  State<_EmsControlCard> createState() => _EmsControlCardState();
}

class _EmsControlCardState extends State<_EmsControlCard> {
  late final TextEditingController _buyPriceCtrl;
  late final TextEditingController _sellPriceCtrl;

  @override
  void initState() {
    super.initState();
    _buyPriceCtrl = TextEditingController(
        text: widget.maxBuyPrice.toStringAsFixed(4));
    _sellPriceCtrl = TextEditingController(
        text: widget.minSellPrice?.toStringAsFixed(4) ?? '');
  }

  @override
  void dispose() {
    _buyPriceCtrl.dispose();
    _sellPriceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(title: 'EMS Control'),
        const SizedBox(height: 20),

        // ── Planning Mode ─────────────────────────────────────────────────────
        IgnorePointer(
          ignoring: widget.baselineLocked,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: widget.baselineLocked ? 0.5 : 1.0,
            child: _ToggleSetting(
              icon: Icons.visibility_outlined,
              iconColor: AppColors.primary,
              label: 'Planning Mode',
              detail: widget.planningOnly
                  ? 'Optimizer runs and generates schedule — no commands sent to inverter.'
                  : 'Live mode: optimizer controls the inverter directly.',
              value: widget.planningOnly,
              onChanged: widget.onPlanningOnlyChanged,
            ),
          ),
        ),
        if (widget.baselineLocked) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.06),
              borderRadius: AppRadius.radiusMd,
              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.25)),
            ),
            child: Row(children: [
              const Icon(Icons.hourglass_top_rounded, size: 14, color: AppColors.secondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.baselineUnlockDate != null
                      ? 'Collecting 7-day baseline — EMS control unlocks on '
                        '${widget.baselineUnlockDate!.day.toString().padLeft(2, '0')}.'
                        '${widget.baselineUnlockDate!.month.toString().padLeft(2, '0')}.'
                        '${widget.baselineUnlockDate!.year}.'
                      : 'Collecting 7-day baseline — EMS control unlocks soon.',
                  style: tt.bodySmall?.copyWith(color: AppColors.secondary),
                ),
              ),
            ]),
          ),
        ] else if (widget.planningOnly) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: AppRadius.radiusMd,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(children: [
              const Icon(Icons.info_outline_rounded,
                  size: 14, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Charging and selling settings below are saved but ignored '
                  'until you disable Planning Mode.',
                  style: tt.bodySmall?.copyWith(color: AppColors.primary),
                ),
              ),
            ]),
          ),
          if (widget.hasBaseline) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.restore_rounded, size: 16),
              label: const Text('Restore to baseline settings'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
                textStyle: tt.labelSmall,
              ),
              onPressed: widget.onRestoreBaseline,
            ),
          ],
        ],

        const SizedBox(height: 20),
        const Divider(height: 1),
        const SizedBox(height: 20),

        // ── Charging / selling (dimmed in planning mode) ──────────────────────
        IgnorePointer(
          ignoring: widget.planningOnly,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: widget.planningOnly ? 0.4 : 1.0,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // ── Price source not ready warning ────────────────────────────────────
        if (!widget.priceSourceReady) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.tertiary.withValues(alpha: 0.08),
              borderRadius: AppRadius.radiusMd,
              border: Border.all(
                  color: AppColors.tertiary.withValues(alpha: 0.3)),
            ),
            child: Row(children: [
              const Icon(Icons.warning_amber_rounded,
                  size: 14, color: AppColors.tertiary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  switch (widget.priceSource) {
                    'pstryk' => 'Connect your Pstryk account in the integrations section below to enable grid charging and selling.',
                    'rce' => 'Add at least one distribution charge range in the Pricing Source card to enable grid charging and selling.',
                    _ => 'Enter fixed buy and sell rates in the Pricing Source card to enable grid charging and selling.',
                  },
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.tertiary),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),
        ],

        // ── Charging section ──────────────────────────────────────────────────
        IgnorePointer(
          ignoring: !widget.priceSourceReady,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: widget.priceSourceReady ? 1.0 : 0.4,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _ToggleSetting(
          icon: Icons.bolt_rounded,
          iconColor: AppColors.primary,
          label: 'Charge from Grid',
          detail: widget.chargingEnabled
              ? 'Buying at or below the price threshold below.'
              : 'Grid charging disabled. Inverter charges from PV only.',
          value: widget.chargingEnabled,
          onChanged: widget.onChargingChanged,
        ),
        if (widget.chargingEnabled) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: _PriceField(
              label: 'Max buy price',
              controller: _buyPriceCtrl,
              suffix: 'PLN/kWh',
              hint: '0.0000',
              detail: 'Charge when grid price is at or below this. Use 0.00 for free/negative energy only.',
              onChanged: (v) => widget.onMaxBuyPriceChanged(v ?? 0.0),
            ),
          ),
        ],

        const SizedBox(height: 20),
        const Divider(height: 1),
        const SizedBox(height: 20),

        // ── Selling section ───────────────────────────────────────────────────
        _ToggleSetting(
          icon: Icons.upload_rounded,
          iconColor: AppColors.secondary,
          label: 'Sell to Grid',
          detail: widget.sellingEnabled
              ? 'Discharging when selling is profitable.'
              : 'Grid selling disabled. Battery used for self-consumption only.',
          value: widget.sellingEnabled,
          onChanged: widget.onSellingChanged,
        ),
        if (widget.sellingEnabled) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Grid arbitrage opt-in
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: AppRadius.radiusMd,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Grid Arbitrage',
                                  style: tt.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 2),
                              Text(
                                widget.pvOnlySelling
                                    ? 'Off — only selling energy generated by PV.'
                                    : 'On — may buy from grid cheaply to sell at peak.',
                                style: tt.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: !widget.pvOnlySelling,
                          onChanged: (v) =>
                              widget.onPvOnlySellingChanged(!v),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ]),
                      if (!widget.pvOnlySelling) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppColors.tertiary.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color:
                                    AppColors.tertiary.withValues(alpha: 0.25)),
                          ),
                          child: Row(children: [
                            const Icon(Icons.info_outline_rounded,
                                size: 13, color: AppColors.tertiary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Grid arbitrage enabled. The EMS may charge from cheap grid energy and sell it at peak prices.',
                                style: tt.labelSmall
                                    ?.copyWith(color: AppColors.tertiary),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _PriceField(
                  label: 'Min sell price',
                  controller: _sellPriceCtrl,
                  suffix: 'PLN/kWh',
                  hint: 'any profitable price',
                  optional: true,
                  detail: 'Only sell when grid price exceeds this. Leave empty to sell at any profitable spread.',
                  onChanged: widget.onMinSellPriceChanged,
                ),
              ],
            ),
          ),
        ],
            ]),    // inner Column children (charge + sell)
          ),       // AnimatedOpacity
        ),         // IgnorePointer (priceSourceReady gate)
      ]),          // outer Column children (planning mode + charge/sell)
      ),           // outer AnimatedOpacity
      ),           // outer IgnorePointer (planningOnly gate)
      ]),          // SurfaceCard Column children
    );
  }
}

// ── Thresholds ────────────────────────────────────────────────────────────────

class _ThresholdsCard extends StatelessWidget {
  const _ThresholdsCard({
    required this.minSoc,
    required this.onMinSocChanged,
  });

  final double minSoc;
  final ValueChanged<double> onMinSocChanged;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(title: 'Battery Reserve'),
        const SizedBox(height: 20),
        _SliderSetting(
          icon: Icons.battery_alert_rounded,
          iconColor: AppColors.error,
          label: 'Minimum SoC',
          detail:
              'The EMS will never discharge the battery below this level. Protects battery longevity.',
          value: minSoc,
          valueLabel: '${(minSoc * 100).round()}%',
          onChanged: onMinSocChanged,
          activeColor: AppColors.error,
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
          max: 0.80,
          divisions: 15,
          onChanged: onChanged,
        ),
      ),
    ]);
  }
}

// ── Hardware Setup ────────────────────────────────────────────────────────────

class _HardwareCard extends StatefulWidget {
  const _HardwareCard({
    required this.batteryCapacityKwh,
    required this.batteryCost,
    required this.batteryLifecycles,
    required this.maxDischargeRateKw,
    required this.maxChargeRateKw,
    required this.gridConnectionKw,
    required this.onCapacityChanged,
    required this.onCostChanged,
    required this.onLifecyclesChanged,
    required this.onDischargeRateChanged,
    required this.onChargeRateChanged,
    required this.onGridConnectionChanged,
  });

  final double batteryCapacityKwh;
  final double? batteryCost;
  final int batteryLifecycles;
  final double maxDischargeRateKw;
  final double? maxChargeRateKw;
  final double? gridConnectionKw;
  final ValueChanged<double> onCapacityChanged;
  final ValueChanged<double?> onCostChanged;
  final ValueChanged<int> onLifecyclesChanged;
  final ValueChanged<double> onDischargeRateChanged;
  final ValueChanged<double?> onChargeRateChanged;
  final ValueChanged<double?> onGridConnectionChanged;

  @override
  State<_HardwareCard> createState() => _HardwareCardState();
}

class _HardwareCardState extends State<_HardwareCard> {
  late final TextEditingController _capacityCtrl;
  late final TextEditingController _costCtrl;
  late final TextEditingController _lifecyclesCtrl;
  late final TextEditingController _dischargeRateCtrl;
  late final TextEditingController _chargeRateCtrl;
  late final TextEditingController _gridConnectionCtrl;

  @override
  void initState() {
    super.initState();
    _capacityCtrl = TextEditingController(
        text: widget.batteryCapacityKwh.toStringAsFixed(1));
    _costCtrl = TextEditingController(
        text: widget.batteryCost?.toStringAsFixed(0) ?? '');
    _lifecyclesCtrl = TextEditingController(
        text: widget.batteryLifecycles.toString());
    _dischargeRateCtrl = TextEditingController(
        text: widget.maxDischargeRateKw.toStringAsFixed(1));
    _chargeRateCtrl = TextEditingController(
        text: widget.maxChargeRateKw?.toStringAsFixed(1) ?? '');
    _gridConnectionCtrl = TextEditingController(
        text: widget.gridConnectionKw?.toStringAsFixed(1) ?? '');
  }

  @override
  void dispose() {
    _capacityCtrl.dispose();
    _costCtrl.dispose();
    _lifecyclesCtrl.dispose();
    _dischargeRateCtrl.dispose();
    _chargeRateCtrl.dispose();
    _gridConnectionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(title: 'Hardware Setup'),
        const SizedBox(height: 16),

        // Inverter display row (static, will be enriched by Deye API later)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: AppRadius.radiusMd,
          ),
          child: Row(children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppGradients.profitGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.developer_board_rounded,
                  color: AppColors.onSecondary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Deye Inverter',
                        style: tt.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text('Specs auto-filled once Deye Cloud is connected.',
                        style:
                            tt.bodySmall?.copyWith(color: AppColors.outline)),
                  ]),
            ),
          ]),
        ),

        const SizedBox(height: 20),
        Text('Battery Specifications',
            style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(
          'Used by the optimizer for wear cost and SoC planning. Will be pre-filled from inverter data once Deye integration is active.',
          style: tt.bodySmall?.copyWith(color: AppColors.outline),
        ),
        const SizedBox(height: 16),

        Row(children: [
          Expanded(
            child: _NumericField(
              label: 'Capacity',
              controller: _capacityCtrl,
              suffix: 'kWh',
              onChanged: (v) {
                if (v != null) widget.onCapacityChanged(v);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _NumericField(
              label: 'Grid Connection',
              controller: _gridConnectionCtrl,
              suffix: 'kW',
              onChanged: widget.onGridConnectionChanged,
            ),
          ),
        ]),
        const SizedBox(height: 4),
        Text(
          'Grid connection limit. Battery charging scales down to keep total draw within breaker capacity.',
          style: tt.bodySmall?.copyWith(color: AppColors.outline),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: _NumericField(
              label: 'Max Charge Rate',
              controller: _chargeRateCtrl,
              suffix: 'kW',
              onChanged: widget.onChargeRateChanged,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _NumericField(
              label: 'Max Discharge Rate',
              controller: _dischargeRateCtrl,
              suffix: 'kW',
              onChanged: (v) {
                if (v != null) widget.onDischargeRateChanged(v);
              },
            ),
          ),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: _NumericField(
              label: 'Battery Cost',
              controller: _costCtrl,
              suffix: 'PLN',
              optional: true,
              onChanged: widget.onCostChanged,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _NumericField(
              label: 'Rated Cycles',
              controller: _lifecyclesCtrl,
              hint: '6000',
              optional: true,
              onChanged: (v) {
                if (v != null) widget.onLifecyclesChanged(v.toInt());
              },
            ),
          ),
        ]),
      ]),
    );
  }
}

// ── EMS Status (sidebar) ──────────────────────────────────────────────────────

class _EmsStatusCard extends StatelessWidget {
  const _EmsStatusCard({
    required this.chargingEnabled,
    required this.sellingEnabled,
    required this.pvOnlySelling,
    required this.maxBuyPrice,
    required this.minSoc,
  });

  final bool chargingEnabled;
  final bool sellingEnabled;
  final bool pvOnlySelling;
  final double maxBuyPrice;
  final double minSoc;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    final String modeLabel;
    final String modeDetail;
    final Color modeColor;
    final bool isActive;

    if (chargingEnabled && sellingEnabled) {
      modeLabel = 'Full EMS';
      modeDetail = 'Charging & selling optimised';
      modeColor = AppColors.secondary;
      isActive = true;
    } else if (chargingEnabled) {
      modeLabel = 'Charging Only';
      modeDetail = 'Grid buying active';
      modeColor = AppColors.primary;
      isActive = true;
    } else if (sellingEnabled) {
      modeLabel = 'Selling Only';
      modeDetail = 'Grid discharge active';
      modeColor = AppColors.secondary;
      isActive = true;
    } else {
      modeLabel = 'EMS Standby';
      modeDetail = 'Inverter self-managed';
      modeColor = AppColors.outline;
      isActive = false;
    }

    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.auto_mode_rounded,
              size: 18, color: isActive ? modeColor : AppColors.outline),
          const SizedBox(width: 8),
          Text('EMS Status', style: tt.titleMedium),
        ]),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: isActive
                ? LinearGradient(
                    colors: [
                      modeColor.withValues(alpha: 0.15),
                      modeColor.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isActive ? null : AppColors.surfaceContainerHigh,
            borderRadius: AppRadius.radiusMd,
            border: isActive
                ? Border.all(color: modeColor.withValues(alpha: 0.25))
                : null,
          ),
          child: Column(children: [
            Text(
              modeLabel,
              style: tt.headlineSmall?.copyWith(
                color: isActive ? modeColor : AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              modeDetail,
              style: tt.bodySmall?.copyWith(
                color: isActive
                    ? modeColor.withValues(alpha: 0.8)
                    : AppColors.outline,
              ),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        _StatusRow(
          label: 'Battery reserve',
          value: '${(minSoc * 100).round()}%',
          color: AppColors.error,
        ),
        const SizedBox(height: 8),
        _StatusRow(
          label: 'Grid charging',
          value: chargingEnabled
              ? '≤ ${maxBuyPrice.toStringAsFixed(4)} PLN/kWh'
              : 'Off',
          color: chargingEnabled ? AppColors.primary : AppColors.outline,
        ),
        const SizedBox(height: 8),
        _StatusRow(
          label: 'Selling mode',
          value: !sellingEnabled
              ? 'Off'
              : pvOnlySelling
                  ? 'PV only'
                  : 'Grid arbitrage',
          color: sellingEnabled
              ? (pvOnlySelling ? AppColors.secondary : AppColors.tertiary)
              : AppColors.outline,
        ),
      ]),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow(
      {required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: tt.bodySmall),
      Text(value,
          style: tt.bodySmall
              ?.copyWith(color: color, fontWeight: FontWeight.w600)),
    ]);
  }
}

// ── Price Source Picker ────────────────────────────────────────────────────────

class _PriceSourcePicker extends StatelessWidget {
  const _PriceSourcePicker({
    required this.selected,
    required this.onChanged,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  static const _options = [
    ('pstryk', 'Pstryk'),
    ('rce', 'RCE'),
    ('fixed', 'Fixed'),
  ];

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _options.map((opt) {
          final (value, label) = opt;
          final isSelected = selected == value;
          return GestureDetector(
            onTap: () => onChanged(value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeInOut,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                label,
                style: tt.bodySmall?.copyWith(
                  color: isSelected
                      ? AppColors.surface
                      : AppColors.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Pricing Source ─────────────────────────────────────────────────────────────

class _PricingSourceCard extends StatefulWidget {
  const _PricingSourceCard({
    required this.priceSource,
    required this.fixedBuyRate,
    required this.fixedSellRate,
    required this.priceTimeRanges,
    required this.onSourceChanged,
    required this.onFixedBuyChanged,
    required this.onFixedSellChanged,
    required this.onRangesChanged,
  });

  final String priceSource;
  final double? fixedBuyRate;
  final double? fixedSellRate;
  final List<PriceTimeRange> priceTimeRanges;
  final ValueChanged<String> onSourceChanged;
  final ValueChanged<double?> onFixedBuyChanged;
  final ValueChanged<double?> onFixedSellChanged;
  final ValueChanged<List<PriceTimeRange>> onRangesChanged;

  @override
  State<_PricingSourceCard> createState() => _PricingSourceCardState();
}

class _PricingSourceCardState extends State<_PricingSourceCard> {
  late final TextEditingController _fixedBuyCtrl;
  late final TextEditingController _fixedSellCtrl;

  @override
  void initState() {
    super.initState();
    _fixedBuyCtrl = TextEditingController(
        text: widget.fixedBuyRate?.toStringAsFixed(4) ?? '');
    _fixedSellCtrl = TextEditingController(
        text: widget.fixedSellRate?.toStringAsFixed(4) ?? '');
  }

  @override
  void dispose() {
    _fixedBuyCtrl.dispose();
    _fixedSellCtrl.dispose();
    super.dispose();
  }

  void _addRange() async {
    final result = await showDialog<PriceTimeRange>(
      context: context,
      builder: (_) => _RangeEditorDialog(
        showSellRate: widget.priceSource == 'fixed',
      ),
    );
    if (result != null) {
      widget.onRangesChanged([...widget.priceTimeRanges, result]);
    }
  }

  void _deleteRange(int index) {
    final updated = List<PriceTimeRange>.from(widget.priceTimeRanges)
      ..removeAt(index);
    widget.onRangesChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final showRanges = widget.priceSource == 'rce' || widget.priceSource == 'fixed';

    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(title: 'Pricing Source'),
        const SizedBox(height: 16),
        // Source selector
        _PriceSourcePicker(
          selected: widget.priceSource,
          onChanged: widget.onSourceChanged,
        ),
        const SizedBox(height: 4),
        Text(
          switch (widget.priceSource) {
            'pstryk' => 'Hourly buy/sell prices from the Pstryk API.',
            'rce' =>
              'RCE wholesale market prices (PSE) plus per-range distribution charges.',
            _ => 'Fixed buy/sell rates, optionally varied by time range.',
          },
          style: tt.bodySmall?.copyWith(color: AppColors.outline),
        ),

        // ── Fixed: fallback rates ──────────────────────────────────────────
        if (widget.priceSource == 'fixed' || widget.priceSource == 'manual') ...[
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Text('Fallback rates (used when no range covers the hour)',
              style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          _PriceField(
            label: 'Buy rate',
            controller: _fixedBuyCtrl,
            suffix: 'PLN/kWh',
            hint: '0.0000',
            detail: 'Default buy price when no time range covers that hour.',
            onChanged: (v) => widget.onFixedBuyChanged(v),
          ),
          const SizedBox(height: 12),
          _PriceField(
            label: 'Sell rate',
            controller: _fixedSellCtrl,
            suffix: 'PLN/kWh',
            hint: '0.0000',
            detail: 'Default sell price when no time range covers that hour.',
            onChanged: (v) => widget.onFixedSellChanged(v),
          ),
        ],

        // ── RCE / Fixed: time ranges ──────────────────────────────────────
        if (showRanges) ...[
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Text(
            widget.priceSource == 'rce'
                ? 'Distribution charge ranges'
                : 'Per-hour rate ranges',
            style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            widget.priceSource == 'rce'
                ? 'Each range adds a distribution charge on top of the RCE price for those hours.'
                : 'Each range sets buy (and optionally sell) rates for those hours.',
            style: tt.bodySmall?.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 8),
          if (widget.priceTimeRanges.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'No ranges defined.',
                style: tt.bodySmall?.copyWith(color: AppColors.outline),
              ),
            )
          else
            ...widget.priceTimeRanges.asMap().entries.map((entry) {
              final i = entry.key;
              final r = entry.value;
              final sellLabel = r.sellRatePln != null
                  ? ' / sell ${r.sellRatePln!.toStringAsFixed(4)}'
                  : '';
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: AppRadius.radiusMd,
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Text(
                        'Hour ${r.hourStart.toString().padLeft(2, '0')}–'
                        '${r.hourEnd.toString().padLeft(2, '0')}  '
                        '${r.distributionRatePln.toStringAsFixed(4)} PLN/kWh$sellLabel',
                        style: tt.bodySmall,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _deleteRange(i),
                      child: const Icon(Icons.close_rounded,
                          size: 16, color: AppColors.outline),
                    ),
                  ]),
                ),
              );
            }),
          const SizedBox(height: 4),
          TextButton.icon(
            onPressed: _addRange,
            icon: const Icon(Icons.add_rounded, size: 16),
            label: const Text('Add range'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
        ],
      ]),
    );
  }
}

// ── Range Editor Dialog ────────────────────────────────────────────────────────

class _RangeEditorDialog extends StatefulWidget {
  const _RangeEditorDialog({required this.showSellRate});
  final bool showSellRate;

  @override
  State<_RangeEditorDialog> createState() => _RangeEditorDialogState();
}

class _RangeEditorDialogState extends State<_RangeEditorDialog> {
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _sellCtrl = TextEditingController();

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _rateCtrl.dispose();
    _sellCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text('Add time range'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Expanded(
            child: _HourField(
              label: 'From hour',
              controller: _fromCtrl,
              onChanged: (_) {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _HourField(
              label: 'To hour',
              controller: _toCtrl,
              onChanged: (_) {},
            ),
          ),
        ]),
        const SizedBox(height: 12),
        _PriceField(
          label: 'Rate',
          controller: _rateCtrl,
          suffix: 'PLN/kWh',
          hint: '0.0000',
          detail: widget.showSellRate
              ? 'Buy rate for this window.'
              : 'Distribution charge for this window.',
          onChanged: (_) {},
        ),
        if (widget.showSellRate) ...[
          const SizedBox(height: 12),
          _PriceField(
            label: 'Sell rate (optional)',
            controller: _sellCtrl,
            suffix: 'PLN/kWh',
            hint: '0.0000',
            optional: true,
            detail: 'Sell rate for this window.',
            onChanged: (_) {},
          ),
        ],
      ]),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final from = int.tryParse(_fromCtrl.text);
            final to = int.tryParse(_toCtrl.text);
            final rate = double.tryParse(_rateCtrl.text);
            if (from == null || to == null || rate == null) return;
            final sellRate = double.tryParse(_sellCtrl.text);
            Navigator.of(context).pop(PriceTimeRange(
              userInfoId: 0, // server overwrites
              hourStart: from,
              hourEnd: to,
              distributionRatePln: rate,
              sellRatePln: sellRate,
            ));
          },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}

/// A small integer text field for entering an hour (0–23).
class _HourField extends StatelessWidget {
  const _HourField({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
      const SizedBox(height: 4),
      TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: AppColors.onSurface),
        decoration: InputDecoration(
          hintText: '0–23',
          hintStyle:
              const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13),
          filled: true,
          fillColor: AppColors.surfaceContainerHigh,
          border: OutlineInputBorder(
            borderRadius: AppRadius.radiusMd,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.radiusMd,
            borderSide:
                const BorderSide(color: AppColors.outlineVariant, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.radiusMd,
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        onChanged: (v) {
          final parsed = int.tryParse(v);
          onChanged(parsed != null && parsed >= 0 && parsed <= 23
              ? parsed
              : null);
        },
      ),
    ]);
  }
}

// ── API Integrations ──────────────────────────────────────────────────────────

class _ApiIntegrationsCard extends ConsumerStatefulWidget {
  const _ApiIntegrationsCard({
    required this.solcast,
    required this.pstryk,
    required this.cityName,
    required this.onSolcastChanged,
    required this.onCityNameChanged,
  });

  final bool solcast;
  final bool pstryk;
  final String? cityName;
  final ValueChanged<bool> onSolcastChanged;
  final ValueChanged<String?> onCityNameChanged;

  @override
  ConsumerState<_ApiIntegrationsCard> createState() =>
      _ApiIntegrationsCardState();
}

class _ApiIntegrationsCardState extends ConsumerState<_ApiIntegrationsCard> {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final addonAsync = ref.watch(addonStatusProvider);
    final addonStatus = addonAsync.valueOrNull;
    final connected = addonStatus?['connected'] == true;
    final lastSeen = addonStatus?['lastSeenAt'] != null
        ? fmtDateTime(addonStatus!['lastSeenAt'])
        : null;
    final addonDetail = connected
        ? 'Add-on connected'
        : (lastSeen != null ? 'Add-on offline' : 'Not configured');
    final addonColor = connected
        ? AppColors.secondary
        : (lastSeen != null ? AppColors.tertiary : AppColors.onSurfaceVariant);

    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(title: 'API Integrations'),
        const SizedBox(height: 16),
        _AddonStatusRow(
          detail: addonDetail,
          dotColor: addonColor,
          lastSeen: lastSeen,
        ),
        const SizedBox(height: 12),
        _IntegrationRow(
          icon: Icons.wb_sunny_rounded,
          label: 'Solcast Forecasting',
          detail: widget.solcast ? 'PV forecast active' : 'Not configured',
          enabled: widget.solcast,
          onChanged: widget.onSolcastChanged,
          color: AppColors.tertiary,
        ),
        const SizedBox(height: 12),
        _IntegrationRow(
          icon: Icons.price_change_rounded,
          label: 'Pstryk Pricing Hub',
          detail: widget.pstryk ? 'Prices loading hourly' : 'Managed by admin',
          enabled: widget.pstryk,
          onChanged: null,
          color: AppColors.primary,
        ),
        const SizedBox(height: 16),
        const Divider(height: 1),
        const SizedBox(height: 16),
        // City for PV fallback
        Row(children: [
          const Icon(Icons.location_on_outlined,
              size: 14, color: AppColors.outline),
          const SizedBox(width: 6),
          Text('Fallback PV Location',
              style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 4),
        Text(
          'Used to estimate solar production when Solcast is not configured.',
          style: tt.bodySmall?.copyWith(color: AppColors.outline),
        ),
        const SizedBox(height: 8),
        _CityAutocomplete(
          initialValue: widget.cityName,
          onChanged: widget.onCityNameChanged,
        ),
      ]),
    );
  }
}

class _AddonStatusRow extends StatelessWidget {
  const _AddonStatusRow({
    required this.detail,
    required this.dotColor,
    required this.lastSeen,
  });

  final String detail;
  final Color dotColor;
  final String? lastSeen;

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
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: dotColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.developer_board_rounded,
              size: 18, color: dotColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Local Inverter (SolarmanV5)',
                style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
            Text(detail, style: tt.bodySmall),
            if (lastSeen != null)
              Text('Last seen: $lastSeen',
                  style: tt.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant, fontSize: 11)),
          ]),
        ),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
          ),
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
  final ValueChanged<bool>? onChanged;
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
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: enabled
                ? color.withValues(alpha: 0.12)
                : AppColors.surfaceContainerHigh,
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
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ]),
    );
  }
}

// ── Danger Zone ───────────────────────────────────────────────────────────────

// ── Baseline Info ─────────────────────────────────────────────────────────────

class _BaselineInfoCard extends StatelessWidget {
  const _BaselineInfoCard({required this.settings});
  final SettingsState settings;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final chargingLabel =
        (settings.baselineChargingEnabled ?? false) ? 'On' : 'Off';
    final sellingLabel =
        (settings.baselineSellingEnabled ?? false) ? 'On' : 'Off';
    final priceLabel = settings.baselineMaxBuyPrice != null
        ? '${settings.baselineMaxBuyPrice!.toStringAsFixed(4)} PLN/kWh'
        : '—';
    final sourceLabel = settings.baselinePriceSource ?? 'pstryk';

    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.safety_check_rounded,
              size: 16, color: AppColors.secondary),
          const SizedBox(width: 8),
          Text('Offline Fallback',
              style: tt.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 6),
        Text(
          'If the add-on loses server connection for >15 min it reverts to '
          'these baseline settings to prevent runaway charges.',
          style: tt.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        _BaselineRow(label: 'Charge from grid', value: chargingLabel),
        _BaselineRow(label: 'Sell to grid', value: sellingLabel),
        _BaselineRow(label: 'Max buy price', value: priceLabel),
        _BaselineRow(label: 'Price source', value: sourceLabel),
      ]),
    );
  }
}

class _BaselineRow extends StatelessWidget {
  const _BaselineRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: tt.bodySmall
                  ?.copyWith(color: AppColors.onSurfaceVariant)),
          Text(value,
              style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ── Danger Zone ───────────────────────────────────────────────────────────────

class _DangerZoneCard extends StatelessWidget {
  const _DangerZoneCard();

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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: AppRadius.radiusMd,
            border: Border.all(
                color: AppColors.error.withValues(alpha: 0.15), width: 1),
          ),
          child: Row(children: [
            const Icon(Icons.delete_forever_rounded,
                size: 16, color: AppColors.error),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Delete Account',
                        style: tt.bodySmall?.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('Permanently removes all data. Not yet available.',
                        style: tt.bodySmall
                            ?.copyWith(color: AppColors.outline)),
                  ]),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ── City Autocomplete ─────────────────────────────────────────────────────────

class _CityOption {
  const _CityOption({
    required this.name,
    required this.country,
    required this.displayName,
  });
  final String name;
  final String country;
  final String displayName;
}

class _CityAutocomplete extends StatelessWidget {
  const _CityAutocomplete({required this.initialValue, required this.onChanged});

  final String? initialValue;
  final ValueChanged<String?> onChanged;

  static Future<List<_CityOption>> _searchCities(String query) async {
    if (query.length < 3) return const [];
    try {
      final uri = Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search'
        '?name=${Uri.encodeComponent(query)}&count=5&format=json',
      );
      final response = await http.get(uri);
      if (response.statusCode != 200) return const [];
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = (data['results'] as List?) ?? [];
      return results.map((r) {
        final m = r as Map<String, dynamic>;
        final name = m['name'] as String;
        final country = (m['country'] as String?) ?? '';
        return _CityOption(
          name: name,
          country: country,
          displayName: country.isNotEmpty ? '$name, $country' : name,
        );
      }).toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final inputDecoration = InputDecoration(
      hintText: 'e.g. Warsaw',
      hintStyle: tt.bodyMedium?.copyWith(color: AppColors.outline),
      filled: true,
      fillColor: AppColors.surfaceContainerLow,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: AppRadius.radiusMd,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.radiusMd,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.radiusMd,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );

    return Autocomplete<_CityOption>(
      initialValue: TextEditingValue(text: initialValue ?? ''),
      displayStringForOption: (opt) => opt.displayName,
      optionsBuilder: (value) => _searchCities(value.text.trim()),
      onSelected: (opt) => onChanged(opt.name),
      fieldViewBuilder: (context, ctrl, focusNode, onSubmitted) => TextField(
        controller: ctrl,
        focusNode: focusNode,
        style: tt.bodyMedium,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) {
          onSubmitted();
          final trimmed = ctrl.text.trim();
          if (trimmed.isEmpty) onChanged(null);
        },
        decoration: inputDecoration,
      ),
      optionsViewBuilder: (context, onSelected, options) => Align(
        alignment: Alignment.topLeft,
        child: Material(
          elevation: 4,
          borderRadius: AppRadius.radiusMd,
          color: AppColors.surfaceContainerLow,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 4),
              shrinkWrap: true,
              itemCount: options.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 12, endIndent: 12),
              itemBuilder: (context, i) {
                final opt = options.elementAt(i);
                return InkWell(
                  onTap: () => onSelected(opt),
                  borderRadius: AppRadius.radiusMd,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(opt.name, style: tt.bodyMedium),
                        if (opt.country.isNotEmpty)
                          Text(opt.country,
                              style: tt.bodySmall
                                  ?.copyWith(color: AppColors.outline)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ── EMS Lock Banner ───────────────────────────────────────────────────────────

class _EmsLockBanner extends StatelessWidget {
  const _EmsLockBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message,
                style: tt.bodyMedium?.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

class _ToggleSetting extends StatelessWidget {
  const _ToggleSetting({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.detail,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String detail;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Icon(icon,
            size: 16, color: value ? iconColor : AppColors.outline),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(detail, style: tt.bodySmall),
        ]),
      ),
      Switch(
        value: value,
        onChanged: onChanged,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ]);
  }
}

class _PriceField extends StatelessWidget {
  const _PriceField({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.suffix,
    this.hint,
    this.detail,
    this.optional = false,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<double?> onChanged;
  final String? suffix;
  final String? hint;
  final String? detail;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(label,
            style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        if (optional) ...[
          const SizedBox(width: 6),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('optional',
                style: tt.labelSmall
                    ?.copyWith(color: AppColors.outline)),
          ),
        ],
      ]),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
        style: tt.bodyMedium,
        onChanged: (text) =>
            onChanged(text.isEmpty ? null : double.tryParse(text)),
        decoration: InputDecoration(
          hintText: hint,
          suffixText: suffix,
          filled: true,
          fillColor: AppColors.surfaceContainerLow,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: AppRadius.radiusMd,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.radiusMd,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.radiusMd,
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
      if (detail != null) ...[
        const SizedBox(height: 4),
        Text(detail!,
            style: tt.bodySmall?.copyWith(color: AppColors.outline)),
      ],
    ]);
  }
}

class _NumericField extends StatelessWidget {
  const _NumericField({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.suffix,
    this.hint,
    this.optional = false,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<double?> onChanged;
  final String? suffix;
  final String? hint;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(label,
            style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        if (optional) ...[
          const SizedBox(width: 6),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('optional',
                style: tt.labelSmall
                    ?.copyWith(color: AppColors.outline)),
          ),
        ],
      ]),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
        style: tt.bodyMedium,
        onChanged: (text) =>
            onChanged(text.isEmpty ? null : double.tryParse(text)),
        decoration: InputDecoration(
          hintText: hint,
          suffixText: suffix,
          filled: true,
          fillColor: AppColors.surfaceContainerLow,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: AppRadius.radiusMd,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.radiusMd,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.radiusMd,
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    ]);
  }
}
