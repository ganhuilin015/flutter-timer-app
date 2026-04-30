import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:timer/widgets/empty_state.dart';
import '../providers/timer_provider.dart';
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
                      '${provider.timers.where((t) => t.isRunning).length} running'
                ),
                Expanded(
                  child: provider.timers.isEmpty
                      ? EmptyState(
                          onAdd: () => _showAddSheet(context),
                          title: 'No timers yet',
                          subtitle: 'Add a timer to get started.\nYou can run multiple timers at once.',
                          buttonText: 'Add Timer',
                          icon: Icons.timer_outlined,
                        )
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