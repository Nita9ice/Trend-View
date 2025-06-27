import 'package:flutter/material.dart';

// This class is created to build reusable and consistent input field styles across the app.
class CustomInputDecoration {
  static InputDecoration build({required String label, Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color.fromRGBO(30, 30, 30, 1),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
