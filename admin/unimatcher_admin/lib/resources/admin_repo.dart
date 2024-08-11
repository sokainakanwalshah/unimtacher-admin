import 'package:cloud_firestore/cloud_firestore.dart';

class AdminRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _adminCollection =
  FirebaseFirestore.instance.collection('Admin');

  Future<Map<String, dynamic>> getAdminDetails(String adminId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> adminSnapshot =
      await _adminCollection.doc(adminId).get()
      as DocumentSnapshot<Map<String, dynamic>>;
      if (adminSnapshot.exists) {
        return adminSnapshot.data() ?? {};
      } else {
        throw 'Admin with ID $adminId not found';
      }
    } catch (e) {
      throw 'Error fetching admin details: $e';
    }
  }

  Future<bool> changePassword(String adminId, String newPassword) async {
    try {
      await _adminCollection.doc(adminId).update({'password': newPassword});
      return true; // Password changed successfully
    } catch (e) {
      throw 'Error updating password: $e';
    }
  }
}
