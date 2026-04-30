import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/providers/theme_provider.dart';
import '../models/alarm_item.dart';
import '../providers/alarm_provider.dart';
import 'color_utils.dart';
import 'add_alarm_sheet.dart';

class AlarmCard extends StatelessWidget {
  final AlarmItem alarm;
  const AlarmCard({super.key, required this.alarm});

  @override
  Widget build(BuildContext context) {
    final color = hexToColor(alarm.color);
    final provider = context.read<AlarmProvider>();
    final themeColor = context.watch<ThemeProvider>();

    return Dismissible(
      key: ValueKey(alarm.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: themeColor.error(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_outline_rounded, color: themeColor.onError(context)),
      ),
      onDismissed: (_) => provider.removeAlarm(alarm.id),
      child: GestureDetector(
        onTap: () => _showEditSheet(context),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: alarm.isEnabled ? 1.0 : 0.5,
          child: Container(
            decoration: BoxDecoration(
              color: themeColor.secondary(context),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (alarm.name.trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2, bottom: 8, right: 5),
                        child: Text(
                          alarm.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: themeColor.onSurface(context),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            alarm.formattedTime,
                            style: TextStyle(
                              color: themeColor.onSurface(context),
                              fontSize: 38,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const Spacer(),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildRepeatDays(
                                repeatDays: alarm.repeatDays,
                                activeColor: color,
                                inactiveColor: themeColor.onSurface(context).withAlpha(150),
                              ),

                              const SizedBox(width: 12),

                              Transform.scale(
                                scale: MediaQuery.of(context).size.width < 400 ? 0.8 : 1.0,
                                child: Switch(
                                  value: alarm.isEnabled,
                                  onChanged: (_) => provider.toggleEnabled(alarm.id),
                                  activeThumbColor: themeColor.onPrimary(context),
                                  activeTrackColor: color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
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
      builder: (_) => AddAlarmSheet(existing: alarm),
    );
  }
}

Widget buildRepeatDays({
  required List<bool> repeatDays,
  required Color activeColor,
  required Color inactiveColor,
}) {
  const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  final safeDays = repeatDays.length == 7
      ? repeatDays
      : List.filled(7, false);

  final noneSelected = !safeDays.contains(true);
  final allSelected = safeDays.every((d) => d);

  if (noneSelected) {
    return Text(
      'Once',
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: inactiveColor,
      ),
    );
  }

  if (allSelected) {
    return Text(
      'Everyday',
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: inactiveColor,
      ),
    );
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(7, (i) {
      final isActive = safeDays[i];

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Text(
          labels[i],
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive
                ? activeColor
                : inactiveColor,
          ),
        ),
      );
    }),
  );
}