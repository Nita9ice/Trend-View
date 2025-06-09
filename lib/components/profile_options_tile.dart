import 'package:flutter/material.dart';

class ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ProfileOptionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: theme.iconTheme.color, // Use theme icon color
      ),
      title: Text(
        label,
        style: TextStyle(
          color: theme.textTheme.bodyLarge?.color, // Use theme text color
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}
