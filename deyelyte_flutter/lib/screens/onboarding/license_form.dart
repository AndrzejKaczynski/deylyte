import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../components/components.dart';
import '../../theme/theme.dart';
import 'onboarding_shared.dart';

class LicenseForm extends StatelessWidget {
  const LicenseForm({
    super.key,
    required this.formKey,
    required this.keyController,
    required this.isLoading,
    required this.errorMessage,
    required this.shakeAnimation,
    required this.onSubmit,
    required this.isDesktop,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController keyController;
  final bool isLoading;
  final String? errorMessage;
  final Animation<double> shakeAnimation;
  final VoidCallback onSubmit;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shakeAnimation,
      builder: (context, child) {
        final offset = math.sin(shakeAnimation.value * math.pi * 4) * 8.0;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your license key',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check your purchase confirmation email for the key.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 36),
            TextFormField(
              controller: keyController,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => onSubmit(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurface,
                    fontFamily: 'monospace',
                  ),
              decoration: const InputDecoration(
                labelText: 'License key',
                hintText: 'XXXX-XXXX-XXXX-XXXX',
                prefixIcon: Icon(Icons.vpn_key_outlined, size: 20),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'License key is required';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 16),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: errorMessage != null
                  ? Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.errorContainer.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              size: 16, color: AppColors.error),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorMessage!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.error),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 8),
            GradientButton(
              onPressed: isLoading ? null : onSubmit,
              isLoading: isLoading,
              label: 'Continue',
            ),
          ],
        ),
      ),
    );
  }
}

// ── Mobile logo ───────────────────────────────────────────────────────────────

class LicenseMobileLogo extends StatelessWidget {
  const LicenseMobileLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const OnboardingBoltIcon(size: 28),
        const SizedBox(width: 10),
        Text(
          'DeyLyte',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
        ),
      ],
    );
  }
}
