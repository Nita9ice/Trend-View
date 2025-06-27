import 'package:flutter/material.dart';

// Reusable class for profile menu items with an icon, label, and tap action.
class ProfileOptionTile extends StatelessWidget {
  // properties for this class
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  // initializing the properties
  const ProfileOptionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get the current app theme (light or dark)
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        //  uses red color if it's a favorite icon, otherwise uses the theme's default icon color.
        color:
            icon == Icons.favorite
                ? Color.fromRGBO(231, 63, 63, 1)
                : theme.iconTheme.color,
      ),
      title: Text(
        label,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}
