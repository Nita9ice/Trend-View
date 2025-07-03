import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trendveiw/components/util/dialog_box.dart';
import 'package:trendveiw/theme/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the theme controller using Provider
    final themeController = Provider.of<ThemeController>(context);

    // Get current theme mode (dark or light)
    final isDark = themeController.isDarkMode;

    // Get the current app theme (light or dark)
    final theme = Theme.of(context);

    // Function to handle account deletion with confirmation dialog
    void deleteAccount(BuildContext context) async {
      // Show confirmation dialog before deleting account
      final confirm = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Confirm Account Deletion'),
              content: const Text(
                'Are you sure you want to delete your account? This action cannot be undone.',
              ),
              actions: [
                // Cancel button
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),

                // Delete button
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
      );

      // If user confirmed deletion
      if (confirm == true) {
        try {
          // Get current user and attempt to delete the account
          final user = FirebaseAuth.instance.currentUser;
          await user?.delete();

          // Navigate back to login screen and clear navigation stack
          Navigator.pushNamedAndRemoveUntil(
            // ignore: use_build_context_synchronously
            context,
            '/login',
            (route) => false,
          );
        } on FirebaseAuthException catch (e) {
          // Handle Firebase errors with appropriate message
          final message =
              (e.code == 'requires-recent-login')
                  ? 'Please log in again before deleting your account.'
                  : 'Account deletion failed: ${e.message}';

          // Show error dialog
          // ignore: use_build_context_synchronously
          DialogBox.showErrorDialog(context, message);
        }
      }
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.montserrat(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.headlineLarge?.color,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.iconTheme.color),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          /// Theme Toggle
          SwitchListTile(
            secondary: Icon(Icons.brightness_6),
            title: Text('Dark Mode'),
            value: isDark,
            // Toggle theme mode
            onChanged: (val) => themeController.toggleTheme(val),
          ),
          const SizedBox(height: 20),

          // Divider between settings
          Divider(color: theme.textTheme.bodyMedium?.color),
          const SizedBox(height: 20),

          // Delete Account Option
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text(
              'Delete Account',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
            //  delete account function
            onTap: () => deleteAccount(context),
          ),
        ],
      ),
    );
  }
}
