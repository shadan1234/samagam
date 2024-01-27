// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'message_list.dart';
//
// class CategoryScreen extends StatelessWidget {
//   final String category;
//
//   CategoryScreen({required this.category});
//
//   @override
//   Widget build(BuildContext context) {
//     // Get the current user's UID
//     String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(category),
//       ),
//       body: MessageList(category: category, userId: userId),
//     );
//   }
// }
