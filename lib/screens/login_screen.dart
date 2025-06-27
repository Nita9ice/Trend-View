import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trendveiw/components/util/buttton.dart';
import 'package:trendveiw/components/util/dialog_box.dart';
import 'package:trendveiw/components/util/text_field.dart';
import 'package:trendveiw/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Instance of AuthService to handle user authentication logic
  final AuthService _authService = AuthService();

  // Controller for handling input in the email text field
  final TextEditingController emailController = TextEditingController();

  // Controller for handling input in the password text field
  final TextEditingController passwordController = TextEditingController();

  // Toggles password visibility in the password field
  bool showPassword = false;

  // function to Validates user input for email and password fields.
  bool validateInputs() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Check if the email field is empty
    if (email.isEmpty) {
      DialogBox.showErrorDialog(context, 'Please enter your email');
      return false;
    }
    // Check if the email format is not valid
    if (!email.contains('@')) {
      DialogBox.showErrorDialog(context, 'Please enter a valid email address');
      return false;
    }
    // Check if the password field is empty
    if (password.isEmpty) {
      DialogBox.showErrorDialog(context, 'Please enter your password');
      return false;
    }
    // Check if the password is too short
    if (password.length < 6) {
      DialogBox.showErrorDialog(
        context,
        'Password must be at least 6 characters',
      );
      // Returns true if all inputs are valid; otherwise, returns false.
      return false;
    }

    return true;
  }

  // Handles user login:

  Future<void> handleLogin() async {
    //  Validates input fields
    if (validateInputs()) {
      //  Attempts to login with Firebase Auth
      try {
        final userCredential = await _authService.loginUser(
          emailController.text.trim(),
          passwordController.text,
        );
        //  Checks if the user's email is verified
        if (userCredential != null) {
          if (userCredential.user?.emailVerified ?? false) {
            if (mounted) {
              //  Navigates to the wrapper screen if verified
              Navigator.pushNamed(context, '/wrapper');
            }
          } else {
            if (mounted) {
              DialogBox.showInfoDialog(
                context,
                'Email Verification Required',
                'Please verify your email before logging in.',
              );
            }
          }
        }
      }
      //  Shows error if user credentials is invalid
      on FirebaseAuthException catch (e) {
        String errorMessage = '';

        if (e.code == 'invalid-credential') {
          errorMessage = 'Email or password is incorrect.';
        }

        if (mounted) {
          DialogBox.showErrorDialog(context, errorMessage);
        }
      } catch (e) {
        if (mounted) {
          DialogBox.showErrorDialog(context, 'An unexpected error occurred.');
        }
      }
    }
  }

  @override
  // Clean up the controllers when the widget is removed
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme data from the context.
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
                  'Welcome Back',
                  style: GoogleFonts.montserrat(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.headlineLarge?.color,
                  ),
                ),
                // sub text
                const SizedBox(height: 10),
                Text(
                  'Login to your account',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 40),

                // Email Field
                MyTextField(controller: emailController, hintText: 'Email'),

                const SizedBox(height: 20),

                // Password Field
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

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigate to forgot password screen
                      Navigator.pushNamed(context, '/forgot');
                    },
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.montserrat(
                        color: Color.fromRGBO(184, 137, 250, 1),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // Login Button with validation and auth
                MyButton(text: 'Login', onPressed: handleLogin),

                const SizedBox(height: 10),

                // Create account text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: GoogleFonts.montserrat(
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                        'Create one',
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
