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

class _VerifyEmailScreenState extends State<VerifyEmailScreen>
    with WidgetsBindingObserver {
  // Tracks the loading state to show a progress indicator when needed.
  bool isLoading = false;

  // FirebaseAuth instance used for handling user authentication.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Function to  Check if the user's email has been verified:
  Future<void> checkEmailVerified() async {
    // Reloads the current user from Firebase
    setState(() {
      isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      await user?.reload();
      user = _auth.currentUser;

      // If verified, shows a success dialog and navigates to the wrapper screen
      if (user != null && user.emailVerified) {
        if (!mounted) return;
        DialogBox.showSuccessDialog(context, 'Email verified successfully!');
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          //  after successful verification take me to wrapper screen
          Navigator.pushReplacementNamed(context, '/wrapper');
        });
      }
      // If not verified, shows an error dialog  box prompting the user to verify email
      else {
        if (!mounted) return;
        DialogBox.showErrorDialog(
          context,
          'Email not verified yet. Please check your inbox and click the verification link.',
        );
      }
    }
    // Catch any unexpected errors that are not FirebaseAuthExceptions and updates the loading state
    catch (e) {
      DialogBox.showErrorDialog(context, 'Something went wrong: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  // resend verification function if email was not previously sent to user
  Future<void> resendVerificationEmail() async {
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

  // functino to confirm if user's email have been verified
  Future<void> confirmAndCheckEmail() async {
    DialogBox.showInfoDialog(
      context,
      'Confirm Verification',
      'Have you clicked the link in your email to verify your account?',
    );

    // After user closes the dialog, proceed to check
    Future.delayed(const Duration(milliseconds: 300), () {
      checkEmailVerified();
    });
  }

  @override
  void initState() {
    super.initState();
    // Start listening to app lifecycle, the help the app to retain its memory when the user open its gamil app
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Stop listening when screen is destroyed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // When user returns from Gmail or background, check if email is verified
      checkEmailVerified();
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

              // Main text
              Text(
                'Verify Your Email',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
              ),
              const SizedBox(height: 10),

              // sub text
              Text(
                'A verification link has been sent to your email.\nPlease check your inbox and click the link.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium!.color!.withAlpha(180),
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Show circular progress indicator while verifying email, otherwise show I have verified my email button
              isLoading
                  ? const CircularProgressIndicator()
                  : MyButton(
                    text: 'I have verified my email',
                    onPressed: confirmAndCheckEmail,
                  ),
              const SizedBox(height: 20),

              // button that resend email if previous email was not receive
              TextButton(
                onPressed: resendVerificationEmail,
                child: Text(
                  'Didn\'t receive the email? Resend',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.primaryColor,
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
