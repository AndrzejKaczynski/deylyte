import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../providers/app_providers.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Onboarding Step 2 — License Key Entry
// ─────────────────────────────────────────────────────────────────────────────

class OnboardingLicenseScreen extends ConsumerStatefulWidget {
  const OnboardingLicenseScreen({super.key});

  @override
  ConsumerState<OnboardingLicenseScreen> createState() =>
      _OnboardingLicenseScreenState();
}

class _OnboardingLicenseScreenState
    extends ConsumerState<OnboardingLicenseScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _keyController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _keyController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      _shakeController.forward(from: 0);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = ref.read(licenseRepositoryProvider);
      final result = await repo.validate(_keyController.text.trim());

      if (!mounted) return;

      if (result['valid'] == true) {
        const storage = FlutterSecureStorage();
        await storage.write(
          key: 'license_key',
          value: _keyController.text.trim(),
        );
        if (mounted) context.go('/onboarding/setup');
      } else {
        setState(() {
          _errorMessage =
              result['reason'] as String? ?? 'Invalid license key.';
          _isLoading = false;
        });
        _shakeController.forward(from: 0);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Connection error. Please try again.';
        _isLoading = false;
      });
      _shakeController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 900;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          isDesktop
              ? _DesktopLayout(
                  formKey: _formKey,
                  keyController: _keyController,
                  isLoading: _isLoading,
                  errorMessage: _errorMessage,
                  shakeAnimation: _shakeAnimation,
                  onSubmit: _submit,
                )
              : _MobileLayout(
                  formKey: _formKey,
                  keyController: _keyController,
                  isLoading: _isLoading,
                  errorMessage: _errorMessage,
                  shakeAnimation: _shakeAnimation,
                  onSubmit: _submit,
                ),
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: _LogoutButton(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Desktop layout ────────────────────────────────────────────────────────────

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.formKey,
    required this.keyController,
    required this.isLoading,
    required this.errorMessage,
    required this.shakeAnimation,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController keyController;
  final bool isLoading;
  final String? errorMessage;
  final Animation<double> shakeAnimation;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(flex: 55, child: _HeroPanel()),
        Expanded(
          flex: 45,
          child: Container(
            color: AppColors.surfaceContainerLowest,
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 48),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: _LicenseForm(
                    formKey: formKey,
                    keyController: keyController,
                    isLoading: isLoading,
                    errorMessage: errorMessage,
                    shakeAnimation: shakeAnimation,
                    onSubmit: onSubmit,
                    isDesktop: true,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Mobile layout ─────────────────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.formKey,
    required this.keyController,
    required this.isLoading,
    required this.errorMessage,
    required this.shakeAnimation,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController keyController;
  final bool isLoading;
  final String? errorMessage;
  final Animation<double> shakeAnimation;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MobileLogo(),
            const SizedBox(height: 32),
            _StepIndicator(currentStep: 1),
            const SizedBox(height: 32),
            _LicenseForm(
              formKey: formKey,
              keyController: keyController,
              isLoading: isLoading,
              errorMessage: errorMessage,
              shakeAnimation: shakeAnimation,
              onSubmit: onSubmit,
              isDesktop: false,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Hero panel (desktop left side) ───────────────────────────────────────────

class _HeroPanel extends StatelessWidget {
  const _HeroPanel();

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
            padding:
                const EdgeInsets.symmetric(horizontal: 72, vertical: 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const _BoltIcon(size: 28),
                    const SizedBox(width: 10),
                    Text(
                      'DeyLyte',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
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
                    _StepIndicator(currentStep: 1),
                    const SizedBox(height: 40),
                    Text(
                      'Activate\nyour license.',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(
                            fontSize: 48,
                            height: 1.1,
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.03,
                          ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Enter the license key from your purchase\nconfirmation email to unlock EMS features.',
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

// ── License form ─────────────────────────────────────────────────────────────

class _LicenseForm extends StatelessWidget {
  const _LicenseForm({
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
        final offset =
            math.sin(shakeAnimation.value * math.pi * 4) * 8.0;
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

// ── Step indicator ────────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});

  final int currentStep; // 1-based

  static const _steps = ['Register', 'License Key', 'Setup'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // connector line
          return Expanded(
            child: Container(
              height: 1,
              color: AppColors.outlineVariant,
            ),
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
                  color: isActive
                      ? AppColors.primary
                      : AppColors.outlineVariant,
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
                    fontWeight:
                        isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ],
        );
      }),
    );
  }
}

// ── Mobile logo ───────────────────────────────────────────────────────────────

class _MobileLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _BoltIcon(size: 28),
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

// ── Lightning bolt icon (reused from auth_screen) ─────────────────────────────

class _BoltIcon extends StatelessWidget {
  const _BoltIcon({required this.size});

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

class _LogoutButton extends ConsumerWidget {
  const _LogoutButton();

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
