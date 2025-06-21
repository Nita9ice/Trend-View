import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendveiw/components/buttton.dart';
import 'package:trendveiw/components/dialog_box.dart';
import 'package:trendveiw/components/text_field.dart';
import 'package:trendveiw/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controller for handling input in the username text field
  final TextEditingController usernameController = TextEditingController();

  // Controller for handling input in the email text field
  final TextEditingController emailController = TextEditingController();

  // Controller for handling input in the password text field
  final TextEditingController passwordController = TextEditingController();

  // Toggles password visibility in the password field
  bool showPassword = false;

  // Tracks the loading state to show a progress indicator when needed.
  bool isLoading = false;

  // Validates that all input fields (username, email, password) are filled.
  // Shows an error dialog if any field is empty and returns false.
  // Returns true if all fields are valid.
  bool validateInputs() {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      DialogBox.showErrorDialog(context, 'Please fill in all fields');
      return false;
    }
    return true;
  }

  // Handles user sign-up process:
  // - Validates input fields
  // - Shows loading indicator
  // - Calls AuthService to register the user with email, password, and username
  Future<void> signUp() async {
    if (!validateInputs()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await AuthService().signupUser(
        emailController.text.trim(),
        passwordController.text,
        usernameController.text.trim(),
      );

      // Wait for dialog to close before navigation
      if (!mounted) return;
      await showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Success'),
              content: const Text('Account created! Please verify your email.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(), // Close dialog
                  child: const Text('OK'),
                ),
              ],
            ),
      );

      if (mounted) {
        Navigator.pushNamed(context, '/verify');
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Sign up failed';
      if (e.code == 'email-already-in-use') {
        message = 'Email is already in use.';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak.';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address.';
      }
      if (!mounted) return;
      DialogBox.showErrorDialog(context, message);
    } catch (e) {
      if (!mounted) return;
      DialogBox.showErrorDialog(context, 'An unexpected error occurred: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Get the current app theme (light or dark)
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Text(
                  'Create Account',
                  style: GoogleFonts.montserrat(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.headlineLarge?.color,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Join us and enjoy trending movies.',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 40),
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                ),
                const SizedBox(height: 20),
                MyTextField(controller: emailController, hintText: 'Email'),
                const SizedBox(height: 20),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: !showPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility_off : Icons.visibility,
                      color: theme.iconTheme.color?.withAlpha(140),
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 50),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : MyButton(text: 'Sign Up', onPressed: signUp),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: GoogleFonts.montserrat(
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login',
                        style: GoogleFonts.montserrat(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
