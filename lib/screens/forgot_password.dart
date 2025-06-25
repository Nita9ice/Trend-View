import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendveiw/components/buttton.dart';
import 'package:trendveiw/components/dialog_box.dart';
import 'package:trendveiw/components/text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Controller for handling input in the email text field
  final TextEditingController emailController = TextEditingController();

  // function to reset password
  Future<void> sendPasswordResetLink() async {
    final email = emailController.text.trim();

    // Check if the email field is empty
    if (email.isEmpty) {
      DialogBox.showInfoDialog(
        context,
        'Input Required',
        'Please enter your email.',
      );
      return;
    }

    try {
      // Attempt to send a password reset email using the provided email address
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      // Show a success dialog informing the user that the reset link was sent
      DialogBox.showSuccessDialog(
        context,
        'Password reset link sent! Please check your email.',
      );
    } catch (e) {
      if (!mounted) return;
      // Catch any unexpected errors that are not FirebaseAuthExceptions
      DialogBox.showErrorDialog(
        context,
        'Something went wrong. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current app theme (light or dark)
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              // Main text
              Text(
                'Forgot Password',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
              const SizedBox(height: 10),
              // sub text
              Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium!.color!.withAlpha(
                    (0.7 * 255).round(),
                  ),

                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),

              const SizedBox(height: 40),

              // Email field
              MyTextField(controller: emailController, hintText: 'Email'),

              const SizedBox(height: 30),

              // Send Reset Link button
              MyButton(
                text: 'Send Reset Link',
                onPressed: sendPasswordResetLink,
              ),

              const SizedBox(height: 20),

              // Back to login
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Back to Login',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.pinkAccent,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
