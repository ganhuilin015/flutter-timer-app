import 'package:flutter/material.dart';

Color hexToColor(String hex) {
  final h = hex.replaceAll('#', '');
  if (h.length == 6) {
    return Color(int.parse('FF$h', radix: 16));
  } else if (h.length == 8) {
    return Color(int.parse(h, radix: 16));
  }
  return const Color(0xFF00E5CC);
}

const List<String> kPaletteColors = [
  '#00E5CC',
  '#7C5CFC',
  '#FF6B6B',
  '#FFB347',
  '#00D68F',
  '#4FC3F7',
  '#F06292',
  '#AED581',
  '#FF8A65',
  '#BA68C8',
];