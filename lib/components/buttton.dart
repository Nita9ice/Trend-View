import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// This class is created to make a reusable button keeep my code neat and clean
class MyButton extends StatelessWidget {
  // properties for this class
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsets padding;

  const MyButton({
    // initializing the properties
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color.fromRGBO(255, 64, 129, 1),
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
