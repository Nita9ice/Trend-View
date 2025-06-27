import 'package:flutter/material.dart';

// This class manages the app's theme (light or dark mode)
// and notifies listeners when the theme changes.
class ThemeController with ChangeNotifier {
  ThemeMode _themeMode =
      ThemeMode.dark; // default dark mode based on your theme

  // Getter to access the current theme mode
  ThemeMode get themeMode => _themeMode;

  // Check if the current theme is dark mode
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
