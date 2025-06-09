import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trendveiw/theme/theme_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Handle settings press
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // Profile Picture + Username + Email
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                    'assets/avatar_placeholder.png',
                  ), // Replace with your asset or network image
                ),
                const SizedBox(height: 10),
                const Text(
                  'Username Placeholder',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'user@email.com',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to edit profile
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profile"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Options
          const Text(
            "General",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text("Favourites"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text("Downloads"),
            onTap: () {},
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Languages"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.display_settings),
            title: const Text("Display"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.subscriptions),
            title: const Text("Subscription"),
            onTap: () {},
          ),

          const Divider(),

          SwitchListTile(
            secondary: const Icon(Icons.brightness_6),
            title: const Text("Dark Mode"),
            value: themeController.isDarkMode,
            onChanged: (value) {
              themeController.toggleTheme(value);
            },
          ),
          ListTile(
            leading: const Icon(Icons.cleaning_services),
            title: const Text("Clear Cache"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Clear History"),
            onTap: () {},
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              // handle logout
            },
          ),
        ],
      ),
    );
  }
}
