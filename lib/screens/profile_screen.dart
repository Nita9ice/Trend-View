import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:trendveiw/components/Widget/edit_profile_button.dart';
import 'package:trendveiw/components/profile_options_tile.dart';
import 'package:trendveiw/theme/theme_controller.dart';
import 'package:trendveiw/theme/app_theme.dart'; // Import your AppTheme

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDark = themeController.isDarkMode;

    // Use colors from AppTheme depending on theme mode
    final backgroundColor =
        isDark
            ? AppTheme.darkTheme.scaffoldBackgroundColor
            : AppTheme.lightTheme.scaffoldBackgroundColor;
    // final primaryColor = AppTheme.primaryColor;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final dividerColor = isDark ? Colors.white24 : Colors.black26;
    final iconColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: iconColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: iconColor),
            onPressed: () {},
          ),
        ],
        title: Text('Profile', style: TextStyle(color: textColor)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Picture & Info
            CircleAvatar(
              radius: 50,
              backgroundColor:
                  isDark ? Colors.grey.shade800 : Colors.grey.shade300,
              child: Icon(Icons.person, size: 60, color: subTextColor),
            ),
            const SizedBox(height: 10),

            Text(
              'Username Placeholder',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'email@example.com',
              style: TextStyle(color: subTextColor, fontSize: 14),
            ),
            const SizedBox(height: 15),

            // Edit Profile Button
            EditProfileButton(
              onPressed: () {
                Navigator.pushNamed(context, '/edit');
              },
            ),

            const SizedBox(height: 30),

            // List Options
            ProfileOptionTile(
              icon: Icons.favorite,
              label: "Favourite",
              onTap: () {
                // take me to favourite screen
                Navigator.pushNamed(context, '/favourite');
              },
            ),
            ProfileOptionTile(
              icon: Icons.watch_later_outlined,
              label: "Watch Later",
              onTap: () {},
            ),
            ProfileOptionTile(
              icon: Icons.download,
              label: "Downloads",
              onTap: () {},
            ),
            Divider(color: dividerColor),
            ProfileOptionTile(
              icon: Icons.language,
              label: "Languages",
              onTap: () {},
            ),
            ProfileOptionTile(
              icon: Icons.display_settings,
              label: "Display",
              onTap: () {},
            ),
            ProfileOptionTile(
              icon: Icons.subscriptions,
              label: "Subscription",
              onTap: () {},
            ),
            Divider(color: dividerColor),
            ProfileOptionTile(
              icon: Icons.cached,
              label: "Clear Cache",
              onTap: () {},
            ),
            ProfileOptionTile(
              icon: Icons.history,
              label: "Clear History",
              onTap: () {},
            ),

            // Theme Toggle
            SwitchListTile(
              secondary: Icon(Icons.brightness_6, color: iconColor),
              title: Text("Dark Mode", style: TextStyle(color: textColor)),
              value: isDark,
              onChanged: (val) => themeController.toggleTheme(val),
            ),

            const SizedBox(height: 10),
            Divider(color: dividerColor),

            // Logout
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Logout failed: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
