import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:timer/widgets/circle_button.dart';
import '../models/timer_item.dart';
import '../providers/timer_provider.dart';
import 'color_utils.dart';
import 'add_timer_sheet.dart';

class TimerCard extends StatelessWidget {
  final TimerItem timer;
  const TimerCard({super.key, required this.timer});

  @override
  Widget build(BuildContext context) {
    final color = hexToColor(timer.color);
    final provider = context.read<TimerProvider>();
    final themeColor = context.watch<ThemeProvider>();

    return Dismissible(
      key: ValueKey(timer.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: themeColor.error(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          color: themeColor.onError(context),
        ),
      ),
      onDismissed: (_) => provider.removeTimer(timer.id),
      child: GestureDetector(
        onTap: () => _showEditSheet(context),
        child: Container(
          decoration: BoxDecoration(
            color: themeColor.secondary(context),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const SizedBox(width: 12),

                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            timer.formattedTime,
                            style: TextStyle(
                              color: timer.isFinished
                                  ? themeColor.error(context)
                                  : timer.isRunning
                                  ? color
                                  : themeColor.onSurface(context),
                              fontSize: 38,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 2,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              '/ ${timer.formattedTotal}',
                              style: TextStyle(
                                color: themeColor.onSurface(context),
                                fontSize: 12,
                              ),
                            ),
                          ),

                          const Spacer(),
                          const SizedBox(width: 10),

                          Row(
                            children: [
                              Text(
                                timer.name,
                                style: TextStyle(
                                  color: themeColor.onSurface(context),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(width: 40),
                              CircleBtn(
                                icon: timer.isRunning
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: color,
                                iconColor: themeColor.onSecondary(context),
                                onTap: () {
                                  if (timer.isRunning) {
                                    provider.pauseTimer(timer.id);
                                  } 
                                  else if (timer.isFinished) {
                                    provider.resetTimer(timer.id);
                                    provider.startTimer(timer.id);
                                  } 
                                  else {
                                    provider.startTimer(timer.id);
                                  }
                                }
                              ),
                              const SizedBox(width: 10),
                              CircleBtn(
                                icon: Icons.refresh_rounded,
                                color: themeColor.secondary(context),
                                iconColor: themeColor.onSurface(context),
                                onTap: () => provider.resetTimer(timer.id),
                                small: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
      builder: (_) => AddTimerSheet(existing: timer),
    );
  }
}

