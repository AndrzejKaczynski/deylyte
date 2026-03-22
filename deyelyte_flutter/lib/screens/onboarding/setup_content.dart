import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/components.dart';
import '../../theme/theme.dart';
import 'onboarding_shared.dart';
import 'setup_connection_status.dart';

class SetupContent extends StatelessWidget {
  const SetupContent({
    super.key,
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
              const OnboardingBoltIcon(size: 22),
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
          const OnboardingStepIndicator(currentStep: 3),
          const SizedBox(height: 32),
        ] else ...[
          Row(
            children: [
              const OnboardingBoltIcon(size: 24),
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
          const OnboardingStepIndicator(currentStep: 3),
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
        SetupSteps(licenseKey: licenseKey ?? '—'),
        const SizedBox(height: 40),
        const SetupConnectionStatus(),
      ],
    );
  }
}

// ── Step list ─────────────────────────────────────────────────────────────────

class SetupSteps extends StatelessWidget {
  const SetupSteps({super.key, required this.licenseKey});

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
        const _Step(
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
