import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:timer/widgets/empty_state.dart';
import 'package:timer/widgets/global_action.dart';
import '../providers/stopwatch_provider.dart';
import '../widgets/stopwatch_card.dart';
import '../widgets/add_stopwatch_sheet.dart';
import '../widgets/screen_header.dart';

class StopwatchScreen extends StatelessWidget {
  const StopwatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.watch<ThemeProvider>();

    return Consumer<StopwatchProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: color.surface(context),
          body: SafeArea(
            child: Column(
              children: [
                ScreenHeader(
                  title: 'STOPWATCH',
                  subtitle: '${provider.stopwatches.where((s) => s.isRunning).length} running',
                  actions: provider.stopwatches.isEmpty
                      ? []
                      : [
                          GlobalAction(
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
                          GlobalAction(
                            icon: Icons.refresh_rounded,
                            label: 'Reset All',
                            color: color.onSurface(context),
                            onTap: provider.resetAll,
                          ),
                        ],
                ),
                Expanded(
                  child: provider.stopwatches.isEmpty
                      ?  EmptyState(
                            onAdd: () => _showAddSheet(context),
                            title: 'No stopwatches yet',
                            subtitle: 'Track multiple activities simultaneously\nwith named stopwatches.',
                            buttonText: 'Add Stopwatch',
                            icon: Icons.av_timer_outlined,
                          )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          itemCount: provider.stopwatches.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: StopwatchCard(entry: provider.stopwatches[i]),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddSheet(context),
            backgroundColor: color.primary(context),
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
      builder: (_) => const AddStopwatchSheet(),
    );
  }
}