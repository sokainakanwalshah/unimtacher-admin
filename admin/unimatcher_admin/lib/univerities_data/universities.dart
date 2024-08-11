import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unimatcher_admin/univerities_data/edit_univeristy_screen.dart';
import 'package:unimatcher_admin/univerities_data/univeristy_controller.dart';
import 'package:unimatcher_admin/utils/constants/colors.dart';

import '../utils/constants/sizes.dart';

class Universities extends StatefulWidget {
  @override
  _UniversitiesState createState() => _UniversitiesState();
}

class _UniversitiesState extends State<Universities> {
  final UniversityController _controller = Get.put(UniversityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 800),
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          padding: EdgeInsets.all(16.0),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Universities',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Expanded(
                  child: _controller.selectedUniversity.value == null
                      ? _buildUniversityList()
                      : EditUniversityScreen(
                          uni: _controller.selectedUniversity.value!,
                          onClose: () {
                            _controller.clearSelectedUniversity();
                          },
                        ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUniversityList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Universities').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.separated(
          itemCount: snapshot.data.docs.length,
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 16);
          },
          itemBuilder: (context, index) {
            DocumentSnapshot<Map<String, dynamic>>? uni = snapshot
                .data.docs[index] as DocumentSnapshot<Map<String, dynamic>>?;
            final imageUrl = uni!['imageLink'] ?? '';
            print(imageUrl);
            return GestureDetector(
              onTap: () {
                _controller.selectUniversity(uni);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: UMColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  title: Text(
                    uni['Name'],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    uni['sectorValue'],
                    style: TextStyle(color: UMColors.secondary),
                  ),
                  trailing: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('Universities')
                          .doc(uni.id)
                          .delete();
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
