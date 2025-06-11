import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:trendveiw/components/util/wrapper_page.dart';
import 'package:trendveiw/screens/favourite_screen.dart';
import 'package:trendveiw/screens/settings.dart';
import 'package:trendveiw/screens/verify_email.dart';
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

   // Check if user is signed in
  User? user = FirebaseAuth.instance.currentUser;
  String initialRoute = user == null ? '/splash' : '/wrapper';

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child:  TrendVeiw(initialRoute: initialRoute),
    ),
  );
}

class TrendVeiw extends StatelessWidget {
final String initialRoute;

  const TrendVeiw({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/wrapper': (context) => const Wrapper(),
        '/splash': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/forgot': (context) => const ForgotPasswordScreen(),
        '/home': (context) => HomeScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/verify': (context) => const VerifyEmailScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit': (context) => const EditProfileScreen(),
        '/favourite': (context) => FavouriteScreen(),
        '/settings': (context) => SettingsScreen(),
      },
      themeMode: themeController.themeMode,
      // Use the light theme from AppTheme class
      theme: AppTheme.lightTheme,
      // Use the dark theme from AppTheme class
      darkTheme: AppTheme.darkTheme,
    );
  }
}
