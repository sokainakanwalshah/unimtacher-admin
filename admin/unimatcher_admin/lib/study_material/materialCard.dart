import 'package:flutter/material.dart';

class StudyMaterialCard extends StatelessWidget {
  final String fileName;
  final Function onDelete;

  const StudyMaterialCard({
    Key? key,
    required this.fileName,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(fileName),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            onDelete();
          },
        ),
      ),
    );
  }
}
