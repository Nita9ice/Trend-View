import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trendveiw/components/util/dialog_box.dart';
import 'package:trendveiw/components/util/edit_profile_button.dart';
import 'package:trendveiw/components/util/profile_options_tile.dart';
import 'package:trendveiw/theme/theme_controller.dart';

// ProfileScreen displays user information and profile-related actions
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Initialize Firebase Firestore instance for accessing the Firestore database
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Initialize FirebaseAuth instance for handling user authentication
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Stores base64 string of the profile image
  String? current64bytes;

  // Stores username
  String? username;

  // Stores email
  String? email;

  // Load user image and details on screen init
  @override
  void initState() {
    super.initState();
    getBase64Image();
  }

  // Fetch user image and details from Firestore
  Future<Image?> getBase64Image() async {
    final user = auth.currentUser;
    if (user != null) {
      final doc = await firestore.collection('users').doc(user.uid).get();

      // Check if profile image URL exists in Firestore document
      if (doc.exists && doc.data()?.containsKey('profileImageUrl') == true) {
        final base64String = doc['profileImageUrl'] as String? ?? '';

        // Update state with image and user info
        setState(() {
          current64bytes = base64String;
          username =
              doc['username'] ??
              user.displayName ??
              ""; // fallback to Firebase name if not set
          email = user.email ?? "";
        });
      }
    }
    return null;
  }

  // Handles logout functionality
  void logoutFunction(BuildContext context) async {
    try {
      // Sign user out
      await FirebaseAuth.instance.signOut();

      // Navigate to login screen and clear navigation stack
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      // Show error dialog if logout fails
      // ignore: use_build_context_synchronously
      DialogBox.showErrorDialog(context, 'Logout failed: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the ThemeController instance using Provider to access theme-related settings
    final themeController = Provider.of<ThemeController>(context);

    // Determine if the current theme is dark mode
    final isDark = themeController.isDarkMode;

    // Set text color based on the theme mode
    final textColor = isDark ? Colors.white : Colors.black;

    // Set subtext color based on the theme mode
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    // Get current theme context
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        // Profile title
        title: Text(
          'Profile',
          style: GoogleFonts.montserrat(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.headlineLarge?.color,
          ),
        ),
        centerTitle: true,
      ),

      // Body of the profile screen
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Profile picture
          CircleAvatar(
            radius: 50,
            backgroundColor:
                isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            backgroundImage:
                (current64bytes != null
                        ? MemoryImage(base64Decode(current64bytes ?? ""))
                        : const AssetImage("images/default_user.png"))
                    as ImageProvider,
          ),

          const SizedBox(height: 10),

          // Username display
          Text(
            username ?? 'Username',
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          // Email display
          Text(
            email ?? 'email@example.com',
            style: TextStyle(color: subTextColor, fontSize: 14),
          ),

          const SizedBox(height: 15),

          // Button to navigate to edit profile
          EditProfileButton(
            onPressed: () async {
              await Navigator.pushNamed(context, '/edit');
              // Refresh user data after editing
              await getBase64Image();
            },
          ),

          const SizedBox(height: 30),

          // Favourite section
          ProfileOptionTile(
            icon: Icons.favorite,
            label: 'Favourite',
            onTap: () {
              Navigator.pushNamed(context, '/favourite');
            },
          ),

          const SizedBox(height: 20),
          Divider(color: theme.textTheme.bodyMedium?.color),
          const SizedBox(height: 20),

          // Settings section
          ProfileOptionTile(
            icon: Icons.settings,
            label: 'Settings',
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),

          const SizedBox(height: 20),
          Divider(color: theme.textTheme.bodyMedium?.color),
          const SizedBox(height: 20),

          // Logout option
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
            onTap: () => logoutFunction(context),
          ),
        ],
      ),
    );
  }
}
