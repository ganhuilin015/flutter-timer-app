import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:timer/widgets/circle_button.dart';
import '../models/stopwatch_entry.dart';
import '../providers/stopwatch_provider.dart';
import 'color_utils.dart';

class StopwatchCard extends StatefulWidget {
  final StopwatchEntry entry;
  const StopwatchCard({super.key, required this.entry});

  @override
  State<StopwatchCard> createState() => _StopwatchCardState();
}

class _StopwatchCardState extends State<StopwatchCard> {
  bool _showLaps = false;

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final color = hexToColor(entry.color);
    final provider = context.read<StopwatchProvider>();
    final themeColor = context.watch<ThemeProvider>();

    return Dismissible(
      key: ValueKey(entry.id),
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
      onDismissed: (_) => provider.removeStopwatch(entry.id),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10, 
        ),
        decoration: BoxDecoration(
          color: themeColor.secondary(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry.name.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 16),
              child: Text(
                entry.name,
                style: TextStyle(
                  color: themeColor.onSurface(context),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          entry.formattedTime,
                          style: TextStyle(
                            color: entry.isRunning
                                ? color
                                : themeColor.onSurface(context),
                            fontSize: 34,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 2,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),

                        const Spacer(),
                        const SizedBox(width: 5),

                        Row(
                          children: [
                            if (entry.isRunning) ...[
                              CircleBtn(
                                icon: Icons.flag_outlined,
                                color: color,
                                iconColor: themeColor.onPrimary(context),
                                onTap: () => provider.addLap(entry.id),
                                tooltip: 'Lap',
                              ),
                            ],

                            const SizedBox(width: 5),
                            CircleBtn(
                              icon: entry.isRunning
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: color,
                              iconColor: themeColor.onPrimary(context),
                              onTap: () {
                                if (entry.isRunning) {
                                  provider.pause(entry.id);
                                } else {
                                  provider.start(entry.id);
                                }
                              },
                            ),
                            const SizedBox(width: 5),
                            CircleBtn(
                              icon: Icons.refresh_rounded,
                              color: themeColor.secondary(context),
                              iconColor: themeColor.onSurface(context),
                              onTap: () => provider.reset(entry.id),
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

            if (entry.laps.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16),
              child: GestureDetector(
                onTap: () => setState(() => _showLaps = !_showLaps),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: color),
                  ),
                  child: Text(
                    '${entry.laps.length} lap${entry.laps.length == 1 ? '' : 's'}',
                    style: TextStyle(
                      color: themeColor.onPrimary(context),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Laps section
            if (_showLaps && entry.laps.isNotEmpty) ...[

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                color: themeColor.surface(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        'Lap',
                        style: TextStyle(
                          color: themeColor
                              .onSurface(context)
                              .withAlpha(150),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 80,
                      child: Text(
                        'Lap Time',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeColor
                              .onSurface(context)
                              .withAlpha(150),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 80,
                      child: Text(
                        'Total',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: themeColor
                              .onSurface(context).withAlpha(150),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                color: themeColor.surface(context),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 300,
                        height: 1,
                        color: themeColor.onSurface(context).withAlpha(100),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                color: themeColor.surface(context),
                child: ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: entry.laps.length,
                  itemBuilder: (context, i) {
                    final lap = entry.laps[entry.laps.length - 1 - i];
                    final isFastest =
                        entry.laps.isNotEmpty &&
                        lap.lapMilliseconds ==
                            entry.laps
                                .map((l) => l.lapMilliseconds)
                                .reduce((a, b) => a < b ? a : b);
                    final isSlowest =
                        entry.laps.length > 1 &&
                        lap.lapMilliseconds ==
                            entry.laps
                                .map((l) => l.lapMilliseconds)
                                .reduce((a, b) => a > b ? a : b);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 50,
                            child: Text(
                              lap.lapNumber.toString(),
                              style: TextStyle(
                                color: themeColor.onSurface(context),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 80,
                            child: Text(
                              lap.formattedLap,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isFastest && entry.laps.length > 1
                                    ? Colors.green
                                    : isSlowest
                                        ? themeColor.error(context)
                                        : themeColor.onSurface(context),
                                fontSize: 13,
                                fontFeatures: const [FontFeature.tabularFigures()],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 80,
                            child: Text(
                              lap.formattedTotal,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: themeColor.onSurface(context),
                                fontSize: 12,
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
