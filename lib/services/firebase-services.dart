import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String text, String? imageUrl,bool completed) async {
    String? userId = _auth.currentUser?.uid;
    if (userId != null) {
      await _firestore.collection('messages').add({
        'userId': userId,
        'text': text,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'compeleted':completed
      });
    }
  }

  Future<String> uploadImageToFirebase(File file) async {
    String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
    Reference ref = FirebaseStorage.instance.ref().child(fileName);

    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
  Future<void> updateTaskCompletion(String messageId, bool completed) async {
    await FirebaseFirestore.instance.collection('messages').doc(messageId).update({'completed': completed});
  }
}
