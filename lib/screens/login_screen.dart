import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendveiw/components/buttton.dart';
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

  // Simple input validation
  bool validateInputs() {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty) {
      showSnackBar('Please enter your email');
      return false;
    }
    if (!email.contains('@')) {
      showSnackBar('Please enter a valid email address');
      return false;
    }
    if (password.isEmpty) {
      showSnackBar('Please enter your password');
      return false;
    }
    if (password.length < 6) {
      showSnackBar('Password must be at least 6 characters');
      return false;
    }
    return true;
  }

  // Helper to show messages
  void showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
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
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Login to your account',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.white70,
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
                      color: Colors.white54,
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
                      style: GoogleFonts.montserrat(color: Colors.pinkAccent),
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
                          emailController.text,
                          passwordController.text,
                        );

                        if (userCredential != null) {
                          if (userCredential.user?.emailVerified ?? false) {
                            // Navigator.pushNamed(context, '/home');

                            Navigator.pushNamed(context, '/profile');
                          } else {
                            showSnackBar(
                              'Please verify your email before logging in.',
                            );
                          }
                        }
                      } catch (e) {
                        showSnackBar('Login failed: ${e.toString()}');
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
                      style: GoogleFonts.montserrat(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                        'Create one',
                        style: GoogleFonts.montserrat(
                          color: Colors.pinkAccent,
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
