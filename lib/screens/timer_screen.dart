import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:timer/widgets/empty_state.dart';
import 'package:timer/widgets/native_ad.dart';
import '../providers/timer_provider.dart';
import '../widgets/timer_card.dart';
import '../widgets/add_timer_sheet.dart';
import '../widgets/screen_header.dart';
import '../widgets/color_filter.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  String? selectedColor;

  @override
  Widget build(BuildContext context) {
    final color = context.watch<ThemeProvider>();

    return Consumer<TimerProvider>(
      builder: (context, provider, _) {
        final timers = selectedColor == null
            ? provider.sortedTimers
            : provider.sortedTimers
                  .where((timer) => timer.color == selectedColor)
                  .toList();

        return Scaffold(
          backgroundColor: color.background(context),
          body: SafeArea(
            child: Column(
              children: [
                ScreenHeader(
                  title: 'TIMER',
                  subtitle:
                      '${timers.where((t) => t.isRunning).length} running',
                  actions: [
                    ColorFilterButton(
                      selectedColor: selectedColor,
                      onChanged: (color) {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: timers.isEmpty
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
                          itemCount: timers.isEmpty ? 0 : timers.length + 1,
                          itemBuilder: (context, index) {
                            if (index == timers.length) {
                              return const Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: SizedBox(
                                  height: 200,
                                  child: NativeAdWidget(),
                                ),
                              );
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TimerCard(timer: timers[index]),
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
