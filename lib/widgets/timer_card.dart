import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/timer_item.dart';
import '../providers/timer_provider.dart';
import '../theme/app_theme.dart';
import 'color_utils.dart';
import 'add_timer_sheet.dart';

class TimerCard extends StatelessWidget {
  final TimerItem timer;
  const TimerCard({super.key, required this.timer});

  @override
  Widget build(BuildContext context) {
    final color = hexToColor(timer.color);
    final provider = context.read<TimerProvider>();

    return Dismissible(
      key: ValueKey(timer.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.danger.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppTheme.danger),
      ),
      onDismissed: (_) => provider.removeTimer(timer.id),
      child: GestureDetector(
        onLongPress: () => _showEditSheet(context),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: timer.isRunning
                  ? color.withOpacity(0.5)
                  : timer.isFinished
                      ? AppTheme.danger.withOpacity(0.4)
                      : AppTheme.border,
              width: timer.isRunning ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              // Progress bar
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: SizedBox(
                  height: 3,
                  child: LinearProgressIndicator(
                    value: timer.progress,
                    backgroundColor: AppTheme.border,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      timer.isFinished ? AppTheme.danger : color,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Color dot
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: timer.isFinished ? AppTheme.danger : color,
                            boxShadow: timer.isRunning
                                ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 6)]
                                : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            timer.name,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Status chip
                        _StatusChip(timer: timer),
                        const SizedBox(width: 12),
                        // Enable toggle
                        Transform.scale(
                          scale: 0.85,
                          child: Switch(
                            value: timer.isEnabled,
                            onChanged: (_) => provider.toggleEnabled(timer.id),
                            activeColor: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Time display
                        Text(
                          timer.formattedTime,
                          style: TextStyle(
                            color: timer.isFinished
                                ? AppTheme.danger
                                : timer.isRunning
                                    ? color
                                    : AppTheme.textPrimary,
                            fontSize: 38,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 2,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            '/ ${timer.formattedTotal}',
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Action buttons
                        Row(
                          children: [
                            if (!timer.isFinished) ...[
                              _CircleBtn(
                                icon: timer.isRunning
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: color,
                                onTap: () => timer.isRunning
                                    ? provider.pauseTimer(timer.id)
                                    : provider.startTimer(timer.id),
                                enabled: timer.isEnabled || timer.isRunning,
                              ),
                              const SizedBox(width: 8),
                            ],
                            _CircleBtn(
                              icon: Icons.refresh_rounded,
                              color: AppTheme.textSecondary,
                              onTap: () => provider.resetTimer(timer.id),
                              enabled: true,
                              small: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTimerSheet(existing: timer),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final TimerItem timer;
  const _StatusChip({required this.timer});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (timer.status) {
      TimerStatus.running => ('RUNNING', AppTheme.success),
      TimerStatus.paused => ('PAUSED', AppTheme.accentAmber),
      TimerStatus.finished => ('DONE', AppTheme.danger),
      TimerStatus.idle => ('IDLE', AppTheme.textMuted),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool enabled;
  final bool small;

  const _CircleBtn({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.enabled,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = small ? 32.0 : 40.0;
    final iconSize = small ? 16.0 : 20.0;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled ? color.withOpacity(0.15) : AppTheme.border.withOpacity(0.3),
          border: Border.all(
            color: enabled ? color.withOpacity(0.4) : AppTheme.border.withOpacity(0.3),
          ),
        ),
        child: Icon(
          icon,
          color: enabled ? color : AppTheme.textMuted,
          size: iconSize,
        ),
      ),
    );
  }
}
