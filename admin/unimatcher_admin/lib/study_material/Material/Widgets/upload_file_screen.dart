import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:unimatcher_admin/resources/add_files.dart';
import 'package:unimatcher_admin/study_material/materialCard.dart';
import 'package:unimatcher_admin/study_material/study_material_controller.dart';
import 'package:unimatcher_admin/utils/constants/colors.dart';

class FileUploadWidget extends StatefulWidget {
  final String selectedSubject;
  final List<String> fileTypes;
  final List<String> subjects;

  const FileUploadWidget({
    Key? key,
    required this.selectedSubject,
    required this.fileTypes,
    required this.subjects,
  }) : super(key: key);

  @override
  _FileUploadWidgetState createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> files = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _fetchFilesForTest();
  }

  void _fetchFilesForTest() async {
    setState(() {
      isLoading = true;
    });
    List<Map<String, dynamic>> fetchedFiles =
        await FirebaseService.getFilesForTest(widget.selectedSubject);
    setState(() {
      files = fetchedFiles;
      isLoading = false;
    });
    if (files.isEmpty) {
      _showNoFilesSnackbar();
    }
  }

  void _showNoFilesSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red, // Set background color
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 12.0), // Add padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.white), // Add error icon
              SizedBox(width: 8.0), // Add space between icon and text
              Text(
                'No files available for ${widget.selectedSubject}',
                style: TextStyle(color: Colors.white), // Set text color
              ),
            ],
          ),
        ),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating, // Add floating behavior
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Add rounded corners
        ),
        margin: EdgeInsets.all(16.0), // Add margin
        elevation: 4.0, // Add elevation
        animation: CurvedAnimation(
          // Add animation effect
          parent: AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 500),
          ),
          curve: Curves.easeOut,
        ),
      ),
    );
  }

  final controller = Get.find<StudyMaterialsController>();

  String? _selectedFileType;
  String? _selectedSubject;
  late File _selectedFile = File('');
  Uint8List? _selectedFileBytes;
  String _selectedFileName = '';
  TextEditingController _fileNameController =
      TextEditingController(); // Add controller

  String? fileNameError;

  Future<void> _selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        final PlatformFile file = result.files.single;

        String? error = validateFileSize(file.size);
        if (error != null) {
          showSnackBar(error);
          return;
        }

        setState(() {
          _selectedFileBytes = file.bytes!;
          _selectedFileName = file.name;
          _fileNameController.text = _selectedFileName;
        });

        // Upload the file
        await FirebaseService.uploadFile(
          selectedSubject: _selectedSubject!,
          selectedFileType: _selectedFileType!,
          selectedFileName: _selectedFileName,
          fileBytes: _selectedFileBytes!,
          selectedTest: widget.selectedSubject,
        );

        // Clear state variables after uploading
        setState(() {
          _selectedFileType = null;
          _selectedSubject = null;
          _selectedFile = File('');
          _selectedFileBytes = null;
          _selectedFileName = '';
          _fileNameController.clear();
        });

        // Fetch updated file list
        //_fetchFilesForTest();
      }
    } catch (e) {
      print('Error selecting file: $e');
      // Handle error gracefully, e.g., show a snackbar or dialog
    }
  }

  @override
  void dispose() {
    _fileNameController.dispose(); // Dispose controller
    super.dispose();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  bool validateFields() {
    setState(() {
      fileNameError = validateFileName(_fileNameController.text);
    });

    if (fileNameError != null) {
      showSnackBar(fileNameError!);
    }

    return fileNameError == null;
  }

  String? validateFileName(String name) {
    if (name.isEmpty) return 'File name cannot be empty';
    if (name.length < 1) return 'File name must be at least 1 character long';
    if (name.length > 50) return 'File name must be at most 50 characters long';
    return null;
  }

  String? validateFileSize(int size) {
    const int maxSize = 15 * 1024 * 1024; // 10 MB
    if (size > maxSize) return 'File size must be at most 15 MB';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Filter file types to show only "MCQs" and "Notes"
    List<String> filteredFileTypes = widget.fileTypes
        .where((type) => type == 'MCQs' || type == 'Notes')
        .toList();

    return WillPopScope(
      onWillPop: () async {
        controller.clearSelectedSubject(); // Clear selected subject
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              controller.clearSelectedSubject(); // Clear selected subject
              Navigator.pop(context);
            },
          ),
          title: Text('Upload Files - ${widget.selectedSubject}'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedFileType,
                onChanged: (String? value) {
                  setState(() {
                    _selectedFileType = value;
                  });
                },
                items: filteredFileTypes.map((String fileType) {
                  return DropdownMenuItem(
                    child: Text(fileType),
                    value: fileType,
                  );
                }).toList(),
                hint: const Text('Select File Type'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'File Type',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSubject,
                onChanged: (String? value) {
                  setState(() {
                    _selectedSubject = value;
                  });
                },
                items: widget.subjects.map((String subject) {
                  return DropdownMenuItem(
                    child: Text(subject),
                    value: subject,
                  );
                }).toList(),
                hint: const Text('Select Subject'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Subject',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                // Text field for file name
                controller: _fileNameController,
                decoration: InputDecoration(
                  labelText: 'File Name',
                  border: OutlineInputBorder(),
                  errorText: fileNameError,
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _selectFile,
                style: TextButton.styleFrom(
                  backgroundColor: UMColors.white,
                  padding: const EdgeInsets.all(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.upload_rounded, color: Colors.black),
                    Text(
                      _selectedFileName.isEmpty
                          ? 'Select PDF File'
                          : _selectedFileName,
                      style: const TextStyle(color: Colors.black),
                    ),
                    Opacity(
                      opacity: _selectedFile.path.isNotEmpty ? 1 : 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            _selectedFile = File('');
                            _selectedFileName = 'Select PDF File';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 40,
                width: 100, // Adjust the height as needed
                child: ElevatedButton(
                  onPressed: () async {
                    if (validateFields()) {
                      await FirebaseService.uploadFile(
                        selectedSubject: _selectedSubject!,
                        selectedFileType: _selectedFileType!,
                        selectedFileName: _selectedFileName,
                        fileBytes: _selectedFileBytes!,
                        selectedTest: widget.selectedSubject,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 2, // Add elevation
                    shadowColor: Colors.grey, // Add shadow color
                    backgroundColor: UMColors.primary, // Set button color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24), // Adjust padding
                  ),
                  child: const Text(
                    'Upload',
                    style: TextStyle(
                        fontSize: 16, color: Colors.white), // Adjust font size
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Uploaded Files:',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final file = files[index];
                  return ListTile(
                    title: Text('${file['fileName']} - ${file['subject']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await FirebaseService.deleteFile(file['fileId']);
                        // Fetch updated file list
                        _fetchFilesForTest();
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
