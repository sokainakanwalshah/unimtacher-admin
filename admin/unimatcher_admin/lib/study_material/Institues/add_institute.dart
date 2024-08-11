import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unimatcher_admin/resources/add_institue_data.dart';
import 'package:unimatcher_admin/resources/add_uni_data.dart';

class AddInstituteScreen extends StatefulWidget {
  final VoidCallback? onClose;
  const AddInstituteScreen({super.key, this.onClose});

  @override
  State<AddInstituteScreen> createState() => _AddInstituteScreenState();
}

class _AddInstituteScreenState extends State<AddInstituteScreen> {
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

  void resetFields() {
    setState(() {
      imageUrl = null;
      image = null;
      nameController.clear();
      phoneNumberController.clear();
      cityController.clear();
      locationController.clear();
      nameError = null;
      phoneNumberError = null;
      cityError = null;
      locationError = null;
    });
  }

  bool validateFields() {
    setState(() {
      nameError = validateName(nameController.text);
      phoneNumberError = validatePhoneNumber(phoneNumberController.text);
      cityError = validateCity(cityController.text);
      locationError = validateLocation(locationController.text);
    });

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
      String imageUrl =
          await StoreData().uploadImageToFirebase(imagePath, image!);

      // Save institute data to Firestore
      String instituteId = await StoreInstituteData().saveInstitute(
        name: name,
        imageUrl: imageUrl,
        phoneNumber: phoneNumber,
        cityValue: cityValue,
        locationLink: locationLink,
        image: image!, // Pass the Uint8List image
      );

      // Show result
      print('Institute Saved with ID: $instituteId');
    } else {
      print('Error: No image selected');
    }
    resetFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Institute'),
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
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center the content horizontally
              children: [
                const Text(
                  'Institute Details',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildImageUploadContainer(),
                const SizedBox(
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

                const SizedBox(height: 16.0),
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
                            "Add",
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
}
