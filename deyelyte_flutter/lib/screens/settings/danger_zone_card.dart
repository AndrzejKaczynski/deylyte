import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';

class DangerZoneCard extends StatelessWidget {
  const DangerZoneCard({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SurfaceCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.tertiary),
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
            border: Border.all(color: AppColors.error.withValues(alpha: 0.15), width: 1),
          ),
          child: Row(children: [
            const Icon(Icons.delete_forever_rounded, size: 16, color: AppColors.error),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Delete Account',
                    style: tt.bodySmall?.copyWith(
                        color: AppColors.error, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('Permanently removes all data. Not yet available.',
                    style: tt.bodySmall?.copyWith(color: AppColors.outline)),
              ]),
            ),
          ]),
        ),
      ]),
    );
  }
}
