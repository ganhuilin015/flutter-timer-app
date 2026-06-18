import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:timer/models/world_clock_entry.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:timer/providers/world_clock_provider.dart';

class WorldClockCard extends StatelessWidget {
  final WorldClock clock;

  const WorldClockCard({
    super.key,
    required this.clock,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WorldClockProvider>();

    final now = clock.currentTime;
    final time = DateFormat('HH:mm').format(now);
    final date = DateFormat('EEE, MMM d').format(now);

    final utcOffset = now.timeZoneOffset.inHours;
    final utcLabel = utcOffset >= 0
        ? 'UTC+$utcOffset'
        : 'UTC$utcOffset';
        
    final themeColor = context.watch<ThemeProvider>();

    return Dismissible(
      key: ValueKey(clock.id),
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
      onDismissed: (_) => provider.removeClock(clock.id),

      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeColor.secondary(context),
          borderRadius: BorderRadius.circular(16),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clock.cityName,
                  style: TextStyle(
                    color: themeColor.onSurface(context),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  clock.countryName,
                  style: TextStyle(
                    color: themeColor.onSurface(context),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 6),

                Row (
                  children: [
                    Text(
                      utcLabel,
                      style: TextStyle(
                        color: themeColor.onSurface(context).withAlpha(150),
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      date,
                      style: TextStyle(
                        color: themeColor.onSurface(context).withAlpha(150),
                        fontSize: 11,
                      ),
                    ),
                  ],
                )
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: themeColor.onSurface(context),
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}