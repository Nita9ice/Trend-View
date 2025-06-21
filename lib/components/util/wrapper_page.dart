import 'package:flutter/material.dart';
import 'package:trendveiw/screens/home_screen.dart';
import 'package:trendveiw/screens/discovery.dart';
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
    HomeScreen(),
    DiscoveryScreen(),
    SearchScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discovery',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      // Display the screen corresponding to the selected tab
      body: selectedIndex[_currentIndex],
    );
  }
}
