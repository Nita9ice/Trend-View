import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trendveiw/components/util/profile_options_tile.dart';
import 'package:trendveiw/theme/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDark = themeController.isDarkMode;

    final theme = Theme.of(context);
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.white;
    final dividerColor = theme.dividerColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            title: Text('Notifications'),
            trailing: Switch(value: true, onChanged: (value) {}),
          ),

          Divider(color: dividerColor),

          ProfileOptionTile(icon: Icons.lock, label: 'Privacy', onTap: () {}),
          ProfileOptionTile(
            icon: Icons.language,
            label: 'Language',
            onTap: () {},
          ),

          /// Theme Toggle
          SwitchListTile(
            secondary: Icon(Icons.brightness_6),
            title: Text('Dark Mode'),
            value: isDark,
            onChanged: (val) => themeController.toggleTheme(val),
          ),

          Divider(color: dividerColor),
          const SizedBox(height: 30),

          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text(
              'Delete Account',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Confirm Account Deletion'),
                      content: const Text(
                        'Are you sure you want to delete your account? This action cannot be undone.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
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

              if (confirm == true) {
                try {
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.delete();

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                } on FirebaseAuthException catch (e) {
                  final message =
                      (e.code == 'requires-recent-login')
                          ? 'Please log in again before deleting your account.'
                          : 'Account deletion failed: ${e.message}';

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
