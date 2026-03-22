import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../providers/app_providers.dart';
import '../../theme/theme.dart';
import 'onboarding_shared.dart';
import 'license_hero_panel.dart';
import 'license_form.dart';

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
          _errorMessage = result['reason'] as String? ?? 'Invalid license key.';
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
          const Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: OnboardingLogoutButton(),
            ),
          ),
        ],
      ),
    );
  }
}

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
        const Expanded(flex: 55, child: LicenseHeroPanel()),
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
                  child: LicenseForm(
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
            const LicenseMobileLogo(),
            const SizedBox(height: 32),
            const OnboardingStepIndicator(currentStep: 2),
            const SizedBox(height: 32),
            LicenseForm(
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
