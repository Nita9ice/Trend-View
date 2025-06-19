import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  bool isLoadingGoogleSignIn = false; // Track Google Sign-In loading state

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

  Future<void> _signInWithGoogle() async {
    setState(() {
      isLoadingGoogleSignIn = true;
    });

    try {
      // Trigger the Google Sign In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() {
          isLoadingGoogleSignIn = false;
        });
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _authService.signInWithGoogle(credential);

      if (userCredential != null) {
        if (userCredential.user?.emailVerified ?? false) {
          if (mounted) {
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
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        DialogBox.showErrorDialog(
          context,
          'Google Sign-In failed: ${e.message}',
        );
      }
    } catch (e) {
      if (mounted) {
        DialogBox.showErrorDialog(
          context,
          'Google Sign-In failed. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoadingGoogleSignIn = false;
        });
      }
    }
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
                            if (mounted) {
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
                      } on FirebaseAuthException catch (e) {
                        String errorMessage = 'Incorrect email or password';

                        if (e.code == 'user-not-found') {
                          errorMessage = 'No user found for that email.';
                        } else if (e.code == 'wrong-password') {
                          errorMessage = 'Incorrect password provided.';
                        } else if (e.code == 'invalid-email') {
                          errorMessage = 'The email address is not valid.';
                        }

                        if (mounted) {
                          DialogBox.showErrorDialog(context, errorMessage);
                        }
                      } catch (e) {
                        if (mounted) {
                          DialogBox.showErrorDialog(
                            context,
                            'An unexpected error occurred.',
                          );
                        }
                      }
                    }
                  },
                ),

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
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Center(child: Text("OR")),

                const SizedBox(height: 30),
                // Sign in with Google
                Center(
                  child: ElevatedButton(
                    onPressed: isLoadingGoogleSignIn ? null : _signInWithGoogle,
                    style: ElevatedButton.styleFrom(minimumSize: Size(200, 50)),
                    child:
                        isLoadingGoogleSignIn
                            ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.onPrimary,
                                ),
                              ),
                            )
                            : Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'images/google_logo.png',
                                  height: 24,
                                ),
                                SizedBox(width: 12),
                                Text('Sign in with Google'),
                              ],
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
