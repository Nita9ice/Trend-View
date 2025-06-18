import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
final bool? enabled;
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      style: TextStyle(
        color:
            isDark
                ? Colors.white
                : const Color.fromRGBO(0, 0, 0, 1), // Black for light mode
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color:
              isDark
                  ? Colors.white70
                  : const Color.fromRGBO(0, 0, 0, 1), // Black for light mode
        ),
        filled: true,
        fillColor:
            isDark
                ? const Color.fromRGBO(30, 30, 30, 1)
                : const Color.fromRGBO(
                  211,
                  211,
                  211,
                  1,
                ), // Light grey for light mode
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
