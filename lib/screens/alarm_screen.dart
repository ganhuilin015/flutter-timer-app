import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:timer/widgets/empty_state.dart';
import '../providers/alarm_provider.dart';
import '../widgets/alarm_card.dart';
import '../widgets/add_alarm_sheet.dart';
import '../widgets/screen_header.dart';

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<ThemeProvider>();

    return Consumer<AlarmProvider>(
      builder: (context, provider, _) {
        // Show firing alarm dialog
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (provider.firingAlarm != null) {
            _showFiringDialog(context, provider);
          }
        });

        return Scaffold(
          backgroundColor: themeColor.surface(context),
          body: SafeArea(
            child: Column(
              children: [
                ScreenHeader(
                  title: 'ALARM',
                  subtitle: '${provider.alarms.where((a) => a.isEnabled).length} active',
                ),
                Expanded(
                  child: provider.alarms.isEmpty
                      ?  EmptyState(
                            onAdd: () => _showAddSheet(context),
                            title: 'No alarms set',
                            subtitle: 'Add an alarm with custom repeat\nschedules and names.',
                            buttonText: 'Add Alarm',
                            icon: Icons.av_timer_outlined,
                          )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          itemCount: provider.alarms.length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AlarmCard(alarm: provider.alarms[i]),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddSheet(context),
            backgroundColor: themeColor.primary(context),
            child: const Icon(Icons.add_rounded),
          ),
        );
      },
    );
  }

  void _showAddSheet(BuildContext context, {alarm}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddAlarmSheet(existing: alarm),
    );
  }

  void _showFiringDialog(BuildContext context, AlarmProvider provider) {
    final alarm = provider.firingAlarm!;
    final themeColor = context.read<ThemeProvider>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: themeColor.onSurface(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.alarm, color: themeColor.primary(context), size: 28),
            const SizedBox(width: 12),
            Text(alarm.name, style: TextStyle(color: themeColor.primary(context))),
          ],
        ),
        content: Text(
          alarm.formattedTime,
          style: TextStyle(
            color: themeColor.primary(context),
            fontSize: 48,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              provider.dismissFiring();
              Navigator.pop(context);
            },
            child: Text('Dismiss', style: TextStyle(color: themeColor.primary(context))),
          ),
        ],
      ),
    );
  }
}
