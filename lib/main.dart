import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:trendveiw/screens/confirm_email.dart';
import 'package:trendveiw/screens/edit_profile_screen.dart';
import 'package:trendveiw/screens/forgot_password.dart';
import 'package:trendveiw/screens/home_screen.dart';
import 'package:trendveiw/screens/login_screen.dart';
import 'package:trendveiw/screens/profile_screen.dart';
import 'package:trendveiw/screens/signup.dart';
import 'package:trendveiw/screens/welcome_screen.dart';
import 'package:trendveiw/splash_screen.dart';
import 'package:trendveiw/theme/theme_controller.dart';
import 'package:trendveiw/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: const TrendVeiw(),
    ),
  );
}

class TrendVeiw extends StatelessWidget {
  const TrendVeiw({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/forgot': (context) => const ForgotPasswordScreen(),
        '/home': (context) => HomeScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/confirm': (context) => const ConfirmEmailScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit': (context) => const EditProfileScreen(),
      },
      themeMode: themeController.themeMode,
      // Use the light theme from AppTheme class
      theme: AppTheme.lightTheme,
      // Use the dark theme from AppTheme class
      darkTheme: AppTheme.darkTheme,
    );
  }
}
