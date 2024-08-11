import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UniversityController extends GetxController {
  RxList<DocumentSnapshot> universities = <DocumentSnapshot>[].obs;
  Rx<DocumentSnapshot?> selectedUniversity = Rx<DocumentSnapshot?>(null);

  @override
  void onInit() {
    super.onInit();
    // Fetch universities when the controller is initialized
    fetchUniversities();
  }

  void fetchUniversities() async {
    try {
      final QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Universities').get();
      universities.value = querySnapshot.docs;
    } catch (e) {
      print('Error fetching universities: $e');
    }
  }

  void setSelectedUniversity(DocumentSnapshot uni) {
    selectedUniversity.value = uni;
  }
  void selectUniversity(DocumentSnapshot<Map<String, dynamic>>? university) {
    selectedUniversity.value = university;
  }

  void clearSelectedUniversity() {
    selectedUniversity.value = null;
  }

  void deleteUniversity(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('Universities').doc(docId).delete();
    } catch (e) {
      print('Error deleting university: $e');
    }
  }
}
