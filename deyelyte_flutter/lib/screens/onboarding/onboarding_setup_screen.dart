import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../providers/app_providers.dart';
import '../../theme/theme.dart';
import '../../components/components.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Onboarding Step 3 — Install guide + connection wait
// ─────────────────────────────────────────────────────────────────────────────

class OnboardingSetupScreen extends ConsumerStatefulWidget {
  const OnboardingSetupScreen({super.key});

  @override
  ConsumerState<OnboardingSetupScreen> createState() =>
      _OnboardingSetupScreenState();
}

class _OnboardingSetupScreenState
    extends ConsumerState<OnboardingSetupScreen> {
  String? _licenseKey;

  @override
  void initState() {
    super.initState();
    _loadKey();
  }

  Future<void> _loadKey() async {
    const storage = FlutterSecureStorage();
    final key = await storage.read(key: 'license_key');
    if (mounted) setState(() => _licenseKey = key ?? '—');
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
  const _DesktopLayout({required this.licenseKey});

  final String? licenseKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(flex: 55, child: _HeroPanel()),
        Expanded(
          flex: 45,
          child: Container(
            color: AppColors.surfaceContainerLowest,
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 64, vertical: 48),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: _SetupContent(licenseKey: licenseKey, isDesktop: true),
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
  const _MobileLayout({required this.licenseKey});

  final String? licenseKey;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: _SetupContent(licenseKey: licenseKey, isDesktop: false),
      ),
    );
  }
}

// ── Hero panel ────────────────────────────────────────────────────────────────

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
                    _StepIndicator(currentStep: 2),
                    const SizedBox(height: 40),
                    Text(
                      'Install the\nadd-on.',
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

// ── Main content ──────────────────────────────────────────────────────────────

class _SetupContent extends StatelessWidget {
  const _SetupContent({
    required this.licenseKey,
    required this.isDesktop,
  });

  final String? licenseKey;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isDesktop) ...[
          Row(
            children: [
              const _BoltIcon(size: 22),
              const SizedBox(width: 8),
              Text(
                'DeyLyte',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _StepIndicator(currentStep: 2),
          const SizedBox(height: 32),
        ] else ...[
          Row(
            children: [
              const _BoltIcon(size: 24),
              const SizedBox(width: 8),
              Text(
                'DeyLyte',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _StepIndicator(currentStep: 2),
          const SizedBox(height: 32),
        ],
        Text(
          'Install the DeyLyte add-on',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Follow these steps in Home Assistant to connect your inverter.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 32),
        _SetupSteps(licenseKey: licenseKey ?? '—'),
        const SizedBox(height: 40),
        const _ConnectionStatusWidget(),
      ],
    );
  }
}

// ── Step list ─────────────────────────────────────────────────────────────────

class _SetupSteps extends StatelessWidget {
  const _SetupSteps({required this.licenseKey});

  final String licenseKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Step(
          number: 1,
          title: 'Install HACS on Home Assistant',
          body: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    height: 1.5,
                  ),
              children: const [
                TextSpan(text: 'Visit '),
                TextSpan(
                  text: 'hacs.xyz',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                    text:
                        ' and follow the installation guide for your HA setup.'),
              ],
            ),
          ),
        ),
        _Step(
          number: 2,
          title: 'Add DeyLyte as a custom HACS repository',
          body: _CopyChip(
            label: 'github.com/deylyte/ha-addon',
            value: 'https://github.com/deylyte/ha-addon',
          ),
        ),
        _Step(
          number: 3,
          title: 'Install the DeyLyte EMS add-on from HACS',
          body: Text(
            'Search for "DeyLyte EMS" in HACS → Integrations and install it.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  height: 1.5,
                ),
          ),
        ),
        _Step(
          number: 4,
          title: 'Open add-on config and enter',
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ConfigField(
                label: 'License key',
                child: _CopyChip(
                  label: licenseKey,
                  value: licenseKey,
                ),
              ),
              const SizedBox(height: 8),
              _ConfigField(
                label: 'Solarman dongle IP address',
                child: Text(
                  'e.g. 192.168.1.100',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              _ConfigField(
                label: 'Solarman dongle serial number',
                child: Text(
                  'Found on the dongle sticker',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ),
            ],
          ),
        ),
        _Step(
          number: 5,
          title: 'Start the add-on',
          body: Text(
            'Go to the add-on page → "Start". Check the logs to confirm it started without errors.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  height: 1.5,
                ),
          ),
          isLast: true,
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.number,
    required this.title,
    required this.body,
    this.isLast = false,
  });

  final int number;
  final String title;
  final Widget body;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.15),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1,
                    color: AppColors.outlineVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  body,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfigField extends StatelessWidget {
  const _ConfigField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}

class _CopyChip extends StatelessWidget {
  const _CopyChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Copied to clipboard'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.copy_rounded,
                size: 14, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

// ── Connection status polling widget ──────────────────────────────────────────

class _ConnectionStatusWidget extends ConsumerStatefulWidget {
  const _ConnectionStatusWidget();

  @override
  ConsumerState<_ConnectionStatusWidget> createState() =>
      _ConnectionStatusWidgetState();
}

class _ConnectionStatusWidgetState
    extends ConsumerState<_ConnectionStatusWidget> {
  Timer? _timer;
  _ConnState _state = _ConnState.waiting;

  @override
  void initState() {
    super.initState();
    _poll();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _poll());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _poll() async {
    try {
      final repo = ref.read(deviceRepositoryProvider);
      final status = await repo.getStatus();
      if (!mounted) return;
      if (status['connected'] == true) {
        _timer?.cancel();
        setState(() => _state = _ConnState.connected);
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) context.go('/');
      }
    } catch (_) {
      // silently ignore poll errors — keep waiting
    }
  }

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            _StateIndicator(state: _state),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _title => switch (_state) {
        _ConnState.waiting => 'Waiting for add-on to connect...',
        _ConnState.connected =>
          'Add-on connected! Loading your dashboard...',
        _ConnState.error => 'Something went wrong',
      };

  String get _subtitle => switch (_state) {
        _ConnState.waiting =>
          'Checking every 5 seconds. Start the add-on in Home Assistant.',
        _ConnState.connected => 'Redirecting you now.',
        _ConnState.error =>
          'Check the add-on logs in Home Assistant for details.',
      };
}

enum _ConnState { waiting, connected, error }

class _StateIndicator extends StatelessWidget {
  const _StateIndicator({required this.state});

  final _ConnState state;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      _ConnState.waiting || _ConnState.connected => const PulseIndicator(
          color: AppColors.secondary,
          size: 12,
        ),
      _ConnState.error => const WarningBadge(label: 'Error'),
    };
  }
}

// ── Step indicator ────────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});

  final int currentStep;

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

// ── Reusable bolt icon ────────────────────────────────────────────────────────

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
