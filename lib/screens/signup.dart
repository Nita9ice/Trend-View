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

  // function to Validates user input for Username, email and password fields.
  bool validateInputs() {
    // Validates that all input fields (username, email, password) are filled.
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      // Shows an error dialog if any field is empty and returns false.
      DialogBox.showErrorDialog(context, 'Please fill in all fields');
      return false;
    }
    // Returns true if all fields are valid.
    return true;
  }

  // Handles user sign-up process:

  Future<void> signUp() async {
    // Validates input fields
    if (!validateInputs()) return;

    setState(() {
      // Shows loading indicator
      isLoading = true;
    });
    //   AuthService to register the user with username, email and password.
    try {
      await AuthService().signupUser(
        emailController.text.trim(),
        passwordController.text,
        usernameController.text.trim(),
      );

      // Close the dialog box before nagivation
      if (!mounted) return;
      await showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Success'),
              content: const Text('Account created! Please verify your email.'),
              actions: [
                TextButton(
                  // Closes the  dialog box
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
      );

      if (mounted) {
        // Navigate to verify screen after creating account
        Navigator.pushNamed(context, '/verify');
      }
    }
    // Handle specific Firebase authentication errors during sign up
    on FirebaseAuthException catch (e) {
      // Default error message
      String message = 'Sign up failed';

      if (e.code == 'email-already-in-use') {
        // This means the email is already associated with another account
        message = 'Email is already in use.';
      } else if (e.code == 'weak-password') {
        // This means the password provided is too short or not strong enough
        message = 'Password is too weak.';
      } else if (e.code == 'invalid-email') {
        // This means the email format is incorrect or not accepted by Firebase
        message = 'Invalid email address.';
      }
      // this mean if the widget is still part of the widget tree
      if (!mounted) return;
      // Show an error dialog with the final error message
      DialogBox.showErrorDialog(context, message);
    }
    // Catch any unexpected errors that are not FirebaseAuthExceptions
    catch (e) {
      if (!mounted) return;
      DialogBox.showErrorDialog(context, 'An unexpected error occurred: $e');
    } finally {
      if (mounted) {
        setState(() {
          // Stop the loading indicator
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
                // Main text
                Text(
                  'Create Account',
                  style: GoogleFonts.montserrat(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.headlineLarge?.color,
                  ),
                ),
                const SizedBox(height: 10),
                // sub text
                Text(
                  'Join us and enjoy trending movies.',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 40),
                // username field
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                ),
                const SizedBox(height: 20),
                // Email field
                MyTextField(controller: emailController, hintText: 'Email'),
                const SizedBox(height: 20),
                // password field
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
                        // Toggles password visibility in the input field
                        showPassword = !showPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 50),

                // Show circular progress indicator while signing up, otherwise show the 'Sign Up' button
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : MyButton(text: 'Sign Up', onPressed: signUp),

                const SizedBox(height: 10),

                // A horizontal row prompting users to log in if they already have an account
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
                        // Navigate back to the login screen.
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login',
                        style: GoogleFonts.montserrat(
                          color: Color.fromRGBO(184, 137, 250, 1),
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
