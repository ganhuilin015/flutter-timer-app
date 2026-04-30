import 'package:flutter/material.dart';
import 'package:timer/widgets/top_message_card.dart';

void showTopMessage(BuildContext context, String message) {
  final overlay = Overlay.of(context);

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.up,
          onDismissed: (_) => entry.remove(),
          child: TopMessageCard(message: message),
        ),
      ),
    ),
  );

  overlay.insert(entry);

  // Auto remove after 3 seconds
  Future.delayed(const Duration(seconds: 3), () {
    if (entry.mounted) {
      entry.remove();
    }
  });
}