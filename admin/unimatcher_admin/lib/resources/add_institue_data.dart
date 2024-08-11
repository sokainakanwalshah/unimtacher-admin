import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class StoreInstituteData {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadImageToFirebase(String path, Uint8List image) async {
    try {
      final ref = _storage.ref(path);
      final uploadTask = ref.putData(image);

      final snapshot = await uploadTask.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();

      return url;
    } catch (e) {
      throw 'Something went wrong, Please try again';
    }
  }

  Future<String> updateInstituteData(
      String instituteId, Map<String, dynamic> updatedData) async {
    try {
      final instituteRef = _firestore.collection('Institutes').doc(instituteId);
      await instituteRef.update(updatedData);
      return "success";
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> saveInstitute({
    required String name,
    required String imageUrl,
    required String cityValue,
    required String phoneNumber,
    required String locationLink,
    required Uint8List image,
  }) async {
    try {
      // Check if the image is picked
      if (image.isNotEmpty) {
        // Upload image to Firebase Storage
        String imagePath =
            'images/institutes/${DateTime.now().millisecondsSinceEpoch}.jpg';
        String imageUrl = await uploadImageToFirebase(imagePath, image);

        // Save institute data to Firestore
        DocumentReference instituteRef =
            await _firestore.collection('Institutes').add({
          'Name': name,
          'ImageURL': imageUrl,
          'City': cityValue,
          'PhoneNumber': phoneNumber,
          'LocationLink': locationLink,
        });

        return instituteRef.id;
      } else {
        return "Error: No image selected";
      }
    } catch (err) {
      return err.toString();
    }
  }
}
