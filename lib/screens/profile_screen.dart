import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trendveiw/components/util/edit_profile_button.dart';
import 'package:trendveiw/components/util/profile_options_tile.dart';

import 'package:trendveiw/theme/app_theme.dart';
import 'package:trendveiw/theme/theme_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _current64bytes;
  String? _username;
  String? _email;

  @override
  void initState() {
    super.initState();
    getBase64Image();
  }

  Future<Image?> getBase64Image() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()?.containsKey('profileImageUrl') == true) {
        final base64String = doc['profileImageUrl'] as String;

        setState(() {
          _current64bytes = base64String;
          _username = doc['username'] ?? user.displayName ?? ""; // ✅ FIXED
          _email = user.email ?? "";
        });
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDark = themeController.isDarkMode;

    final backgroundColor =
        isDark
            ? AppTheme.darkTheme.scaffoldBackgroundColor
            : AppTheme.lightTheme.scaffoldBackgroundColor;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final dividerColor = isDark ? Colors.white24 : Colors.black26;
    final iconColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: iconColor),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
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
              backgroundImage:
                  (_current64bytes != null
                          ? MemoryImage(base64Decode(_current64bytes ?? ""))
                          : const AssetImage('assets/default_avatar.png'))
                      as ImageProvider,
            ),
            const SizedBox(height: 10),

            Text(
              _username ?? 'Username',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _email ?? 'email@example.com',
              style: TextStyle(color: subTextColor, fontSize: 14),
            ),
            const SizedBox(height: 15),

            // Edit Profile Button
            EditProfileButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/edit');
                await getBase64Image(); // ✅ Refresh after edit
              },
            ),

            const SizedBox(height: 30),

            ProfileOptionTile(
              icon: Icons.favorite,
              label: 'Favourite',
              onTap: () {
                Navigator.pushNamed(context, '/favourite');
              },
            ),
            ProfileOptionTile(
              icon: Icons.watch_later_outlined,
              label: 'Watch Later',
              onTap: () {},
            ),
            ProfileOptionTile(
              icon: Icons.download,
              label: 'Downloads',
              onTap: () {},
            ),
            Divider(color: dividerColor),
            ProfileOptionTile(
              icon: Icons.display_settings,
              label: 'Display',
              onTap: () {},
            ),
            ProfileOptionTile(
              icon: Icons.subscriptions,
              label: 'Subscription',
              onTap: () {},
            ),
            Divider(color: dividerColor),
            ProfileOptionTile(
              icon: Icons.cached,
              label: 'Clear Cache',
              onTap: () {},
            ),
            ProfileOptionTile(
              icon: Icons.history,
              label: 'Clear History',
              onTap: () {},
            ),
            const SizedBox(height: 10),
            Divider(color: dividerColor),

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
