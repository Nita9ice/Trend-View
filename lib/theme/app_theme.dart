import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: const Color.fromRGBO(255, 64, 129, 1),
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
    iconTheme: const IconThemeData(color: Colors.black),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    hintColor: const Color.fromRGBO(18, 18, 18, 1),
    // theme for text field
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Color.fromRGBO(211, 211, 211, 1),
    ),
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

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color.fromRGBO(18, 18, 18, 1),
    primaryColor: const Color.fromRGBO(255, 64, 129, 1),
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
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),

    hintColor: Colors.white70,
    // theme for text field
    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color.fromRGBO(30, 30, 30, 1),
    ),
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
