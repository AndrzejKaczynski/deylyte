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
                    fixedSellRate: settings.fixedSellRatePln,
                    priceTimeRanges: settings.priceTimeRanges,
                    onSourceChanged: notifier.setPriceSource,
                    onFixedBuyChanged: notifier.setFixedBuyRatePln,
                    onFixedSellChanged: notifier.setFixedSellRatePln,
                    onRangesChanged: notifier.setPriceTimeRanges,
                  ),
                  const SizedBox(height: AppSpacing.sp4),
                  ApiIntegrationsCard(
                    solcast: settings.solcast,
                    pstryk: settings.pstryk,
                    cityName: settings.cityName,
                    onSolcastChanged: notifier.setSolcast,
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
