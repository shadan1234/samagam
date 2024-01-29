import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:samagam_hack/auth.dart';
import 'package:samagam_hack/home/students_category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List of widgets to display as body
  final List<Widget> _children = [
    StudentsCategoryScreen(category: 'Plumber'),
    StudentsCategoryScreen(category: 'Electrician'),
    StudentsCategoryScreen(category: 'Cleaner'),
    // Screen(category: 'Electrician'),
    // CategoryScreen(category: 'Cleaner'),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: Padding(
          padding: const EdgeInsets.all(8.0), // Add padding around the icon
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            // Adjust the border radius for curvature
            child: Image.asset(
              'assets/icons/app.png', // Replace with your asset path
              fit: BoxFit.cover, // Ensures the image covers the ClipRRect area
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                AuthService().signOutTheUser();
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ))
        ],
        title: Text(
          'Nitr Clean',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            // Adjust font size
            fontWeight: FontWeight.bold,
            // Make the text bold
            fontStyle: FontStyle.italic,
            // Italicize the text
            shadows: [
              // Add text shadow for depth
              Shadow(
                blurRadius: 2.0,
                color: Colors.black.withOpacity(0.3),
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
        centerTitle: true,
        elevation: 4.0, // Add elevation for depth (optional)
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.plumbing),
            label: 'Plumber',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.electrical_services),
            label: 'Electrician',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: 'Cleaner',
          ),
        ],
      ),
    );
  }
}
