import 'package:flutter/material.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class TopMessageCard extends StatelessWidget {
  final String message;

  const TopMessageCard({required this.message});

  @override
  Widget build(BuildContext context) {
    final color = context.read<ThemeProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.error(context),
        borderRadius: BorderRadius.circular(12),
        
      ),
      child: Text(
        message,
        style: TextStyle(color: color.onError(context)),
      ),
    );
  }
}