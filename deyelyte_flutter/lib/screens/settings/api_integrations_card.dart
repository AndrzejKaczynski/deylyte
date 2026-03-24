import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../components/solcast_credentials_dialog.dart';
import '../../components/pstryk_credentials_dialog.dart';
import '../../providers/app_providers.dart';
import '../../utils/date_format.dart';

class ApiIntegrationsCard extends ConsumerStatefulWidget {
  const ApiIntegrationsCard({
    super.key,
    required this.solcast,
    required this.pstryk,
    required this.cityName,
    required this.onSolcastChanged,
    required this.onPstrykChanged,
    required this.onCityNameChanged,
  });

  final bool solcast;
  final bool pstryk;
  final String? cityName;
  final ValueChanged<bool> onSolcastChanged;
  final ValueChanged<bool> onPstrykChanged;
  final ValueChanged<String?> onCityNameChanged;

  @override
  ConsumerState<ApiIntegrationsCard> createState() =>
      _ApiIntegrationsCardState();
}

class _ApiIntegrationsCardState extends ConsumerState<ApiIntegrationsCard> {
  bool _solcastBusy = false;
  bool _pstrykBusy = false;

  /// Shows a confirmation dialog before disabling an integration.
  /// Returns true if the user confirmed, false if they cancelled.
  static Future<bool> _confirmDisable(
      BuildContext context, String integrationName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusXl),
        title: Text('Disable $integrationName?',
            style: const TextStyle(
                color: AppColors.onSurface, fontWeight: FontWeight.w600)),
        content: Text(
          'This will remove your $integrationName credentials. '
          'You can reconnect at any time.',
          style: const TextStyle(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.radiusMd),
            ),
            child: const Text('Disable'),
          ),
        ],
      ),
    );
    return confirmed == true;
  }

  Future<void> _onPstrykToggle(bool enable) async {
    if (_pstrykBusy) return;
    if (enable) {
      bool saved = false;
      await PstrykCredentialsDialog.show(
        context,
        onSave: (apiKey) async {
          await ref.read(clientProvider).credentials.savePstryk(apiKey);
          try {
            await ref.read(clientProvider).price.triggerFetch();
          } catch (e) {
            await ref.read(clientProvider).credentials.removePstryk();
            throw Exception('Could not connect to Pstryk: $e');
          }
          saved = true;
        },
      );
      if (!saved || !mounted) return;
      widget.onPstrykChanged(true);
      ref.invalidate(integrationStatusProvider);
      ref.invalidate(todayPricesProvider);
    } else {
      if (!mounted) return;
      final confirmed = await _confirmDisable(context, 'Pstryk');
      if (!confirmed || !mounted) return;
      setState(() => _pstrykBusy = true);
      try {
        await ref.read(clientProvider).credentials.removePstryk();
        if (mounted) {
          widget.onPstrykChanged(false);
          ref.invalidate(integrationStatusProvider);
          ref.invalidate(todayPricesProvider);
        }
      } finally {
        if (mounted) setState(() => _pstrykBusy = false);
      }
    }
  }

  Future<void> _onSolcastToggle(bool enable) async {
    if (_solcastBusy) return;
    if (enable) {
      bool saved = false;
      await SolcastCredentialsDialog.show(
        context,
        onSave: (apiKey, siteId) async {
          await ref.read(clientProvider).credentials.saveSolcast(apiKey, siteId);
          try {
            // Live verification: fetch a real forecast with the new credentials.
            await ref.read(clientProvider).forecast.updateForecast();
          } catch (e) {
            // Credentials stored but invalid — roll back so the user can retry.
            await ref.read(clientProvider).credentials.removeSolcast();
            throw Exception('Could not connect to Solcast: $e');
          }
          saved = true;
        },
      );
      if (!saved || !mounted) return;
      widget.onSolcastChanged(true);
      ref.invalidate(integrationStatusProvider);
    } else {
      if (!mounted) return;
      final confirmed = await _confirmDisable(context, 'Solcast');
      if (!confirmed || !mounted) return;
      setState(() => _solcastBusy = true);
      try {
        await ref.read(clientProvider).credentials.removeSolcast();
        if (mounted) {
          widget.onSolcastChanged(false);
          ref.invalidate(integrationStatusProvider);
        }
      } finally {
        if (mounted) setState(() => _solcastBusy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(title: 'API Integrations'),
        const SizedBox(height: 16),
        const _AddonStatusRow(),
        const SizedBox(height: 12),
        _IntegrationRow(
          icon: Icons.wb_sunny_rounded,
          label: 'Solcast Forecasting',
          detail: widget.solcast ? 'PV forecast active' : 'Not configured',
          enabled: widget.solcast,
          onChanged: _solcastBusy ? null : _onSolcastToggle,
          color: AppColors.tertiary,
        ),
        const SizedBox(height: 12),
        _IntegrationRow(
          icon: Icons.price_change_rounded,
          label: 'Pstryk Pricing Hub',
          detail: widget.pstryk ? 'Prices loading hourly' : 'Not configured',
          enabled: widget.pstryk,
          onChanged: _pstrykBusy ? null : _onPstrykToggle,
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

class _AddonStatusRow extends ConsumerStatefulWidget {
  const _AddonStatusRow();

  @override
  ConsumerState<_AddonStatusRow> createState() => _AddonStatusRowState();
}

class _AddonStatusRowState extends ConsumerState<_AddonStatusRow> {
  bool _settingModel = false;

  Future<void> _pickModel(
    BuildContext context,
    List<Map<String, dynamic>> models,
    String? currentModelId,
  ) async {
    final picked = await showDialog<String>(
      context: context,
      builder: (_) => _InverterModelDialog(
        models: models,
        currentModelId: currentModelId,
      ),
    );
    if (picked == null || !mounted) return;
    setState(() => _settingModel = true);
    try {
      await ref.read(deviceRepositoryProvider).setModel(picked);
      ref.invalidate(addonStatusProvider);
    } finally {
      if (mounted) setState(() => _settingModel = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    final addonStatus = ref.watch(addonStatusProvider).valueOrNull;
    final connected = addonStatus?['connected'] == true;
    final lastSeen = addonStatus?['lastSeenAt'] != null
        ? fmtDateTime(addonStatus!['lastSeenAt'] as String)
        : null;
    final dotColor = connected
        ? AppColors.secondary
        : (lastSeen != null ? AppColors.tertiary : AppColors.onSurfaceVariant);
    final connectionDetail = connected
        ? 'Add-on connected'
        : (lastSeen != null ? 'Add-on offline' : 'Not configured');

    final modelId = addonStatus?['inverterModelId'] as String?;
    final modelName = addonStatus?['inverterModelName'] as String?;
    final validationStatus = addonStatus?['modelValidationStatus'] as String?;

    final models = ref.watch(inverterModelsProvider).valueOrNull ?? [];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadius.radiusMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Connection status row ────────────────────────────────────────
          Row(children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: dotColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.developer_board_rounded, size: 18, color: dotColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Local Inverter (SolarmanV5)',
                    style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                Text(connectionDetail, style: tt.bodySmall),
                if (lastSeen != null)
                  Text('Last seen: $lastSeen',
                      style: tt.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant, fontSize: 11)),
              ]),
            ),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
            ),
          ]),

          // ── Model selection + validation ─────────────────────────────────
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.outlineVariant),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Inverter Model',
                    style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                Text(
                  modelName ?? 'No model selected — tap to configure',
                  style: tt.bodySmall?.copyWith(
                    color: modelName != null
                        ? AppColors.onSurface
                        : AppColors.onSurfaceVariant,
                  ),
                ),
                if (validationStatus != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: _ValidationBadge(status: validationStatus),
                  ),
              ]),
            ),
            const SizedBox(width: 8),
            _settingModel
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: AppColors.primary,
                    ),
                    onPressed: models.isEmpty
                        ? null
                        : () => _pickModel(context, models, modelId),
                    child: Text(modelId == null ? 'Select' : 'Change',
                        style: tt.bodySmall?.copyWith(color: AppColors.primary)),
                  ),
          ]),
        ],
      ),
    );
  }
}

class _ValidationBadge extends StatelessWidget {
  const _ValidationBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return switch (status) {
      'ok' => Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.check_circle_outline_rounded,
              size: 12, color: AppColors.secondary),
          const SizedBox(width: 4),
          Text('Model verified', style: tt.bodySmall?.copyWith(
              color: AppColors.secondary, fontSize: 11)),
        ]),
      'pending' => Row(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(
              width: 10, height: 10,
              child: CircularProgressIndicator(strokeWidth: 1.5)),
          const SizedBox(width: 4),
          Text('Verifying…', style: tt.bodySmall?.copyWith(
              color: AppColors.onSurfaceVariant, fontSize: 11)),
        ]),
      'failed' => Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.warning_amber_rounded,
              size: 12, color: AppColors.tertiary),
          const SizedBox(width: 4),
          Text('Model mismatch — check your selection',
              style: tt.bodySmall?.copyWith(
                  color: AppColors.tertiary, fontSize: 11)),
        ]),
      _ => const SizedBox.shrink(),
    };
  }
}

class _InverterModelDialog extends StatefulWidget {
  const _InverterModelDialog({
    required this.models,
    required this.currentModelId,
  });

  final List<Map<String, dynamic>> models;
  final String? currentModelId;

  @override
  State<_InverterModelDialog> createState() => _InverterModelDialogState();
}

class _InverterModelDialogState extends State<_InverterModelDialog> {
  late String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentModelId;
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return AlertDialog(
      backgroundColor: AppColors.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusXl),
      title: const Text('Select Inverter Model',
          style: TextStyle(
              color: AppColors.onSurface, fontWeight: FontWeight.w600)),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose the model that matches your inverter. '
              'The app will verify the connection automatically after you save.',
              style: tt.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            RadioGroup<String>(
              groupValue: _selected,
              onChanged: (v) => setState(() => _selected = v),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.models.map((m) {
                  final id = m['modelId'] as String;
                  final name = m['displayName'] as String;
                  return RadioListTile<String>(
                    value: id,
                    title: Text(name, style: tt.bodySmall),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel',
              style: TextStyle(color: AppColors.onSurfaceVariant)),
        ),
        FilledButton(
          onPressed: _selected == null
              ? null
              : () => Navigator.of(context).pop(_selected),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
            foregroundColor: AppColors.onPrimary,
            disabledBackgroundColor: AppColors.surfaceContainerHigh,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMd),
          ),
          child: const Text('Save'),
        ),
      ],
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
