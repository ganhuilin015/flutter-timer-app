import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/providers/theme_provider.dart';
import '../providers/timer_provider.dart';
import '../models/timer_item.dart';
import '../theme/app_theme.dart';
import '../widgets/timer_card.dart';
import '../widgets/add_timer_sheet.dart';
import '../widgets/screen_header.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.watch<ThemeProvider>();
    return Consumer<TimerProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: color.background(context),
          body: SafeArea(
            child: Column(
              children: [
                ScreenHeader(
                  title: 'TIMER',
                  subtitle:
                      '${provider.timers.where((t) => t.isRunning).length} running',
                  actions: provider.timers.isEmpty
                      ? []
                      : [
                          _GlobalAction(
                            icon: provider.anyRunning
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            label: provider.anyRunning
                                ? 'Pause All'
                                : 'Start All',
                            color: color.onSurface(context),
                            onTap: () => provider.anyRunning
                                ? provider.pauseAll()
                                : provider.startAll(),
                          ),
                          _GlobalAction(
                            icon: Icons.refresh_rounded,
                            label: 'Reset All',
                            color: color.onSurface(context),
                            onTap: provider.resetAll,
                          ),
                        ],
                ),
                Expanded(
                  child: provider.timers.isEmpty
                      ? _EmptyState(onAdd: () => _showAddSheet(context))
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          itemCount: provider.timers.length,
                          itemBuilder: (context, i) {
                            final timer = provider.timers[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TimerCard(timer: timer),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddSheet(context),
            child: const Icon(Icons.add_rounded),
          ),
        );
      },
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddTimerSheet(),
    );
  }
}

class _GlobalAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _GlobalAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final color = context.watch<ThemeProvider>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.primary(context)
            ),
            child: Icon(
              Icons.timer_outlined,
              color: color.onPrimary(context),
              size: 36,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No timers yet',
            style: TextStyle(
              color: color.onSurface(context),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a timer to get started.\nYou can run multiple timers at once.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color.onSurface(context),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Timer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: color.primary(context).withAlpha(180),  
              foregroundColor: color.onPrimary(context), 
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}
