import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String category, String text, String? imageUrl,
      bool completedU, bool completedW) async {
    String? userId = _auth.currentUser?.uid;
    if (userId != null) {
      await _firestore.collection('messages').add({
        'userId': userId,
        'category': category,
        'text': text,
        'imageUrl': imageUrl,
        'completedU': completedU,
        'completedW': completedW,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<String> uploadImageToFirebase(File file) async {
    String fileName =
        'images/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
    Reference ref = FirebaseStorage.instance.ref().child(fileName);

    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> updateTaskCompletionForWorker(
      String messageId, bool completed) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(messageId)
        .update({'completedW': completed});
  }

  Future<void> updateTaskCompletionForUser(
      String messageId, bool completed) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(messageId)
        .update({'completedU': completed});
  }

  Future<void> updateTaskCompletionForWorkerEsp(
      String messageId, bool completed) async {
    await FirebaseFirestore.instance
        .collection('Esp32')
        .doc(messageId)
        .update({'completedW': completed});
  }
}
