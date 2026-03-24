import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';
import '../../theme/theme.dart';
import 'onboarding_shared.dart';
import 'setup_hero_panel.dart';
import 'setup_content.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Onboarding Step 3 — Install guide + connection wait
// ─────────────────────────────────────────────────────────────────────────────

class OnboardingSetupScreen extends ConsumerStatefulWidget {
  const OnboardingSetupScreen({super.key, this.licenseKey});

  /// Passed via GoRouter extra from the license screen. Null on page refresh.
  final String? licenseKey;

  @override
  ConsumerState<OnboardingSetupScreen> createState() =>
      _OnboardingSetupScreenState();
}

class _OnboardingSetupScreenState extends ConsumerState<OnboardingSetupScreen> {
  String? _licenseKey;

  @override
  void initState() {
    super.initState();
    if (widget.licenseKey != null) {
      _licenseKey = widget.licenseKey;
    } else {
      _loadKeyFromServer();
    }
  }

  Future<void> _loadKeyFromServer() async {
    try {
      final raw = await ref.read(clientProvider).license.getUserLicense();
      final data = jsonDecode(raw) as Map<String, dynamic>;
      if (mounted) setState(() => _licenseKey = data['licenseKey'] as String? ?? '—');
    } catch (_) {
      if (mounted) setState(() => _licenseKey = '—');
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
              ? _DesktopLayout(licenseKey: _licenseKey)
              : _MobileLayout(licenseKey: _licenseKey),
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
  const _DesktopLayout({required this.licenseKey});

  final String? licenseKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(flex: 55, child: SetupHeroPanel()),
        Expanded(
          flex: 45,
          child: Container(
            color: AppColors.surfaceContainerLowest,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 48),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SetupContent(licenseKey: licenseKey, isDesktop: true),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.licenseKey});

  final String? licenseKey;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: SetupContent(licenseKey: licenseKey, isDesktop: false),
      ),
    );
  }
}
