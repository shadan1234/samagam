import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../auth.dart';
import '../constants/map_int_to_location.dart';
import 'esp_data.dart';

class MessageForCleaners extends StatelessWidget {
  final String category;

  const MessageForCleaners({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: Padding(
          padding: const EdgeInsets.all(8.0), // Add padding around the icon
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                8), // Adjust the border radius for curvature
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
          'Smart camp Connect',
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
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: Rx.combineLatest2(
          streamMessages(category),
          streamEsp32Data(),
          (List<Map<String, dynamic>> messages,
              List<Map<String, dynamic>> esp32Data) {
            var combinedData = [...messages, ...esp32Data];

            // Sort combined data by timestamp (convert Firestore Timestamps to Unix timestamps for comparison)
            combinedData.sort((a, b) {
              var aTimestamp = a['timestamp'];
              var bTimestamp = b['timestamp'];

              // Convert Firestore Timestamp to Unix timestamp (in seconds) if necessary
              if (aTimestamp is Timestamp) {
                aTimestamp = aTimestamp.seconds;
              } else if (aTimestamp is String) {
                aTimestamp = int.tryParse(aTimestamp) ?? 0;
              }

              if (bTimestamp is Timestamp) {
                bTimestamp = bTimestamp.seconds;
              } else if (bTimestamp is String) {
                bTimestamp = int.tryParse(bTimestamp) ?? 0;
              }

              // Compare the Unix timestamps (as integers)
              return bTimestamp.compareTo(aTimestamp);
            });

            return combinedData;
          },
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var items = snapshot.data ?? [];
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index];
                if (item['type'] == 'message') {
                  return buildMessageItem(
                      context, item); // Your function to build message items
                } else if (item['type'] == 'esp32') {
                  var actualFilled = 35 - double.parse(item['dist']);
                  if (actualFilled >= 20) {
                    return buildEsp32Item(
                        context, item); // Your function to build esp32 items
                  } else {
                    return SizedBox.shrink();
                  }
                } else {
                  return SizedBox.shrink(); // Fallback for unknown item type
                }
              },
            );
          }
        },
      ),
    );
  }
}
