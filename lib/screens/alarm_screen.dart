import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/models/alarm_item.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:timer/widgets/empty_state.dart';
import 'package:timer/screens/full_screen_alert.dart';
import '../providers/alarm_provider.dart';
import '../widgets/alarm_card.dart';
import '../widgets/add_alarm_sheet.dart';
import '../widgets/screen_header.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  bool _isShowingAlarm = false;

  void _showAddSheet({AlarmItem? alarm}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddAlarmSheet(existing: alarm),
    );
  }

  void _showFiringAlarm(AlarmItem alarm, AlarmProvider provider) {
    if (_isShowingAlarm) return;
    _isShowingAlarm = true;

    final data = AlertData(
      title: alarm.name.isNotEmpty ? alarm.name : 'Alarm',
      subtitle: alarm.formattedTime,
      icon: Icons.alarm,
    );

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (_, __, ___) => FullScreenAlert(
        data: data,
        onDismiss: () {
          provider.dismissFiring();
          provider.cancelNative(alarm);
          if (context.mounted) {
            Navigator.pop(context);
          }
          _isShowingAlarm = false;
        },
      ),
    ).then((_) => _isShowingAlarm = false);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<ThemeProvider>();

    return Consumer<AlarmProvider>(
      builder: (context, provider, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          final alarm = provider.firingAlarm;
          if (alarm != null && !_isShowingAlarm) {
            _showFiringAlarm(alarm, provider);
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
                      ? EmptyState(
                          onAdd: () => _showAddSheet(),
                          title: 'No alarms set',
                          subtitle: 'Add an alarm with custom repeat\nschedules and names.',
                          buttonText: 'Add Alarm',
                          icon: Icons.av_timer_outlined,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          itemCount: provider.alarms.length,
                          itemBuilder: (context, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AlarmCard(alarm: provider.alarms[i]),
                          ),
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddSheet(),
            backgroundColor: themeColor.primary(context),
            child: const Icon(Icons.add_rounded),
          ),
        );
      },
    );
  }
}