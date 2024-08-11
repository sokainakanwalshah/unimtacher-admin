import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unimatcher_admin/dashboard/Dashboard%20cards/userStats.dart';

class UuniversityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> getUniveristyCount() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('Universities').get();
      return querySnapshot.size;
    } catch (e) {
      print('Error fetching users count: $e');
      return 0;
    }
  }
}
