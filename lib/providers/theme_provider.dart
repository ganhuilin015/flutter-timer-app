import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _boxName = 'settings';
  static const String _key = 'themeMode';

  Box get _box => Hive.box(_boxName);

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadFromHive();
  }

  void _loadFromHive() {
    final stored = _box.get(_key, defaultValue: 'system');

    switch (stored) {
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      default:
        _themeMode = ThemeMode.system;
    }
  }

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

    _saveToHive();
    notifyListeners();
  }

  void _saveToHive() {
    String value;

    switch (_themeMode) {
      case ThemeMode.dark:
        value = 'dark';
        break;
      case ThemeMode.light:
        value = 'light';
        break;
      default:
        value = 'system';
    }

    _box.put(_key, value);
  }
}