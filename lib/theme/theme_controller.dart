import 'package:flutter/material.dart';

class ThemeController with ChangeNotifier {
  ThemeMode _themeMode =
      ThemeMode.dark; // default dark mode based on your theme

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Existing method to set theme explicitly
  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // New method to toggle theme without argument
  void toggleThemeMode() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
