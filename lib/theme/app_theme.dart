import 'package:flutter/material.dart';

// This class defines both light and dark themes used across the app.
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    // Light mode
    brightness: Brightness.light,
    // Main background color
    scaffoldBackgroundColor: Colors.white,
    // App's main accent color
    primaryColor: const Color.fromRGBO(255, 64, 129, 1),
    // AppBar styling
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Color.fromRGBO(18, 18, 18, 1)),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      elevation: 0,
    ),
    // General icon color
    iconTheme: const IconThemeData(color: Colors.black),
    // Text styles
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    // Hint text color
    hintColor: const Color.fromRGBO(18, 18, 18, 1),
    // theme for text field
    inputDecorationTheme: InputDecorationTheme(
      // Input field background color
      fillColor: Color.fromRGBO(211, 211, 211, 1),
    ),
    // Custom switch styling (toggle switch)
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color.fromRGBO(255, 64, 129, 1);
        }
        return Colors.grey;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color.fromRGBO(255, 64, 129, 0.5);
        }
        return Colors.grey.shade400;
      }),
    ),
  );

  // Dark theme settings
  static ThemeData darkTheme = ThemeData(
    // Dark mode
    brightness: Brightness.dark,
    // Dark background
    scaffoldBackgroundColor: const Color.fromRGBO(18, 18, 18, 1),
    // App's accent color
    primaryColor: const Color.fromRGBO(255, 64, 129, 1),
    // AppBar styling
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      iconTheme: IconThemeData(color: Color.fromRGBO(255, 255, 255, 1)),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      elevation: 0,
    ),
    // General icon color
    iconTheme: const IconThemeData(color: Colors.white),
    // Text styles
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    // Hint text color
    hintColor: Colors.white70,
    // Input field background color
    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color.fromRGBO(30, 30, 30, 1),
    ),
    // Switch styling
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color.fromRGBO(255, 64, 129, 1);
        }
        return Colors.grey;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color.fromRGBO(255, 64, 129, 0.5);
        }
        return Colors.grey.shade700;
      }),
    ),
  );
}
