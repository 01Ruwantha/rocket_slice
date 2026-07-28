import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _boxName = 'settings_box';
  late Box _box;
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void _loadTheme() {
    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box(_boxName);
      final isDark = _box.get('isDarkMode', defaultValue: true);
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    }
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box(_boxName);
      await _box.put('isDarkMode', isDarkMode);
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    if (Hive.isBoxOpen(_boxName)) {
      _box = Hive.box(_boxName);
      await _box.put('isDarkMode', isDarkMode);
    }
    notifyListeners();
  }
}
