import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/section_header.dart';
import '../../components/surface_card.dart';
import '../../providers/admin_provider.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

class AdminLicensesScreen extends ConsumerStatefulWidget {
  const AdminLicensesScreen({super.key});

  @override
  ConsumerState<AdminLicensesScreen> createState() =>
      _AdminLicensesScreenState();
}

class _AdminLicensesScreenState extends ConsumerState<AdminLicensesScreen> {
  bool _creating = false;
  String? _createdKey;

  // Create form state
  final _userIdCtrl = TextEditingController();
  String _tier = 'beta_free';

  @override
  void dispose() {
    _userIdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final keys = ref.watch(adminLicenseKeysProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sp6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(title: 'License Keys'),
        const SizedBox(height: AppSpacing.sp4),

        // ── Create form ──────────────────────────────────────────────────
        SurfaceCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Create new key', style: tt.titleSmall),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _userIdCtrl,
                  decoration: const InputDecoration(
                    labelText: 'User ID',
                    hintText: 'numeric user ID from users list',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              DropdownButton<String>(
                value: _tier,
                items: const [
                  DropdownMenuItem(value: 'beta_free', child: Text('Beta Free')),
                  DropdownMenuItem(value: 'basic', child: Text('Basic')),
                  DropdownMenuItem(value: 'pro', child: Text('Pro')),
                ],
                onChanged: (v) => setState(() => _tier = v!),
              ),
              const SizedBox(width: 16),
              FilledButton.icon(
                icon: _creating
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add_rounded, size: 18),
                label: const Text('Generate'),
                onPressed: _creating ? null : _createKey,
              ),
            ]),
            if (_createdKey != null) ...[
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.3)),
                ),
                child: Row(children: [
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.secondary, size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SelectableText(
                      _createdKey!,
                      style: tt.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    tooltip: 'Copy',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _createdKey!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                  ),
                ]),
              ),
            ],
          ]),
        ),

        const SizedBox(height: AppSpacing.sp4),

        // ── Keys table ───────────────────────────────────────────────────
        Expanded(
          child: SurfaceCard(
            child: keys.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (list) => list.isEmpty
                  ? const Center(child: Text('No license keys yet.'))
                  : _KeysTable(
                      keys: list,
                      onToggle: (id, active) => _toggleKey(id, active),
                    ),
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> _createKey() async {
    final userId = int.tryParse(_userIdCtrl.text.trim());
    if (userId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter a valid User ID')));
      return;
    }
    setState(() {
      _creating = true;
      _createdKey = null;
    });
    try {
      final key = await ref
          .read(clientProvider)
          .admin
          .createLicenseKey(userId: userId, tier: _tier);
      setState(() => _createdKey = key);
      ref.invalidate(adminLicenseKeysProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  Future<void> _toggleKey(int id, bool active) async {
    try {
      await ref
          .read(clientProvider)
          .admin
          .setLicenseKeyActive(id: id, active: active);
      ref.invalidate(adminLicenseKeysProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

class _KeysTable extends StatelessWidget {
  const _KeysTable({required this.keys, required this.onToggle});
  final List<Map<String, dynamic>> keys;
  final void Function(int id, bool active) onToggle;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2.5), // key
          1: FlexColumnWidth(1.5), // user
          2: FlexColumnWidth(1),   // tier
          3: FlexColumnWidth(1.5), // created
          4: FlexColumnWidth(1.5), // last seen
          5: FlexColumnWidth(0.8), // status
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: AppColors.outline.withValues(alpha: 0.3))),
            ),
            children: [
              _header('Key', tt),
              _header('User', tt),
              _header('Tier', tt),
              _header('Created', tt),
              _header('Last seen', tt),
              _header('Active', tt),
            ],
          ),
          for (final k in keys)
            TableRow(children: [
              _cell(
                SelectableText(
                  k['licenseKey'] as String,
                  style: tt.bodySmall?.copyWith(fontFamily: 'monospace'),
                ),
              ),
              _cell(Text(
                '${k['userEmail'] ?? '—'}\n#${k['userId']}',
                style: tt.bodySmall,
              )),
              _cell(Text(k['tier'] as String, style: tt.bodySmall)),
              _cell(Text(_fmt(k['createdAt']), style: tt.bodySmall)),
              _cell(Text(_fmt(k['lastSeenAt']), style: tt.bodySmall)),
              _cell(Switch(
                value: k['isActive'] as bool,
                onChanged: (v) => onToggle(k['id'] as int, v),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )),
            ]),
        ],
      ),
    );
  }

  Widget _header(String label, TextTheme tt) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Text(label,
            style: tt.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w600)),
      );

  Widget _cell(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: child,
      );

  String _fmt(dynamic iso) {
    if (iso == null) return '—';
    final dt = DateTime.tryParse(iso as String);
    if (dt == null) return '—';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')}';
  }
}
