import 'package:deyelyte_client/deyelyte_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../providers/app_providers.dart';
import '../../providers/settings_provider.dart';
import 'ems_control_card.dart';
import 'thresholds_card.dart';
import 'hardware_card.dart';
import 'ems_status_card.dart';
import 'pricing_source_card.dart';
import 'api_integrations_card.dart';
import 'baseline_info_card.dart';
import 'danger_zone_card.dart';

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
  bool _populatingControllers = false;

  // Hardware spec controllers — owned here and read at save time.
  final _capacityCtrl = TextEditingController();
  final _gridConnectionCtrl = TextEditingController();
  final _chargeRateCtrl = TextEditingController();
  final _dischargeRateCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  final _lifecyclesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (final ctrl in [
      _capacityCtrl,
      _gridConnectionCtrl,
      _chargeRateCtrl,
      _dischargeRateCtrl,
      _costCtrl,
      _lifecyclesCtrl,
    ]) {
      ctrl.addListener(_onHardwareChanged);
    }
  }

  void _onHardwareChanged() {
    if (_populatingControllers) return;
    ref.read(settingsProvider.notifier).markDirty();
  }

  void _populateHardwareControllers(AppConfig c) {
    _populatingControllers = true;
    _capacityCtrl.text = c.batteryCapacityKwh?.toStringAsFixed(1) ?? '';
    _gridConnectionCtrl.text = c.gridConnectionKw?.toStringAsFixed(1) ?? '';
    _chargeRateCtrl.text = c.maxChargeRateKw?.toStringAsFixed(1) ?? '';
    _dischargeRateCtrl.text = c.maxDischargeRateKw?.toStringAsFixed(1) ?? '';
    _costCtrl.text = c.batteryCost?.toStringAsFixed(0) ?? '';
    _lifecyclesCtrl.text = c.batteryLifecycles?.toString() ?? '';
    _populatingControllers = false;
  }

  @override
  void dispose() {
    _capacityCtrl.dispose();
    _gridConnectionCtrl.dispose();
    _chargeRateCtrl.dispose();
    _dischargeRateCtrl.dispose();
    _costCtrl.dispose();
    _lifecyclesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Populate local settings from server config once on first load.
    ref.listen<AsyncValue<AppConfig?>>(appConfigProvider, (_, next) {
      if (_configLoaded) return;
      final config = next.valueOrNull;
      if (config != null) {
        _configLoaded = true;
        ref.read(settingsProvider.notifier).loadFrom(config);
        _populateHardwareControllers(config);
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
        ref.read(settingsProvider.notifier).loadPriceTimeRanges(ranges);
      } else if (next is AsyncData) {
        _rangesLoaded = true;
      }
    });

    final configAsync = ref.watch(appConfigProvider);

    // ref.listen only fires on changes. If the provider was already loaded
    // before this screen built (e.g. navigating back), eagerly initialize.
    if (!_configLoaded && configAsync is AsyncData) {
      _configLoaded = true;
      final config = configAsync.valueOrNull;
      if (config != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ref.read(settingsProvider.notifier).loadFrom(config);
            _populateHardwareControllers(config);
          }
        });
      }
    }

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

    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: AppColors.surface,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedOpacity(
        opacity: settings.isDirty ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: IgnorePointer(
          ignoring: !settings.isDirty,
          child: SizedBox(
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Expanded(child: _UnsavedChangesBanner()),
                  const SizedBox(width: 12),
                  FloatingActionButton.extended(
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
                ],
              ),
            ),
          ),
        ),
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
                      child: EmsControlCard(
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
                  ThresholdsCard(
                    minSoc: settings.minSoc,
                    onMinSocChanged: notifier.setMinSoc,
                  ),
                  const SizedBox(height: AppSpacing.sp4),
                  HardwareCard(
                    capacityCtrl: _capacityCtrl,
                    gridConnectionCtrl: _gridConnectionCtrl,
                    chargeRateCtrl: _chargeRateCtrl,
                    dischargeRateCtrl: _dischargeRateCtrl,
                    costCtrl: _costCtrl,
                    lifecyclesCtrl: _lifecyclesCtrl,
                  ),
                ]),
                sidebar: Column(children: [
                  EmsStatusCard(
                    chargingEnabled: settings.chargingEnabled,
                    sellingEnabled: settings.sellingEnabled,
                    pvOnlySelling: settings.pvOnlySelling,
                    maxBuyPrice: settings.maxBuyPrice,
                    minSoc: settings.minSoc,
                  ),
                  const SizedBox(height: AppSpacing.sp4),
                  PricingSourceCard(
                    priceSource: settings.priceSource,
                    fixedBuyRate: settings.fixedBuyRatePln,
                    priceTimeRanges: settings.priceTimeRanges,
                    onSourceChanged: notifier.setPriceSource,
                    onFixedBuyChanged: notifier.setFixedBuyRatePln,
                    onRangesChanged: notifier.setPriceTimeRanges,
                  ),
                  const SizedBox(height: AppSpacing.sp4),
                  ApiIntegrationsCard(
                    solcast: settings.solcast,
                    pstryk: settings.pstryk,
                    cityName: settings.cityName,
                    onSolcastChanged: notifier.setSolcast,
                    onPstrykChanged: notifier.setPstryk,
                    onCityNameChanged: notifier.setCityName,
                  ),
                  if (settings.hasBaseline) ...[
                    const SizedBox(height: AppSpacing.sp4),
                    BaselineInfoCard(settings: settings),
                  ],
                  const SizedBox(height: AppSpacing.sp4),
                  const DangerZoneCard(),
                ]),
              ),
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

  void _showToast(String message, {required bool success}) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _ToastNotification(
        message: message,
        success: success,
        onDone: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
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
        batteryCapacityKwh: double.tryParse(_capacityCtrl.text),
        batteryCost: double.tryParse(_costCtrl.text),
        batteryLifecycles: int.tryParse(_lifecyclesCtrl.text),
        minSocPercentage: s.minSoc,
        maxDischargeRateKw: double.tryParse(_dischargeRateCtrl.text),
        maxChargeRateKw: double.tryParse(_chargeRateCtrl.text),
        gridConnectionKw: double.tryParse(_gridConnectionCtrl.text),
        cityName: s.cityName,
        latitude: existing?.latitude,
        longitude: existing?.longitude,
        priceSource: s.priceSource,
        fixedBuyRatePln: s.fixedBuyRatePln,
        planningOnly: s.planningOnly,
        pstrykEnabled: existing?.pstrykEnabled ?? false,
      );
      await ref.read(appConfigProvider.notifier).save(config);
      await ref
          .read(clientProvider)
          .priceTimeRanges
          .saveTimeRanges(s.priceTimeRanges);
      ref.read(settingsProvider.notifier).markClean();
      if (mounted) _showToast('Settings saved', success: true);
    } catch (e) {
      if (mounted) _showToast('Failed to save: $e', success: false);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

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

class _ToastNotification extends StatefulWidget {
  const _ToastNotification({
    required this.message,
    required this.success,
    required this.onDone,
  });

  final String message;
  final bool success;
  final VoidCallback onDone;

  @override
  State<_ToastNotification> createState() => _ToastNotificationState();
}

class _ToastNotificationState extends State<_ToastNotification>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 5), _dismiss);
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _ctrl.reverse();
    widget.onDone();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final color = widget.success ? AppColors.secondary : AppColors.error;
    final top = MediaQuery.paddingOf(context).top + 12;
    return Positioned(
      top: top,
      right: 16,
      child: FadeTransition(
        opacity: _opacity,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: AppRadius.radiusMd,
              border: Border.all(color: color.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.success
                      ? Icons.check_circle_outline_rounded
                      : Icons.error_outline_rounded,
                  size: 16,
                  color: color,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.message,
                  style: tt.bodySmall?.copyWith(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UnsavedChangesBanner extends StatelessWidget {
  const _UnsavedChangesBanner();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.errorContainer.withValues(alpha: 0.35),
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              size: 20, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'You have unsaved changes.',
              style: tt.bodyMedium?.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

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
