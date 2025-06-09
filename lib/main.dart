import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trendveiw/screens/confirm_email.dart';
import 'package:trendveiw/screens/forgot_password.dart';
import 'package:trendveiw/screens/home_page.dart';
import 'package:trendveiw/screens/login_screen.dart';
import 'package:trendveiw/screens/profile_screen.dart';

import 'package:trendveiw/screens/signup.dart';
import 'package:trendveiw/screens/welcome_screen.dart';
import 'package:trendveiw/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TrendVeiw());
}

class TrendVeiw extends StatelessWidget {
  const TrendVeiw({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash', // starting screen
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/forgot': (context) => const ForgotPasswordScreen(),
        /* '/home': (context) => HomeScreen(), */
        '/home': (context) => HomePage(),
        '/signup': (context) => const SignUpScreen(),
        '/confirm': (context) => const ConfirmEmailScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color.fromRGBO(18, 18, 18, 1),
      ),
    );
  }
}
