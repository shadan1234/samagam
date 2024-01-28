import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/firebase-services.dart';
import 'message_list.dart';

class StudentsCategoryScreen extends StatefulWidget {
  @override
  final String? category;
  StudentsCategoryScreen({this.category});
  _StudentsCategoryScreenState createState() => _StudentsCategoryScreenState();
}

class _StudentsCategoryScreenState extends State<StudentsCategoryScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  final FirebaseServices _firebaseServices = FirebaseServices();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    setState(() {
      _image = selectedImage != null ? File(selectedImage.path) : null;
    });
  }

  Future<void> _sendMessage() async {
    String messageText = _messageController.text.trim();
    String? imageUrl;

    if (_image != null) {
      imageUrl = await _firebaseServices.uploadImageToFirebase(_image!);
    }

    if (messageText.isNotEmpty && imageUrl != null) {
      await _firebaseServices.sendMessage(
          widget.category!, messageText, imageUrl, false,false);

      setState(() {
        _image = null;
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MessageList(userId: userId, category: widget.category!),
          ),
          if (_image != null)
            Container(
              height: 50, // Adjust height as needed
              width: double.infinity,
              child: Image.file(
                File(_image!.path),
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                IconButton(
                  icon: Icon(Icons.photo_library),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _sendMessage, // Updated this line
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
