import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/section_header.dart';
import '../../components/surface_card.dart';
import '../../providers/admin_provider.dart';
import '../../providers/app_providers.dart';
import '../../theme/app_spacing.dart';
import 'admin_licenses_widgets.dart';

class AdminLicensesScreen extends ConsumerWidget {
  const AdminLicensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keys = ref.watch(adminLicenseKeysProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sp6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(child: SectionHeader(title: 'License Keys')),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: () {
              ref.invalidate(adminLicenseKeysProvider);
              ref.invalidate(adminUsersProvider);
            },
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Create key'),
            onPressed: () => _showCreateModal(context, ref),
          ),
        ]),
        const SizedBox(height: AppSpacing.sp4),
        Expanded(
          child: SurfaceCard(
            child: keys.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (list) => list.isEmpty
                  ? const Center(child: Text('No license keys yet.'))
                  : AdminKeysTable(
                      keys: list,
                      onToggle: (id, active) async {
                        await ref
                            .read(clientProvider)
                            .admin
                            .setLicenseKeyActive(id: id, active: active);
                        ref.invalidate(adminLicenseKeysProvider);
                      },
                    ),
            ),
          ),
        ),
      ]),
    );
  }

  void _showCreateModal(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AdminCreateKeyDialog(
        onCreated: () {
          ref.invalidate(adminLicenseKeysProvider);
          ref.invalidate(adminUsersProvider);
        },
      ),
    );
  }
}
