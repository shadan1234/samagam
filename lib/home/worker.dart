import 'package:flutter/material.dart';
import 'package:samagam_hack/home/message_for_workers.dart';

import '../auth.dart';

class Worker extends StatelessWidget {
  final String category;

  const Worker({Key? key, required this.category}) : super(key: key);

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
      body: MessageForWorkers(category: category),
    );
  }
}
