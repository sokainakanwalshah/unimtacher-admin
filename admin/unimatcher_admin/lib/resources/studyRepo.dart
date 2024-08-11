import 'package:cloud_firestore/cloud_firestore.dart';

class StudyMaterialRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('TestsMaterial');

  Future<int> getmaterialCount() async {
    try {
      QuerySnapshot querySnapshot = await _collectionReference.get();
      return querySnapshot.size;
    } catch (e) {
      print('Error fetching material count: $e');
      return 0;
    }
  }
}
