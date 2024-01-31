import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:samagam_hack/constants/map_int_to_location.dart';

import '../services/firebase-services.dart';

//
// Future<List<Map<String, dynamic>>> fetchMessages(String category) async {
//   var messagesSnapshot = await FirebaseFirestore.instance
//       .collection('messages')
//       .where('category',
//           isEqualTo:
//               category) // Assuming 'category' is a variable you have in scope
//       .orderBy('timestamp', descending: true)
//       .get();
//
//   return messagesSnapshot.docs
//       .map((doc) => {
//             ...doc.data() as Map<String, dynamic>,
//             'id': doc.id,
//             'type': 'message',
//           })
//       .toList();
// }
//
// Future<List<Map<String, dynamic>>> fetchEsp32Data() async {
//   var esp32Snapshot = await FirebaseFirestore.instance
//       .collection('Esp32')
//       .orderBy('timestamp', descending: true)
//       .get();
//
//   return esp32Snapshot.docs
//       .map((doc) => {
//             ...doc.data() as Map<String, dynamic>,
//             'id': doc.id,
//             'type': 'esp32',
//           })
//       .toList();
// }
Stream<List<Map<String, dynamic>>> streamMessages(String category) {
  return FirebaseFirestore.instance
      .collection('messages')
      .where('category', isEqualTo: category)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
                'type': 'message',
              })
          .toList());
}

Stream<List<Map<String, dynamic>>> streamEsp32Data() {
  return FirebaseFirestore.instance
      .collection('Esp32')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => {
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
                'type': 'esp32',
              })
          .toList());
}

// Future<List<Map<String, dynamic>>> fetchAndMergeData(String category) async {
//   var messages = await fetchMessages(category);
//   var esp32Data = await fetchEsp32Data();
//
//   // Combine both lists
//   var combinedData = [...messages, ...esp32Data];
//
//   // Sort combined data by timestamp (convert Firestore Timestamps to Unix timestamps for comparison)
//   combinedData.sort((a, b) {
//     var aTimestamp = a['timestamp'];
//     var bTimestamp = b['timestamp'];
//
//     // Convert Firestore Timestamp to Unix timestamp (in seconds) if necessary
//     if (aTimestamp is Timestamp) {
//       aTimestamp = aTimestamp.seconds;
//     } else if (aTimestamp is String) {
//       aTimestamp = int.tryParse(aTimestamp) ?? 0;
//     }
//
//     if (bTimestamp is Timestamp) {
//       bTimestamp = bTimestamp.seconds;
//     } else if (bTimestamp is String) {
//       bTimestamp = int.tryParse(bTimestamp) ?? 0;
//     }
//
//     // Compare the Unix timestamps (as integers)
//     return bTimestamp.compareTo(aTimestamp);
//   });
//
//   return combinedData;
// }

void _showFullImage(BuildContext context, String imageUrl) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.network(imageUrl),
      ),
    ),
  ));
}

Widget buildMessageItem(BuildContext context, Map<String, dynamic> message) {
  final FirebaseServices firebaseServices = FirebaseServices();
  bool isCompletedW = message['completedW'] ?? false;
  return Card(
    // Use Card for better UI
    margin: EdgeInsets.all(8.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message['imageUrl'] != null)
            GestureDetector(
              onTap: () => _showFullImage(context, message['imageUrl']),
              child: Container(
                height: 150, // Standardize image height
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(message['imageUrl']),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          SizedBox(height: 8),
          Text(
            message['text'] ?? '',
            style: TextStyle(
              fontSize: 16, // Customize text size
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: isCompletedW,
                onChanged: isCompletedW
                    ? null
                    : (bool? newValue) {
                        if (newValue != null) {
                          firebaseServices.updateTaskCompletionForWorker(
                              message['id'], true); // Only allow checking
                        }
                      },
              ),
              Expanded(
                child: Text(
                  'Work finished',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget buildEsp32Item(BuildContext context, Map<String, dynamic> esp32Data) {
  var actualLoc = esp32Data['location'];

  

  final FirebaseServices firebaseServices = FirebaseServices();
  // var x=esp32Data['completedW'];
  // if(x=='false')
  //
  bool isCompletedW = esp32Data['completedW'] ?? false;
  return Card(
    // Use Card for better UI
    margin: EdgeInsets.all(8.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250, // Standardize image height
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/dustbin.jpeg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Hey! there, the dustbin at $actualLoc is filled can you help in cleaning it out',
            style: TextStyle(
              fontSize: 16, // Customize text size
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: isCompletedW,
                onChanged: isCompletedW
                    ? null
                    : (bool? newValue) {
                        if (newValue != null) {
                          firebaseServices.updateTaskCompletionForWorkerEsp(
                              esp32Data['id'], true); // Only allow checking
                        }
                      },
              ),
              Expanded(
                child: Text(
                  'Work finished',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
