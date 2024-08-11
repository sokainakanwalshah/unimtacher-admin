import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';

class FirebaseService {
  static final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String> uploadFile({
    required String selectedTest,
    required String selectedSubject,
    required String selectedFileType,
    required String selectedFileName,
    required Uint8List fileBytes,
  }) async {
    try {
      // Check if fileBytes is not empty
      if (fileBytes.isNotEmpty) {
        // Upload file to Firebase Storage
        String storagePath =
            'files/$selectedTest/$selectedSubject/$selectedFileName';
        String fileUrl = await _uploadFileToStorage(storagePath, fileBytes);

        // Save file metadata to Firestore
        String fileId = await _saveFileMetadata(
          selectedTest,
          selectedSubject,
          selectedFileName,
          selectedFileType,
          fileUrl,
        );

        return fileId;
      } else {
        return "Error: No file selected";
      }
    } catch (e) {
      print('Error uploading file: $e');
      return "Error: $e";
    }
  }

  static Future<String> _uploadFileToStorage(
      String storagePath, Uint8List fileBytes) async {
    try {
      final ref = _storage.ref(storagePath);
      final uploadTask = ref.putData(fileBytes);
      final snapshot = await uploadTask.whenComplete(() {});
      final fileUrl = await snapshot.ref.getDownloadURL();

      return fileUrl;
    } catch (e) {
      throw 'Error uploading file to Firebase Storage: $e';
    }
  }

  static Future<String> _saveFileMetadata(
    String selectedTest,
    String selectedSubject,
    String selectedFileName,
    String selectedFileType,
    String fileUrl,
  ) async {
    try {
      // Generate a unique fileId
      String fileId = _firestore.collection('TestsMaterial').doc().id;

      // Save file metadata in Firestore with fileId
      Map<String, dynamic> fileMetadata = {
        'fileId': fileId,
        'test': selectedTest,
        'subject': selectedSubject,
        'fileName': selectedFileName,
        'fileType': selectedFileType,
        'fileURL': fileUrl,
        'createdAt': Timestamp.now(),
      };

      // Save metadata in main collection
      await _firestore
          .collection('TestsMaterial')
          .doc(fileId)
          .set(fileMetadata);

      // Save metadata in subcollection
      await _firestore
          .collection('TestsMaterial')
          .doc(selectedTest)
          .collection(selectedSubject)
          .doc(fileId)
          .set(fileMetadata);

      return fileId;
    } catch (e) {
      throw 'Error saving file metadata to Firestore: $e';
    }
  }

  static Future<List<Map<String, dynamic>>> getFilesForTest(String test) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('TestsMaterial')
          .where('test', isEqualTo: test)
          .get();

      List<Map<String, dynamic>> files = [];
      querySnapshot.docs.forEach((doc) {
        files.add(doc.data());
      });

      return files;
    } catch (e) {
      print('Error getting files for test: $e');
      return [];
    }
  }

  // Rest of the methods remain unchanged
  static Future<void> deleteFile(String fileId) async {
    try {
      // Delete file from Firebase Storage
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore.collection('TestsMaterial').doc(fileId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data()!;
        String selectedTest = data['test'];
        String selectedSubject = data['subject'];
        String fileName = data['fileName'];

        String storagePath = 'files/$selectedTest/$selectedSubject/$fileName';
        await _storage.ref(storagePath).delete();

        // Delete file metadata from Firestore
        await _firestore.collection('TestsMaterial').doc(fileId).delete();

        print('File deleted successfully');
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
  }
}
