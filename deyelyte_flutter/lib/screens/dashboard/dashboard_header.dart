import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';
import '../../providers/app_providers.dart';

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final telemetry = ref.watch(latestTelemetryProvider).valueOrNull;
    final lastSync = telemetry?.timestamp;
    final syncLabel = lastSync == null
        ? 'Waiting for data...'
        : 'Last sync: ${_formatSync(lastSync)}';
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Energy Overview', style: tt.headlineMedium),
              const SizedBox(height: 4),
              Row(
                children: [
                  const PulseIndicator(color: AppColors.secondary, size: 6),
                  const SizedBox(width: 8),
                  Text(syncLabel, style: tt.bodySmall),
                ],
              ),
            ],
          ),
        ),
        SurfaceCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.electric_bolt_rounded,
                  size: 14, color: AppColors.secondary),
              const SizedBox(width: 6),
              Text('50.02 Hz',
                  style: tt.labelMedium?.copyWith(color: AppColors.secondary)),
            ],
          ),
        ),
      ],
    );
  }
}

String _formatSync(DateTime ts) {
  final local = ts.toLocal();
  final now = DateTime.now();
  final diff = now.difference(local);
  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
}

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withValues(alpha: 0.10),
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.25)),
      ),
      child: Row(children: [
        const Icon(Icons.wifi_off_rounded, size: 16, color: AppColors.tertiary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Add-on offline — inverter data may be stale',
            style: tt.bodySmall?.copyWith(color: AppColors.tertiary),
          ),
        ),
        GestureDetector(
          onTap: () => context.go('/settings'),
          child: Text(
            'Troubleshoot →',
            style: tt.bodySmall?.copyWith(
              color: AppColors.tertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ]),
    );
  }
}
