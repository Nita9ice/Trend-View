import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trendveiw/components/buttton.dart';
import 'package:trendveiw/components/dialog_box.dart';
import 'package:trendveiw/components/text_field.dart';
import 'package:trendveiw/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool showPassword = false;

  bool validateInputs() {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty) {
      DialogBox.showErrorDialog(context, 'Please enter your email');
      return false;
    }
    if (!email.contains('@')) {
      DialogBox.showErrorDialog(context, 'Please enter a valid email address');
      return false;
    }
    if (password.isEmpty) {
      DialogBox.showErrorDialog(context, 'Please enter your password');
      return false;
    }
    if (password.length < 6) {
      DialogBox.showErrorDialog(
        context,
        'Password must be at least 6 characters',
      );
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  'Welcome Back',
                  style: GoogleFonts.montserrat(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.headlineLarge?.color,
                  ),
                ),
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
                        showPassword = !showPassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgot');
                    },
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.montserrat(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Login Button with validation and auth
                MyButton(
                  text: 'Login',
                  onPressed: () async {
                    if (validateInputs()) {
                      try {
                        final userCredential = await _authService.loginUser(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );

                        if (userCredential != null) {
                          if (userCredential.user?.emailVerified ?? false) {
                            Navigator.pushNamed(context, '/wrapper');
                            // Navigator.pushNamed(context, '/profile');
                          } else {
                            DialogBox.showInfoDialog(
                              context,
                              'Email Verification Required',
                              'Please verify your email before logging in.',
                            );
                          }
                        }
                      } on FirebaseAuthException catch (e) {
                        String errorMessage = 'Incorrect email or password';

                        if (e.code == 'user-not-found') {
                          errorMessage = 'No user found for that email.';
                        } else if (e.code == 'wrong-password') {
                          errorMessage = 'Incorrect password provided.';
                        } else if (e.code == 'invalid-email') {
                          errorMessage = 'The email address is not valid.';
                        }

                        DialogBox.showErrorDialog(context, errorMessage);
                      } catch (e) {
                        DialogBox.showErrorDialog(
                          context,
                          'An unexpected error occurred.',
                        );
                      }
                    }
                  },
                ),

                const SizedBox(height: 30),

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
