import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unimatcher_admin/study_material/Institues/add_institute.dart';
import 'package:unimatcher_admin/study_material/Institues/update_institute.dart';
import 'package:unimatcher_admin/study_material/study_material_controller.dart';
import 'package:unimatcher_admin/utils/constants/colors.dart';

class CitiesSection extends StatelessWidget {
  final StudyMaterialsController _controller =
  Get.find<StudyMaterialsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.showAddInstituteScreen.value) {
        return AddInstituteScreen(onClose: () {
          _controller.toggleAddInstituteScreenVisibility();
        });
      } else if (_controller.showUpdateScreen.value &&
          _controller.selectedInstitute.value != null) {
        return UpdateInstituteScreen(
          institute: _controller.selectedInstitute.value!,
          onClose: () {
            _controller.toggleUpdateScreenVisibility();
          },
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Institutes',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: UMColors.black,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller.toggleAddInstituteScreenVisibility();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: UMColors.primary,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Institutes')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(height: 16),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot<Map<String, dynamic>> institute =
                      snapshot.data!.docs[index];
                      return  InstituteItem(
                          institute: institute,
                          onTap: () {
                            _controller.selectInstitute(institute);
                            _controller.toggleUpdateScreenVisibility();
                          },
                        )
                      ;
                    },
                  );
                },
              ),
            ),
          ],
        );
      }
    });
  }
}



class InstituteItem extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> institute;
  final VoidCallback onTap;

  const InstituteItem({Key? key, required this.institute, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        institute.data()?['imageUrl'] ?? ''; // Safely retrieve the imageUrl
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: UMColors.primary, // Set card background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        child: ListTile(
          title: Text(
            institute.data()?['Name'] ?? '', // Safely retrieve the institute name
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ), // Set text color to white
          ),
          subtitle: Text(
            institute.data()?['City'] ?? '', // Safely retrieve the city
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white, // Set icon color to white
            ),
            onPressed: () {
              // Perform delete operation
              FirebaseFirestore.instance
                  .collection('Institutes')
                  .doc(institute.id)
                  .delete();
            },
          ),
        ),
      ),
    );
  }
}
