import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/models/timer_item.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:timer/widgets/empty_state.dart';
import 'package:timer/screens/full_screen_alert.dart';
import '../providers/timer_provider.dart';
import '../widgets/timer_card.dart';
import '../widgets/add_timer_sheet.dart';
import '../widgets/screen_header.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  bool _isShowingTimer = false;

  void _showFiringTimer(TimerItem timer, TimerProvider provider) {
    if (_isShowingTimer) return;
    _isShowingTimer = true;

    final data = AlertData(
      title: timer.name.isNotEmpty ? timer.name : 'Timer',
      subtitle: timer.formattedTime,
      icon: Icons.timer,
    );

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (_, __, ___) => FullScreenAlert(
        data: data,
        onDismiss: () {
          provider.dismissFiring();
          provider.cancelNative(timer);
          if (context.mounted) {
            Navigator.pop(context);
          }
          _isShowingTimer = false;
        },
      ),
    ).then((_) => _isShowingTimer = false);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.watch<ThemeProvider>();

    return Consumer<TimerProvider>(
      builder: (context, provider, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          final timer = provider.firingTimer;
          if (timer != null && !_isShowingTimer) {
            _showFiringTimer(timer, provider);
          }
        });

        return Scaffold(
          backgroundColor: color.background(context),
          body: SafeArea(
            child: Column(
              children: [
                ScreenHeader(
                  title: 'TIMER',
                  subtitle:
                      '${provider.timers.where((t) => t.isRunning).length} running',
                ),
                Expanded(
                  child: provider.timers.isEmpty
                      ? EmptyState(
                          onAdd: () => _showAddSheet(context),
                          title: 'No timers yet',
                          subtitle:
                              'Add a timer to get started.\nYou can run multiple timers at once.',
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