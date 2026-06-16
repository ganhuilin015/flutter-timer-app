import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:timer/widgets/empty_state.dart';
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
        final stopwatches = provider.sortedStopwatches;

        return Scaffold(
          backgroundColor: color.surface(context),
          body: SafeArea(
            child: Column(
              children: [
                ScreenHeader(
                  title: 'STOPWATCH',
                  subtitle: '${stopwatches.where((s) => s.isRunning).length} running'
                ),
                Expanded(
                  child: stopwatches.isEmpty
                      ?  EmptyState(
                            onAdd: () => _showAddSheet(context),
                            title: 'No stopwatches yet',
                            subtitle: 'Track multiple activities simultaneously\nwith named stopwatches.',
                            buttonText: 'Add Stopwatch',
                            icon: Icons.av_timer_outlined,
                          )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          itemCount: stopwatches.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: StopwatchCard(entry: stopwatches[i]),
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