import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// this is a class for edit profile button
class EditProfileButton extends StatelessWidget {
  // property of the class
  final VoidCallback onPressed;

  // initializing the property
  const EditProfileButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(255, 64, 129, 1), // Button color
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: onPressed,
      child: Text(
        'Edit Profile',
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
