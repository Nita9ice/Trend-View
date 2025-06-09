import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendveiw/components/buttton.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _checkEmailVerified() async {
    setState(() {
      isLoading = true;
    });

    User? user = _auth.currentUser;
    await user?.reload();
    user = _auth.currentUser;

    if (user != null && user.emailVerified) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Email not verified yet. Please check your inbox.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          backgroundColor:
              Theme.of(context).snackBarTheme.backgroundColor ??
              Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _resendVerificationEmail() async {
    try {
      User? user = _auth.currentUser;
      await user?.sendEmailVerification();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Verification email resent. Check your inbox.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          backgroundColor:
              Theme.of(context).snackBarTheme.backgroundColor ??
              Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to resend verification email: $e',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }
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
                  color: theme.textTheme.bodyMedium!.color!.withAlpha(
                    (0.7 * 255).round(),
                  ),

                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              isLoading
                  ? const CircularProgressIndicator()
                  : MyButton(
                    text: 'I have verified my email',
                    onPressed: _checkEmailVerified,
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
