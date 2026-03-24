import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'forecast_hour_data.dart';

// ─── Planned Battery Action strip ─────────────────────────────────────────────

class CommandStrip extends StatelessWidget {
  const CommandStrip({super.key, required this.hours});

  final List<HourData> hours;

  @override
  Widget build(BuildContext context) {
    // Group consecutive same-command hours into segments
    final segments = <_Segment>[];
    for (var i = 0; i < hours.length; i++) {
      final cmd = hours[i].command ?? 'idle';
      if (segments.isEmpty || segments.last.command != cmd) {
        segments.add(_Segment(command: cmd, start: i, end: i));
      } else {
        segments.last = _Segment(
          command: cmd,
          start: segments.last.start,
          end: i,
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            'PLANNED BATTERY ACTION',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 0.8,
                  fontSize: 9,
                ),
          ),
        ),
        SizedBox(
          height: 28,
          child: Row(
            children: segments.map((seg) {
              final flex = seg.end - seg.start + 1;
              final color = _commandColor(seg.command);
              final label = _commandLabel(seg.command);
              return Expanded(
                flex: flex,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: color.withValues(alpha: 0.40),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: flex >= 2
                      ? Text(
                          label,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: color,
                                fontWeight: FontWeight.w700,
                                fontSize: 9,
                                letterSpacing: 0.5,
                              ),
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Color _commandColor(String command) {
    return switch (command) {
      'charge' => AppColors.secondary,
      'discharge' => AppColors.error,
      _ => AppColors.outlineVariant,
    };
  }

  String _commandLabel(String command) {
    return switch (command) {
      'charge' => 'CHARGE',
      'discharge' => 'DISCHARGE',
      _ => 'IDLE',
    };
  }
}

// ─── Internal segment model ───────────────────────────────────────────────────

class _Segment {
  _Segment({required this.command, required this.start, required this.end});
  final String command;
  final int start;
  final int end;
}
