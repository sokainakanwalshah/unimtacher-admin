import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unimatcher_admin/study_material/Material/Widgets/cities_section.dart';
import 'package:unimatcher_admin/study_material/Material/Widgets/upload_file_screen.dart';
import 'package:unimatcher_admin/study_material/Material/Widgets/custom_material_card.dart';
import 'package:unimatcher_admin/study_material/study_material_controller.dart';
import 'package:unimatcher_admin/utils/constants/colors.dart';

class StudyMaterialsScreen extends StatelessWidget {
  final controller = Get.put(StudyMaterialsController());

  @override
  Widget build(BuildContext context) {
    // Define file types and subjects for each exam type
    Map<String, List<String>> examTypes = {
      'MDCAT': ['MCQs', 'Notes'],
      'ECAT': ['MCQs', 'Notes'],
      'NTS': ['MCQs', 'Notes'],
      'NUMS': ['MCQs', 'Notes'],
    };

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: const Center(
              child: Text(
                'Manage Study Material Here',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CitiesSection(),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Obx(() {
                      // Check the selected subject to determine which widget to show
                      if (controller.selectedSubject.value.isEmpty) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Manage Files',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomMaterialCard(
                                    label: 'MDCAT',
                                    onPressed: () {
                                      controller.selectSubject('MDCAT');
                                    },
                                    color: UMColors.primary.withOpacity(0.8),
                                  ),
                                  CustomMaterialCard(
                                      label: 'ECAT',
                                      onPressed: () {
                                        controller.selectSubject('ECAT');
                                      },
                                      color: Color.fromARGB(255, 236, 167, 38)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomMaterialCard(
                                    label: 'NTS',
                                    onPressed: () {
                                      controller.selectSubject('NTS');
                                    },
                                    color: Color.fromARGB(255, 236, 167, 38),
                                  ),
                                  CustomMaterialCard(
                                      label: 'NUMS',
                                      onPressed: () {
                                        controller.selectSubject('NUMS');
                                      },
                                      color: UMColors.primary.withOpacity(0.8)),
                                ],
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Get file types and subjects for the selected exam type
                        List<String> fileTypes =
                            examTypes[controller.selectedSubject.value]!;
                        List<String> subjects =
                            []; // Define subjects for each exam type
                        if (controller.selectedSubject.value == 'MDCAT') {
                          // Define subjects for MDCAT
                          subjects = [
                            'Physics',
                            'Chemistry',
                            'Biology',
                            'English',
                            'Logic Reasoning'
                          ];
                        } else if (controller.selectedSubject.value == 'ECAT') {
                          // Define subjects for ECAT
                          subjects = [
                            'Mathematics',
                            'Physics',
                            'Chemistry',
                            'English',
                            'Computer Science',
                            'Statics'
                          ];
                        } else if (controller.selectedSubject.value == 'NTS') {
                          // Define subjects for NTS
                          subjects = [
                            'English',
                            'Mathematics',
                            'Physics',
                            'Analytics',
                            'Quantative',
                            'Computer Science',
                          ];
                        } else if (controller.selectedSubject.value == 'NUMS') {
                          // Define subjects for NUMS
                          subjects = [
                            'Biology',
                            'Chemistry',
                            'Physics',
                            'English',
                            'Psychology'
                          ];
                        }

                        return FileUploadWidget(
                          selectedSubject: controller.selectedSubject.value,
                          fileTypes: fileTypes,
                          subjects: subjects,
                        );
                      }
                    }),
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
