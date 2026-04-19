import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool isDark(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

ColorScheme scheme(BuildContext context) =>
    isDark(context) ? AppTheme.dark.colorScheme : AppTheme.light.colorScheme;

  Color primary(BuildContext context) => scheme(context).primary;
  Color onPrimary(BuildContext context) => scheme(context).onPrimary;
  Color secondary(BuildContext context) => scheme(context).secondary;
  Color onSecondary(BuildContext context) => scheme(context).onSecondary;
  Color surface(BuildContext context) => scheme(context).surface;
  Color onSurface(BuildContext context) => scheme(context).onSurface;
  Color background(BuildContext context) => scheme(context).surface;
  Color error(BuildContext context) => scheme(context).error;
  Color onError(BuildContext context) => scheme(context).onError;
  Color surfaceContainer(BuildContext context) =>
      scheme(context).surfaceContainer;
  Color outline(BuildContext context) => scheme(context).outline;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
