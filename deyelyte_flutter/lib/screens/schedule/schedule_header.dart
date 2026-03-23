import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class ScheduleHeader extends StatelessWidget {
  const ScheduleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Energy Schedule', style: tt.headlineMedium),
              const SizedBox(height: 4),
              Builder(builder: (context) {
                final now = DateTime.now();
                final months = [
                  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
                ];
                return Text(
                  'Real-time optimization for Today, '
                  '${months[now.month - 1]} ${now.day}',
                  style: tt.bodySmall,
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class PlanningModeBanner extends StatelessWidget {
  const PlanningModeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.radiusMd,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(children: [
        const Icon(Icons.visibility_outlined, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Planning Mode — schedule is calculated but no commands are sent to the inverter.',
            style: tt.bodySmall?.copyWith(color: AppColors.primary),
          ),
        ),
      ]),
    );
  }
}
