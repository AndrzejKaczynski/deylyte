import 'package:flutter/material.dart';
import '../../components/components.dart';
import '../../theme/theme.dart';
import 'onboarding_shared.dart';

class SetupHeroPanel extends StatelessWidget {
  const SetupHeroPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF060E20),
            Color(0xFF0B1326),
            Color(0xFF0E1A2E),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -80,
            child: GlowOrb(
              color: AppColors.primary.withValues(alpha: 0.08),
              size: 500,
            ),
          ),
          Positioned(
            bottom: -100,
            left: -60,
            child: GlowOrb(
              color: AppColors.secondary.withValues(alpha: 0.05),
              size: 400,
            ),
          ),
          const Positioned.fill(
            child: CustomPaint(painter: EnergyGridPainter()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 72, vertical: 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const OnboardingBoltIcon(size: 28),
                    const SizedBox(width: 10),
                    Text(
                      'DeyLyte',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OnboardingStepIndicator(currentStep: 3),
                    const SizedBox(height: 40),
                    Text(
                      'Install the\nadd-on.',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontSize: 48,
                            height: 1.1,
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.03,
                          ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Follow the steps to connect your\nHome Assistant add-on.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.onSurfaceVariant,
                            height: 1.6,
                          ),
                    ),
                  ],
                ),
                Text(
                  'Powering your peak efficiency',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.outline,
                        letterSpacing: 0.1,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
