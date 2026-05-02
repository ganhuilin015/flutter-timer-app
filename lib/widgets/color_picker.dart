import 'package:flutter/material.dart';
import 'package:timer/widgets/color_utils.dart';

class ColorPicker extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  final List<String> colors;

  const ColorPicker({
    super.key,
    required this.selected,
    required this.onChanged,
    this.colors = const [],
  });

  @override
  Widget build(BuildContext context) {
    final palette = colors.isNotEmpty ? colors : kPaletteColors;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: palette.map((hex) {
        final color = hexToColor(hex);
        final isSelected = hex == selected;

        return GestureDetector(
          onTap: () => onChanged(hex),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: isSelected
                  ? Border.all(color: Colors.white, width: 3)
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withAlpha(150),
                        blurRadius: 8,
                      )
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
        );
      }).toList(),
    );
  }
}