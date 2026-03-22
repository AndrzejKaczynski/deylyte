import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import '../../theme/theme.dart';

// ── Step indicator ────────────────────────────────────────────────────────────

class OnboardingStepIndicator extends StatelessWidget {
  const OnboardingStepIndicator({super.key, required this.currentStep});

  final int currentStep; // 1-based

  static const _steps = ['Register', 'License Key', 'Setup'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          return Expanded(
            child: Container(height: 1, color: AppColors.outlineVariant),
          );
        }
        final step = i ~/ 2 + 1;
        final isActive = step == currentStep;
        final isDone = step < currentStep;
        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive || isDone
                    ? AppColors.primary
                    : AppColors.surfaceContainerHigh,
                border: Border.all(
                  color:
                      isActive ? AppColors.primary : AppColors.outlineVariant,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: isDone
                    ? const Icon(Icons.check_rounded,
                        size: 14, color: Colors.white)
                    : Text(
                        '$step',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? Colors.white
                              : AppColors.onSurfaceVariant,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _steps[step - 1],
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isActive
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ],
        );
      }),
    );
  }
}

// ── Bolt icon ─────────────────────────────────────────────────────────────────

class OnboardingBoltIcon extends StatelessWidget {
  const OnboardingBoltIcon({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _BoltPainter()),
    );
  }
}

class _BoltPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.secondary
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(size.width * 0.62, 0)
      ..lineTo(size.width * 0.25, size.height * 0.52)
      ..lineTo(size.width * 0.50, size.height * 0.52)
      ..lineTo(size.width * 0.38, size.height)
      ..lineTo(size.width * 0.75, size.height * 0.48)
      ..lineTo(size.width * 0.50, size.height * 0.48)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BoltPainter old) => false;
}

// ── Logout button ─────────────────────────────────────────────────────────────

class OnboardingLogoutButton extends ConsumerWidget {
  const OnboardingLogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      icon: const Icon(Icons.logout_rounded, size: 16),
      label: const Text('Sign out'),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.onSurfaceVariant,
      ),
      onPressed: () async {
        await ref.read(sessionManagerProvider).signOutDevice();
      },
    );
  }
}
