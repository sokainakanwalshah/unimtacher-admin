import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class StudyMaterialsController extends GetxController {
  var selectedSubject = ''.obs;
  var selectedInstitute = Rxn<DocumentSnapshot<Map<String, dynamic>>>();
  var showUpdateScreen = false.obs;
  var showAddInstituteScreen = false.obs; // New observable for showing the add institute screen

  void selectSubject(String subject) {
    selectedSubject.value = subject;
  }

  void clearSelectedSubject() {
    selectedSubject.value = '';
  }

  void selectInstitute(DocumentSnapshot<Map<String, dynamic>> institute) {
    selectedInstitute.value = institute;
  }

  void clearSelectedInstitute() {
    selectedInstitute.value = null;
    showUpdateScreen.value = false;
  }

  void toggleUpdateScreenVisibility() {
    showUpdateScreen.toggle();
  }

  void toggleAddInstituteScreenVisibility() {
    showAddInstituteScreen.toggle(); // Method to toggle the visibility of the add institute screen
  }





}
