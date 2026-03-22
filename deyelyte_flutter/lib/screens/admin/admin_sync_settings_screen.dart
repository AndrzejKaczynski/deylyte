import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/section_header.dart';
import '../../components/surface_card.dart';
import '../../providers/admin_provider.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class AdminSyncSettingsScreen extends ConsumerWidget {
  const AdminSyncSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configs = ref.watch(adminSyncSettingsProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sp6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(child: SectionHeader(title: 'Tier Permissions')),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(adminSyncSettingsProvider),
          ),
        ]),
        const SizedBox(height: 8),
        Text(
          'Controls per-tier feature limits. Changes take effect on the next telemetry cycle.',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.sp4),
        Expanded(
          child: configs.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (list) {
              const tiers = ['beta_free', 'basic', 'pro'];
              final rows = tiers.map((t) {
                return list.firstWhere(
                  (c) => c['tier'] == t,
                  orElse: () => {
                    'tier': t,
                    'syncIntervalSeconds': 300,
                    'historyDurationDays': 7,
                  },
                );
              }).toList();

              return ListView.separated(
                itemCount: rows.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.sp4),
                itemBuilder: (_, i) => _TierCard(
                  config: rows[i],
                  onSave: (tier, seconds, days) async {
                    await ref
                        .read(clientProvider)
                        .admin
                        .updateTierSyncConfig(
                          tier: tier,
                          syncIntervalSeconds: seconds,
                          historyDurationDays: days,
                        );
                    ref.invalidate(adminSyncSettingsProvider);
                  },
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}

// ── Tier card ──────────────────────────────────────────────────────────────────

class _TierCard extends StatefulWidget {
  const _TierCard({required this.config, required this.onSave});

  final Map<String, dynamic> config;
  final Future<void> Function(String tier, int seconds, int days) onSave;

  @override
  State<_TierCard> createState() => _TierCardState();
}

class _TierCardState extends State<_TierCard> {
  late final TextEditingController _syncCtrl;
  late final TextEditingController _historyCtrl;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _syncCtrl = TextEditingController(
      text: '${widget.config['syncIntervalSeconds'] ?? 300}',
    );
    _historyCtrl = TextEditingController(
      text: '${widget.config['historyDurationDays'] ?? 7}',
    );
  }

  @override
  void dispose() {
    _syncCtrl.dispose();
    _historyCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final seconds = int.tryParse(_syncCtrl.text.trim());
    final days = int.tryParse(_historyCtrl.text.trim());
    if (seconds == null || seconds < 300) {
      setState(() => _error = 'Sync interval minimum is 300 s');
      return;
    }
    if (days == null || days < 1) {
      setState(() => _error = 'History duration minimum is 1 day');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.onSave(widget.config['tier'] as String, seconds, days);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final tier = widget.config['tier'] as String;
    final label = switch (tier) {
      'beta_free' => 'Beta Free',
      'basic' => 'Basic',
      'pro' => 'Pro',
      _ => tier,
    };

    return SurfaceCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sp5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Header ──────────────────────────────────────────────────────
          Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label,
                  style:
                      tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              Text(tier,
                  style: tt.labelSmall
                      ?.copyWith(color: AppColors.onSurfaceVariant)),
            ]),
            const Spacer(),
            if (_error != null)
              Text(
                _error!,
                style: tt.labelSmall
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            const SizedBox(width: 12),
            _saving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : FilledButton(
                    onPressed: _submit,
                    child: const Text('Save'),
                  ),
          ]),
          const SizedBox(height: AppSpacing.sp4),
          Divider(height: 1, color: AppColors.outline.withValues(alpha: 0.15)),
          const SizedBox(height: AppSpacing.sp4),
          // ── Permission rows ──────────────────────────────────────────────
          _PermissionRow(
            icon: Icons.sync_rounded,
            label: 'Sync interval',
            hint: 'Minimum 300 s (hardware logger limit)',
            controller: _syncCtrl,
            suffix: 'seconds',
            readable: _readableSeconds(
                int.tryParse(_syncCtrl.text.trim()) ?? 300),
          ),
          const SizedBox(height: AppSpacing.sp3),
          _PermissionRow(
            icon: Icons.history_rounded,
            label: 'History duration',
            hint: 'How many days of telemetry the user can access',
            controller: _historyCtrl,
            suffix: 'days',
            readable: _readableDays(
                int.tryParse(_historyCtrl.text.trim()) ?? 7),
          ),
        ]),
      ),
    );
  }

  String _readableSeconds(int seconds) {
    if (seconds < 60) return '$seconds s';
    final m = seconds ~/ 60;
    final s = seconds % 60;
    if (s == 0) return '$m min';
    return '$m min $s s';
  }

  String _readableDays(int days) {
    if (days == 1) return '1 day';
    if (days < 7) return '$days days';
    final w = days ~/ 7;
    final d = days % 7;
    if (d == 0) return w == 1 ? '1 week' : '$w weeks';
    return '$w w $d d';
  }
}

// ── Single permission row ──────────────────────────────────────────────────────

class _PermissionRow extends StatefulWidget {
  const _PermissionRow({
    required this.icon,
    required this.label,
    required this.hint,
    required this.controller,
    required this.suffix,
    required this.readable,
  });

  final IconData icon;
  final String label;
  final String hint;
  final TextEditingController controller;
  final String suffix;
  final String readable;

  @override
  State<_PermissionRow> createState() => _PermissionRowState();
}

class _PermissionRowState extends State<_PermissionRow> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(children: [
      Icon(widget.icon, size: 16, color: AppColors.onSurfaceVariant),
      const SizedBox(width: 8),
      Expanded(
        flex: 3,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.label,
              style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
          Text(widget.hint,
              style:
                  tt.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
        ]),
      ),
      const SizedBox(width: 16),
      SizedBox(
        width: 200,
        child: TextField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            suffixText: widget.suffix,
            border: const OutlineInputBorder(),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
      const SizedBox(width: 16),
      SizedBox(
        width: 90,
        child: Text(
          widget.readable,
          style: tt.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ),
    ]);
  }
}
