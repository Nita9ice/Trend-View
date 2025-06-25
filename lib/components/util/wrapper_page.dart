import 'package:flutter/material.dart';
import 'package:trendveiw/screens/home_screen.dart';
import 'package:trendveiw/screens/profile_screen.dart';
import 'package:trendveiw/screens/search_screen.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  // Tracks the currently selected tab index
  int _currentIndex = 0;

  // List of screens associated with each bottom navigation item
  List<Widget> selectedIndex = <Widget>[
    // Home Screen
    HomeScreen(),
    // Search Screen
    SearchScreen(),
    // Profile Screen
    ProfileScreen(),
  ];

  // Updates the current index and refreshes the UI
  void changeIndex(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current app theme (light or dark)
    final theme = Theme.of(context);
    return Scaffold(
      // Bottom navigation bar for switching between main sections
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          changeIndex(index);
        },
        showUnselectedLabels: true,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          // Bottom navigation bar for home screen
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          // Bottom navigation bar for for search screen
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          // Bottom navigation bar for profile screen
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      // Display the screen corresponding to the selected tab
      body: selectedIndex[_currentIndex],
    );
  }
}
