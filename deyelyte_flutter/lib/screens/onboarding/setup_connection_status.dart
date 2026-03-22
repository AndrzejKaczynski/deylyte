import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/components.dart';
import '../../providers/app_providers.dart';
import '../../theme/theme.dart';

class SetupConnectionStatus extends ConsumerStatefulWidget {
  const SetupConnectionStatus({super.key});

  @override
  ConsumerState<SetupConnectionStatus> createState() =>
      _SetupConnectionStatusState();
}

class _SetupConnectionStatusState
    extends ConsumerState<SetupConnectionStatus> {
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
      // Advance if currently connected OR if device has ever connected (lastSeenAt != null)
      final everConnected = status['lastSeenAt'] != null;
      if (status['connected'] == true || everConnected) {
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
        _ConnState.connected => 'Add-on connected! Loading your dashboard...',
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
