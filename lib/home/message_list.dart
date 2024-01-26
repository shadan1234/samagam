import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase-services.dart';

class MessageList extends StatelessWidget {
  final String userId;
  final FirebaseServices firebaseServices = FirebaseServices();

  MessageList({required this.userId});
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var message = doc.data() as Map<String, dynamic>;
              bool isCompleted = message['completed'] ?? false;

              return Card( // Use Card for better UI
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message['imageUrl'] != null)
                        GestureDetector(
                          onTap: ()=>_showFullImage(context, message['imageUrl']),
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
                            value: isCompleted,
                            onChanged: isCompleted ? null : (bool? newValue) {
                              if (newValue != null) {
                                firebaseServices.updateTaskCompletion(doc.id, true); // Only allow checking
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
            },
          );
        } else {
          return Center(child: Text('No messages'));
        }
      },
    );
  }
}
