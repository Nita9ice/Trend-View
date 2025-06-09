import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trendveiw/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to HomeScreen after 2 seconds
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
    return Scaffold(
      // Set background color
      backgroundColor: const Color.fromRGBO(18, 18, 18, 1),

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App Icon (TV Icon styled as logo)
            const Icon(
              Icons.live_tv_rounded,
              size: 150,
              color: Color.fromRGBO(255, 64, 129, 1),
            ),

            const SizedBox(height: 16), // Spacing between icon and text
            // App Title
            Text(
              'TrendView',
              style: GoogleFonts.montserrat(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(255, 255, 255, 1),
                // letterSpacing: 2.5,
              ),
            ),

            const SizedBox(height: 10), // Spacing between title and subtitle
            // Subtitle Text
            Text(
              'Discover what’s trending.',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: const Color.fromRGBO(255, 255, 255, 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
