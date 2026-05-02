import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:timer/widgets/empty_state.dart';
import 'package:timer/widgets/local_time_card.dart';

import '../providers/world_clock_provider.dart';
import '../models/world_clock_entry.dart';

import '../widgets/world_clock_card.dart';
import '../widgets/add_world_clock_sheet.dart';
import '../widgets/screen_header.dart';

class WorldClockScreen extends StatelessWidget {
  const WorldClockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.watch<ThemeProvider>();

    return Consumer<WorldClockProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: color.surface(context),
          body: SafeArea(
            child: Column(
              children: [
                ScreenHeader(
                  title: 'WORLD',
                  subtitle: '${provider.clocks.length} cities',
                ),

                const LocalTimeCard(),

                Expanded(
                  child: provider.clocks.isEmpty
                      ? EmptyState(
                          onAdd: () => _showAddSheet(context),
                          title: 'No clocks yet',
                          subtitle: 'Keep track of time across the world\nby adding cities to your clock list.',
                          buttonText: 'Add City',
                          icon: Icons.public_outlined,
                        )
                      : ReorderableListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          itemCount: provider.clocks.length,

                          onReorder: (oldIndex, newIndex) {
                            provider.reorder(oldIndex, newIndex);
                          },

                          itemBuilder: (context, i) {
                            final WorldClock clock = provider.clocks[i];

                            return Padding(
                              key: ValueKey(clock.id),
                              padding: const EdgeInsets.only(bottom: 12),
                              child: WorldClockCard(clock: clock,),
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
      builder: (_) => const AddWorldClockSheet(),
    );
  }
}