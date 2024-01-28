import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ... other methods

  // Method to create/update user data
  Future<void> updateUserData(String uid, String email, String userType) async {
    return await _db.collection('users').doc(uid).set({
      'email': email,
      'userType': userType,
      // You can initialize messages subcollection here if needed
      // 'messages': {}
    }, SetOptions(merge: true));
  }

  // Stream userType for realtime updates
  Stream<String> streamUserType(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((snapshot) {
      return snapshot.data()?['userType'] ?? '';
    });
  }
}
