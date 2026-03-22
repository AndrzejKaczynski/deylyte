import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/admin_provider.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_colors.dart';
import '../../utils/date_format.dart';

// ── Create key dialog ─────────────────────────────────────────────────────────

class AdminCreateKeyDialog extends ConsumerStatefulWidget {
  const AdminCreateKeyDialog({super.key, required this.onCreated});
  final VoidCallback onCreated;

  @override
  ConsumerState<AdminCreateKeyDialog> createState() =>
      _AdminCreateKeyDialogState();
}

class _AdminCreateKeyDialogState
    extends ConsumerState<AdminCreateKeyDialog> {
  Map<String, dynamic>? _selectedUser;
  String _tier = 'beta_free';
  bool _creating = false;
  String? _createdKey;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final users = ref.watch(adminUsersProvider);
    final keys = ref.watch(adminLicenseKeysProvider).valueOrNull ?? [];

    // Users without any active license key
    final usersWithoutKey = users.when(
      data: (list) => list.where((u) {
        final hasActive = keys.any(
          (k) => k['userId'] == u['id'] && (k['isActive'] as bool? ?? false),
        );
        return !hasActive;
      }).toList(),
      loading: () => <Map<String, dynamic>>[],
      error: (_, __) => <Map<String, dynamic>>[],
    );

    return AlertDialog(
      title: const Text('Create License Key'),
      content: SizedBox(
        width: 520,
        child: _createdKey != null
            ? AdminSuccessView(licenseKey: _createdKey!, tt: tt)
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── User dropdown with search ───────────────────────────
                  Text('Select user (without active key)',
                      style: tt.labelMedium),
                  const SizedBox(height: 8),
                  users.when(
                    loading: () => const SizedBox(
                      height: 56,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Text('Error: $e',
                        style: tt.bodySmall
                            ?.copyWith(color: AppColors.onSurfaceVariant)),
                    data: (_) => DropdownMenu<Map<String, dynamic>>(
                      width: 488,
                      enableFilter: true,
                      enableSearch: true,
                      hintText: usersWithoutKey.isEmpty
                          ? 'All users already have an active key'
                          : 'Search by email…',
                      leadingIcon:
                          const Icon(Icons.search_rounded, size: 18),
                      enabled: usersWithoutKey.isNotEmpty,
                      initialSelection: _selectedUser,
                      onSelected: (u) => setState(() => _selectedUser = u),
                      filterCallback: (entries, filter) => entries
                          .where((e) => (e.label)
                              .toLowerCase()
                              .contains(filter.toLowerCase()))
                          .toList(),
                      dropdownMenuEntries: usersWithoutKey
                          .map((u) => DropdownMenuEntry(
                                value: u,
                                label: u['email'] as String? ?? '—',
                                labelWidget: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(u['email'] ?? '—',
                                        style: tt.bodySmall),
                                    Text('#${u['id']}',
                                        style: tt.labelSmall?.copyWith(
                                            color:
                                                AppColors.onSurfaceVariant)),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Tier picker ────────────────────────────────────────
                  Text('Tier', style: tt.labelMedium),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'beta_free', label: Text('Beta Free')),
                      ButtonSegment(value: 'basic', label: Text('Basic')),
                      ButtonSegment(value: 'pro', label: Text('Pro')),
                    ],
                    selected: {_tier},
                    onSelectionChanged: (s) =>
                        setState(() => _tier = s.first),
                  ),

                  if (_selectedUser != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        'Will create a $_tier key for '
                        '${_selectedUser!['email']}',
                        style: tt.bodySmall
                            ?.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ],
              ),
      ),
      actions: _createdKey != null
          ? [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onCreated();
                },
                child: const Text('Done'),
              ),
            ]
          : [
              TextButton(
                onPressed: _creating ? null : () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed:
                    (_selectedUser == null || _creating) ? null : _submit,
                child: _creating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Generate'),
              ),
            ],
    );
  }

  Future<void> _submit() async {
    if (_selectedUser == null) return;
    setState(() => _creating = true);
    try {
      final key = await ref.read(clientProvider).admin.createLicenseKey(
            userId: _selectedUser!['id'] as int,
            tier: _tier,
          );
      setState(() => _createdKey = key);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }
}

// ── Success view ──────────────────────────────────────────────────────────────

class AdminSuccessView extends StatelessWidget {
  const AdminSuccessView({super.key, required this.licenseKey, required this.tt});
  final String licenseKey;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle_rounded,
            color: AppColors.secondary, size: 48),
        const SizedBox(height: 16),
        Text('License key created!', style: tt.titleMedium),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
          ),
          child: Row(children: [
            Expanded(
              child: SelectableText(
                licenseKey,
                style: tt.titleMedium?.copyWith(
                  fontFamily: 'monospace',
                  color: AppColors.secondary,
                  letterSpacing: 2,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy_rounded, size: 18),
              tooltip: 'Copy',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: licenseKey));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied to clipboard')),
                );
              },
            ),
          ]),
        ),
        const SizedBox(height: 8),
        Text(
          'Share this key with the user. It will be shown only once.',
          style:
              tt.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ── Keys table ────────────────────────────────────────────────────────────────

class AdminKeysTable extends StatelessWidget {
  const AdminKeysTable({super.key, required this.keys, required this.onToggle});
  final List<Map<String, dynamic>> keys;
  final void Function(int id, bool active) onToggle;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(children: [
            _hdr('Key', tt, 2.5),
            _hdr('User', tt, 1.5),
            _hdr('Tier', tt, 1.0),
            _hdr('Created', tt, 1.5),
            _hdr('Last seen', tt, 1.5),
            _hdr('Active', tt, 0.8),
          ]),
        ),
        Divider(height: 1, color: AppColors.outline.withValues(alpha: 0.3)),
        Expanded(
          child: ListView.separated(
            itemCount: keys.length,
            separatorBuilder: (_, __) => Divider(
                height: 1,
                color: AppColors.outline.withValues(alpha: 0.15)),
            itemBuilder: (_, i) {
              final k = keys[i];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(children: [
                  _cell(
                    SelectableText(
                      k['licenseKey'] as String,
                      style:
                          tt.bodySmall?.copyWith(fontFamily: 'monospace'),
                    ),
                    2.5,
                  ),
                  _cell(
                    Text('${k['userEmail'] ?? '—'}\n#${k['userId']}',
                        style: tt.bodySmall),
                    1.5,
                  ),
                  _cell(Text(k['tier'] as String, style: tt.bodySmall),
                      1.0),
                  _cell(Text(fmtDateTime(k['createdAt']), style: tt.bodySmall),
                      1.5),
                  _cell(Text(fmtDateTime(k['lastSeenAt']), style: tt.bodySmall),
                      1.5),
                  _cell(
                    Switch(
                      value: k['isActive'] as bool,
                      onChanged: (v) => onToggle(k['id'] as int, v),
                      materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                    ),
                    0.8,
                  ),
                ]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _hdr(String label, TextTheme tt, double flex) => Expanded(
        flex: (flex * 10).round(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(label,
              style: tt.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w600)),
        ),
      );

  Widget _cell(Widget child, double flex) => Expanded(
        flex: (flex * 10).round(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: child,
        ),
      );
}
