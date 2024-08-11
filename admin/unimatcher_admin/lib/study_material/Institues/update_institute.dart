import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unimatcher_admin/resources/add_institue_data.dart';

class UpdateInstituteScreen extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> institute;
  final VoidCallback? onClose;

  UpdateInstituteScreen({required this.institute, this.onClose});

  @override
  _UpdateInstituteScreenState createState() => _UpdateInstituteScreenState();
}

class _UpdateInstituteScreenState extends State<UpdateInstituteScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  String? imageUrl;
  Uint8List? image;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  String? nameError;
  String? phoneNumberError;
  String? cityError;
  String? locationError;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with institute data
    nameController.text = widget.institute['Name'] ?? '';
    phoneNumberController.text = widget.institute['PhoneNumber'] ?? '';
    cityController.text = widget.institute['City'] ?? '';
    locationController.text = widget.institute['LocationLink'] ?? '';
    imageUrl = widget.institute['ImageURL'] ?? '';
  }

  Future<void> updateInstitutes(Map<String, dynamic> updatedData) async {
    await widget.institute.reference.update(updatedData);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  bool validateFields() {
    setState(() {
      nameError = validateName(nameController.text);
      phoneNumberError = validatePhoneNumber(phoneNumberController.text);
      cityError = validateCity(cityController.text);
      locationError = validateLocation(locationController.text);
    });

    if (nameError != null) {
      showSnackBar(nameError!);
    } else if (phoneNumberError != null) {
      showSnackBar(phoneNumberError!);
    } else if (cityError != null) {
      showSnackBar(cityError!);
    } else if (locationError != null) {
      showSnackBar(locationError!);
    }

    return nameError == null &&
        phoneNumberError == null &&
        cityError == null &&
        locationError == null;
  }

  String? validateName(String name) {
    if (name.isEmpty) return 'Name cannot be empty';
    if (name.length < 1) return 'Name must be at least 1 character long';
    if (name.length > 50) return 'Name must be at most 50 characters long';
    return null;
  }

  String? validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return 'Phone number cannot be empty';
    if (phoneNumber.length < 1)
      return 'Phone number must be at least 1 character long';
    if (phoneNumber.length > 50)
      return 'Phone number must be at most 50 characters long';
    return null;
  }

  String? validateCity(String city) {
    if (city.isEmpty) return 'City cannot be empty';
    if (city.length < 1) return 'City must be at least 1 character long';
    if (city.length > 50) return 'City must be at most 50 characters long';
    return null;
  }

  String? validateLocation(String location) {
    if (location.isEmpty) return 'Location cannot be empty';
    if (location.length < 1)
      return 'Location must be at least 1 character long';
    if (location.length > 500)
      return 'Location must be at most 500 characters long';
    return null;
  }

  void saveInstitute() async {
    // Validate fields
    if (!validateFields()) return;

    // Retrieve input field values
    String name = nameController.text;
    String phoneNumber = phoneNumberController.text;
    String cityValue = cityController.text;
    String locationLink = locationController.text;

    // Check if the image is picked
    if (image != null) {
      // Upload image to Firebase Storage
      String imagePath =
          'images/institutes/${DateTime.now().millisecondsSinceEpoch}.jpg';
      String updatedImageUrl =
          await StoreInstituteData().uploadImageToFirebase(imagePath, image!);

      // Save updated institute data to Firestore
      await updateInstitutes({
        'Name': name,
        'ImageURL': updatedImageUrl,
        'PhoneNumber': phoneNumber,
        'City': cityValue,
        'LocationLink': locationLink,
        'instituteId': widget.institute.id,
      });

      // Show result
      showSnackBar('Institute updated successfully');
      // Navigate back to the previous screen
      Navigator.pop(context);
    } else {
      showSnackBar('Error: No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Institute'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Call the onClose callback when the close button is pressed
            if (widget.onClose != null) {
              widget.onClose!();
            }
          },
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Update Institute Details',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                _buildImageUploadContainer(),
                SizedBox(
                    height:
                        16.0), // Add space between image upload and input fields
                _buildInputField(
                    label: 'Institute Name',
                    controller: nameController,
                    errorText: nameError),
                _buildInputField(
                    label: 'Phone Number',
                    controller: phoneNumberController,
                    errorText: phoneNumberError),
                _buildInputField(
                    label: 'City',
                    controller: cityController,
                    errorText: cityError),
                _buildInputField(
                    label: 'Google Maps Location Link',
                    controller: locationController,
                    errorText: locationError),

                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () => saveInstitute(),
                  child: Center(
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Update",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadContainer() {
    return GestureDetector(
      onTap: () {
        // Call the method to pick the image
        pickImage(ImageSource.gallery);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle, // Make container circular
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: image != null
                ? Image.memory(
                    image!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                : Icon(
                    Icons.add_photo_alternate,
                    size: 50.0,
                    color: Colors.grey[400],
                  ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Upload Institute Picture',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    XFile? imageFile = await _imagePicker.pickImage(
      source: source,
      imageQuality: 70,
      maxHeight: 512,
      maxWidth: 512,
    );
    if (imageFile != null) {
      Uint8List imgBytes = await imageFile.readAsBytes();
      setState(() {
        image = imgBytes;
        imageUrl = null; // Clear imageUrl if a new image is picked
        // Update imageUrl with the new image file
        imageUrl = imageFile.path;
      });
    } else {
      print('No Image Selected');
    }
  }

  Widget _buildInputField(
      {required String label,
      required TextEditingController controller,
      String? errorText}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller, // Set the controller here
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
