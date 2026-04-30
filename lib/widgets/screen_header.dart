import 'package:flutter/material.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> actions;

  const ScreenHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final color = context.watch<ThemeProvider>();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color.onSurface(context),
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: color.onSurface(context),
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          const SizedBox(width: 20),
          IconButton(
            icon: Icon(
              context.read<ThemeProvider>().isDark(context)
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              final provider = context.read<ThemeProvider>();
              final isDark = provider.isDark(context);
              provider.toggleTheme(!isDark);
            },
          ),
        ],
      ),
    );
  }
}
