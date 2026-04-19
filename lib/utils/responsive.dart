import 'package:flutter/material.dart';

double responsiveSize(BuildContext context, double size) {
  final width = MediaQuery.of(context).size.width;
  return size * (width / 375);
}