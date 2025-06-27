import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendveiw/screens/welcome_screen.dart';

// Splash screen that shows app logo and title before navigating to WelcomeScreen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to welcome screen after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current app theme (light or dark)
    final theme = Theme.of(context);
    return Scaffold(
      // Set background color
      backgroundColor: theme.scaffoldBackgroundColor,

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App Icon (TV Icon styled as logo)
            Icon(Icons.live_tv_rounded, size: 150, color: theme.primaryColor),

            const SizedBox(height: 16), // Spacing between icon and text
            // App Title
            Text(
              'TrendView',
              style: GoogleFonts.montserrat(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.headlineLarge?.color,
              ),
            ),

            const SizedBox(height: 10), // Spacing between title and subtitle
            // Subtitle Text
            Text(
              'Discover what’s trending.',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
