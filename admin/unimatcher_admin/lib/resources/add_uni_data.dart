import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';

class StoreData {
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

  Future<String> updateUniversityData(
      String universityId, Map<String, dynamic> updatedData) async {
    try {
      final universityRef =
          _firestore.collection('Universities').doc(universityId);
      await universityRef.update(updatedData);
      return "success";
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> saveData({
    required String name,
    required String imageUrl,
    required List<String> cityValues,
    required String hecRanking,
    required String qsRanking,
    required String provinceValue,
    required String sectorValue,
    required String hostelValue,
    required String sportsValue,
    required String coEducationValue,
    required String scholarshipValue,
    required String admissionCriteriaValue,
    required String wifiValue,
    required String phoneNumber,
    required String onlineApplyLink,
    required String transportValue,
    required Map<String, String> degreeValues,
    required List<String> categories,
  }) async {
    try {
      if (name.isNotEmpty) {
        DocumentReference universityRef =
            await _firestore.collection('Universities').add({
          'Name': name,
          'imageLink': imageUrl,
          'HECRanking': hecRanking,
          'QSRanking': qsRanking,
          'provinceValue': provinceValue,
          'sectorValue': sectorValue,
          'hostelValue': hostelValue,
          'sportsValue': sportsValue,
          'coEducationValue': coEducationValue,
          'scholarshipValue': scholarshipValue,
          'AdmissionCriteria': admissionCriteriaValue,
          'WiFiValue': wifiValue,
          'Cities': cityValues, // Update to store list of cities
          'degreeValues': degreeValues,
          'Phone Number': phoneNumber,
          'Online Apply Link': onlineApplyLink,
          'Transport': transportValue,
          'Categories': categories,
        });

        for (String category in categories) {
          await _firestore.collection('Categories').doc(category).set({
            'Universities': FieldValue.arrayUnion([universityRef.id])
          }, SetOptions(merge: true));
        }
        return universityRef.id;
      } else {
        return "University name is empty";
      }
    } catch (err) {
      return err.toString();
    }
  }

  Future<String> saveDegreeData(
      String universityId, List<String> degrees) async {
    try {
      final universityRef =
          _firestore.collection('Universities').doc(universityId);
      await universityRef.update({
        'Degrees': degrees,
      });
      return "success";
    } catch (err) {
      return err.toString();
    }
  }
}
