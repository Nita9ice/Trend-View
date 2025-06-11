

import 'package:flutter/material.dart';
import 'package:trendveiw/screens/home_screen.dart';

import 'package:trendveiw/screens/discovery.dart';
import 'package:trendveiw/screens/profile_screen.dart';
import 'package:trendveiw/screens/search_page.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  int _currentIndex = 0;
List<Widget> selectedIndex = <Widget>[
HomeScreen(),
DiscoveryScreen(),
ProfileScreen(),
SearchScreen(),
];

    
     
    void changeIndex(index){
      print(index);
setState(() {
            _currentIndex = index;
          });

     }

  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      /* appBar: AppBar(
        title: Text(
          'TrendVeiw',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.pinkAccent,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ), */


      bottomNavigationBar: BottomNavigationBar(
        
        currentIndex: _currentIndex,
        onTap: (index) {
          
          changeIndex(index);
          // Add navigation logic here if needed
        },
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discovery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),

      body: selectedIndex[_currentIndex],
      );
  }
}

