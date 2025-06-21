import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendveiw/components/buttton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trendveiw/components/dialog_box.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  // Tracks the loading state to show a progress indicator when needed.
  bool isLoading = false;

  // FirebaseAuth instance used for handling user authentication.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // function to verify user
  Future<void> _checkEmailVerified() async {
    setState(() {
      isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      await user?.reload();
      user = _auth.currentUser;

      if (user != null && user.emailVerified) {
        if (!mounted) return;
        DialogBox.showSuccessDialog(context, 'Email verified successfully!');
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          //  after successful verification take me to home screen
          Navigator.pushReplacementNamed(context, '/home');
        });
      } else {
        if (!mounted) return;
        DialogBox.showErrorDialog(
          context,
          'Email not verified yet. Please check your inbox and click the verification link.',
        );
      }
    } catch (e) {
      DialogBox.showErrorDialog(context, 'Something went wrong: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  // resend verification function if email was not previously sent to user
  Future<void> _resendVerificationEmail() async {
    try {
      User? user = _auth.currentUser;
      await user?.sendEmailVerification();

      if (!mounted) return;
      DialogBox.showSuccessDialog(
        context,
        'Verification email resent. Please check your inbox.',
      );
    } catch (e) {
      DialogBox.showErrorDialog(context, 'Failed to resend email: $e');
    }
  }

  Future<void> _confirmAndCheckEmail() async {
    DialogBox.showInfoDialog(
      context,
      'Confirm Verification',
      'Have you clicked the link in your email to verify your account?',
    );

    // After user closes the dialog, proceed to check
    Future.delayed(const Duration(milliseconds: 300), () {
      _checkEmailVerified();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Text(
                'Verify Your Email',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'A verification link has been sent to your email.\nPlease check your inbox and click the link.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium!.color!.withAlpha(180),
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              isLoading
                  ? const CircularProgressIndicator()
                  : MyButton(
                    text: 'I have verified my email',
                    onPressed: _confirmAndCheckEmail,
                  ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _resendVerificationEmail,
                child: Text(
                  'Didn\'t receive the email? Resend',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(255, 64, 129, 1),
                    fontFamily: GoogleFonts.montserrat().fontFamily,
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
