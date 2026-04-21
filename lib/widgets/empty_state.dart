import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/providers/theme_provider.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  final String title;
  final String subtitle;
  final String buttonText;
  final IconData icon;

  const EmptyState({
    super.key,
    required this.onAdd,
    this.title = 'No items yet',
    this.subtitle = 'Add something to get started.',
    this.buttonText = 'Add',
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.watch<ThemeProvider>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.primary(context),
            ),
            child: Icon(
              icon,
              color: color.onPrimary(context),
              size: 36,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              color: color.onSurface(context),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color.onSurface(context),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: Text(buttonText),
            style: ElevatedButton.styleFrom(
              backgroundColor: color.primary(context).withAlpha(180),
              foregroundColor: color.onPrimary(context),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}