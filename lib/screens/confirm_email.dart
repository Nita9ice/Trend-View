import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendveiw/components/buttton.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConfirmEmailScreen extends StatefulWidget {
  const ConfirmEmailScreen({super.key});

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
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
      // Email is verified, navigate to home
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email not verified yet. Please check your inbox.'),
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
        const SnackBar(
          content: Text('Verification email resent. Check your inbox.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to resend verification email: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              Text(
                'Verify Your Email',
                style: GoogleFonts.montserrat(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'A verification link has been sent to your email.\nPlease check your inbox and click the link.',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.white70,
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
                  style: GoogleFonts.montserrat(
                    color: Colors.pinkAccent,
                    fontWeight: FontWeight.w500,
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
