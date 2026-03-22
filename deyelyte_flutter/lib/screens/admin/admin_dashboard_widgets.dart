import 'package:flutter/material.dart';

import '../../components/pulse_indicator.dart';
import '../../components/surface_card.dart';
import '../../theme/app_colors.dart';

class AdminKpiCard extends StatelessWidget {
  const AdminKpiCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final String sub;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SurfaceCard(
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: tt.labelSmall
                        ?.copyWith(color: AppColors.onSurfaceVariant)),
                Text(value,
                    style: tt.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
                if (sub.isNotEmpty)
                  Text(sub,
                      style: tt.labelSmall
                          ?.copyWith(color: AppColors.secondary)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              size: 18, color: AppColors.onSurfaceVariant),
        ]),
      ),
    );
  }
}

class AdminCardTitle extends StatelessWidget {
  const AdminCardTitle({
    super.key,
    required this.icon,
    required this.label,
    required this.onMore,
  });

  final IconData icon;
  final String label;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(children: [
      Icon(icon, size: 16, color: AppColors.primary),
      const SizedBox(width: 8),
      Text(label,
          style:
              tt.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
      const Spacer(),
      TextButton(
        onPressed: onMore,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: tt.labelSmall,
          minimumSize: Size.zero,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        child: const Text('View all →'),
      ),
    ]);
  }
}

class AdminDeviceRow extends StatelessWidget {
  const AdminDeviceRow({super.key, required this.device});
  final Map<String, dynamic> device;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final inverterOk = device['inverterReachable'] as bool? ?? false;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        const PulseIndicator(color: AppColors.secondary, size: 8),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(device['userEmail'] ?? '—', style: tt.bodySmall),
            Text(
              inverterOk ? 'Inverter reachable' : 'Inverter unreachable',
              style: tt.labelSmall?.copyWith(
                color: inverterOk
                    ? AppColors.secondary
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class AdminKeyRow extends StatelessWidget {
  const AdminKeyRow({super.key, required this.key0});
  final Map<String, dynamic> key0;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final isActive = key0['isActive'] as bool? ?? false;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              key0['licenseKey'] as String,
              style: tt.bodySmall?.copyWith(fontFamily: 'monospace'),
            ),
            Text(
              '${key0['userEmail'] ?? 'unassigned'} · ${key0['tier']}',
              style: tt.labelSmall
                  ?.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: (isActive ? AppColors.secondary : AppColors.onSurfaceVariant)
                .withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            isActive ? 'Active' : 'Inactive',
            style: tt.labelSmall?.copyWith(
              color: isActive
                  ? AppColors.secondary
                  : AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ]),
    );
  }
}
