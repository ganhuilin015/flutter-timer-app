import 'package:flutter/material.dart';

class CircleBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;
  final bool small;
  final String? tooltip;

  const CircleBtn({
    super.key,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
    this.small = false,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final size = small ? 32.0 : 50.0;
    final iconSize = small ? 18.0 : 30.0;

    final btn = GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Icon(icon, color: iconColor, size: iconSize),
      ),
    );

    if (tooltip != null) return Tooltip(message: tooltip!, child: btn);
    return btn;
  }
}
