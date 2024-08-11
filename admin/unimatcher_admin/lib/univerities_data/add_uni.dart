import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unimatcher_admin/utils/constants/colors.dart';
import 'package:unimatcher_admin/utils/constants/image_strings.dart';
import 'package:unimatcher_admin/resources/add_uni_data.dart';

import 'dart:math';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:unimatcher_admin/utils/constants/sizes.dart';

class AddUniversity extends StatefulWidget {
  const AddUniversity({Key? key}) : super(key: key);

  @override
  State<AddUniversity> createState() => _AddUniversityState();
}

class _AddUniversityState extends State<AddUniversity> {
  List<String> degrees = [
    'BS Computer Science',
    'BBA',
    'BS Software Engineering',
    'BS Law',
    'MBBS',
    'Bachelor of Business Administration',
    'BS Fashion and Design',
    'MBA',
    'BS Medical',
    'BS Physics',
    'BS Accounting and Finance',
    'Bachelor of Fine Arts and Design',
    'Chartered Accountancy',
    'BS Medical Sciences',
    'BS Pharmacy',
    'BS Sociology',
    'BS Agricultural Sciences',
    'BS Biotechnology',
    'BS Electrical Engg',
    'BS Mass Communication',
    'BSc Engineering',
    'BS Chemistry',
    'BS Dentistry',
  ];

  List<String> categories = [
    'Computer Science',
    'Nursing',
    'Engineering',
    'Arts',
    'BBA',
    'Fashion design',
    'LLB',
    'BSMC'
  ];

  List<String> selectedCategories = [];

  Map<String, TextEditingController> feeControllers = {};
  List<TextEditingController> cityControllers = [];

  TextEditingController newDegreeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text controllers for fees
    degrees.forEach((degree) {
      feeControllers[degree] =
          TextEditingController(); // Create a new controller for each degree
    });

    cityControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    // Dispose text controllers
    feeControllers.values.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  void addDegree() {
    String newDegree = newDegreeController.text.trim();
    if (newDegree.isNotEmpty && !degrees.contains(newDegree)) {
      setState(() {
        degrees.add(newDegree);
        feeControllers[newDegree] = TextEditingController();
        newDegreeController.clear();
      });
    }
  }

  String? imageUrl;
  String? provinceValue;
  String? sectorValue;
  String? hostelValue;
  String? sportsValue;
  String? wifiValue;
  String? coEducationValue;
  String? scholarshipValue;
  String? transportValue;
  final List<String> sector = ['Public', 'Private'];
  final List<String> province = [
    'Punjab',
    'KPK',
    'Balochistan',
    'Sindh',
    'Gilgit Baltistan'
  ];
  final List<String> admissionCriteria = [
    '40%-50%',
    '60%-70%',
    '80%-85%',
  ];
  String? selectedAdmissionCriteria;
  final List<String> choose = ['Yes', 'No'];
  Uint8List? image;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController applyLinkController = TextEditingController();

  TextEditingController qsController = TextEditingController();
  TextEditingController hecController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  String? nameError;
  String? qsRankingError;
  String? hecRankingError;
  String? imageError;

  String? phoneNumberError;

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

  void resetFields() {
    setState(() {
      imageUrl = null;
      namecontroller.clear();
      qsController.clear();
      hecController.clear();
      cityController.clear();
      phoneNumberController.clear();
      applyLinkController.clear();
      selectedAdmissionCriteria = null;
      provinceValue = null;
      sectorValue = null;
      hostelValue = null;
      sportsValue = null;
      coEducationValue = null;
      scholarshipValue = null;
      wifiValue = null;
      transportValue = null;
      nameError = null;
      qsRankingError = null;
      hecRankingError = null;
      imageError = null;
      phoneNumberError = null;
      // Clear fee controller values
      feeControllers.forEach((_, controller) {
        controller.clear();
      });

      cityControllers.forEach((controller) {
        controller.clear();
      });
      // Reset city controllers to one empty controller
      cityControllers = [TextEditingController()];
    });
  }

  void saveUniversity() async {
    setState(() {
      nameError = null;
      qsRankingError = null;
      hecRankingError = null;
      imageError = null;
      phoneNumberError = null;
    });

    // Ensure degrees and feeControllers are not null
    if (degrees.isNotEmpty && feeControllers.isNotEmpty) {
      // Retrieve input field values
      Map<String, String> degreeValues = {};
      degrees.forEach((degree) {
        degreeValues[degree] = feeControllers[degree]!.text;
      });
      String name = namecontroller.text;
      String qsRanking = qsController.text;
      String hecRanking = hecController.text;
      List<String> cityValues =
          cityControllers.map((controller) => controller.text).toList();
      String phoneNumber = phoneNumberController.text;
      String onlineApplyLink = applyLinkController.text;

      bool hasError = false;

      // Apply Boundary Value Analysis

      // Check Name field boundary values
      if (name.isEmpty) {
        setState(() {
          nameError = 'Error: Name cannot be empty';
        });
        hasError = true;
      } else if (name.length > 50) {
        setState(() {
          nameError = 'Error: Name cannot exceed 50 characters';
        });
        hasError = true;
      }

      // Check QS Ranking field boundary values
      if (qsRanking.isEmpty) {
        setState(() {
          qsRankingError = 'Error: QS Ranking cannot be empty';
        });
        hasError = true;
      } else if (qsRanking.length > 50) {
        setState(() {
          qsRankingError = 'Error: QS Ranking cannot exceed 50 characters';
        });
        hasError = true;
      }

      // Check HEC Ranking field boundary values
      if (hecRanking.isEmpty) {
        setState(() {
          hecRankingError = 'Error: HEC Ranking cannot be empty';
        });
        hasError = true;
      } else if (hecRanking.length > 50) {
        setState(() {
          hecRankingError = 'Error: HEC Ranking cannot exceed 50 characters';
        });
        hasError = true;
      }

      // Check Phone Number field boundary values
      if (phoneNumber.isEmpty) {
        setState(() {
          phoneNumberError = 'Error: Phone Number cannot be empty';
        });
        hasError = true;
      } else if (phoneNumber.length != 11 ||
          !RegExp(r'^\d{11}$').hasMatch(phoneNumber)) {
        setState(() {
          phoneNumberError = 'Error: Invalid Phone Number';
        });
        hasError = true;
      }

      // Check Image boundary values
      if (image == null) {
        setState(() {
          imageError = 'Error: Image cannot be null';
        });
        hasError = true;
      } else if (image!.lengthInBytes > 10 * 1024 * 1024) {
        setState(() {
          imageError = 'Error: Image cannot exceed 10 MB';
        });
        hasError = true;
      }

      if (!hasError) {
        // Upload image to Firebase Storage
        String imagePath =
            'images/universities/${DateTime.now().millisecondsSinceEpoch}.jpg';
        String imageUrl =
            await StoreData().uploadImageToFirebase(imagePath, image!);

        // Save university data to Firestore and get the universityId
        String universityId = await StoreData().saveData(
            name: name,
            imageUrl: imageUrl,
            onlineApplyLink: onlineApplyLink,
            phoneNumber: phoneNumber,
            hecRanking: hecRanking,
            qsRanking: qsRanking,
            provinceValue: provinceValue!,
            sectorValue: sectorValue!,
            hostelValue: hostelValue!,
            sportsValue: sportsValue!,
            coEducationValue: coEducationValue!,
            scholarshipValue: scholarshipValue!,
            admissionCriteriaValue: selectedAdmissionCriteria!,
            cityValues: cityValues,
            wifiValue: wifiValue!,
            degreeValues: degreeValues,
            transportValue: transportValue!,
            categories: selectedCategories);

        // Show result
        print('University Saved with ID: $universityId');

        // Now you can use the universityId to save degree data
        String degreeSaveResult =
            await StoreData().saveDegreeData(universityId, degrees);
        print('Degree Save Result: $degreeSaveResult');

        resetFields();
      }
    } else {
      print('Error: Degrees or feeControllers is empty');
    }
  }

  void addCityField() {
    setState(() {
      cityControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => pickImage(ImageSource.gallery),
                          child: image == null
                              ? CircleAvatar(
                                  radius: 70,
                                  backgroundColor: Colors.grey[200],
                                  backgroundImage: imageUrl != null
                                      ? NetworkImage(imageUrl!)
                                      : null,
                                  child: imageUrl == null
                                      ? Icon(
                                          Icons.camera_alt,
                                          size: 50,
                                          color: Colors.grey[800],
                                        )
                                      : null,
                                )
                              : CircleAvatar(
                                  radius: 70,
                                  backgroundImage: MemoryImage(image!),
                                ),
                        ),
                        if (imageError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              imageError!,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: UMSizes.spaceBtwInputFields),
                  Text(
                    "University Name",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .apply(color: UMColors.black, fontSizeDelta: 4),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: namecontroller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter University Name",
                      ),
                    ),
                  ),
                  if (nameError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        nameError!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  const SizedBox(height: UMSizes.spaceBtwInputFields),
                  Text(
                    "QS Ranking",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .apply(color: UMColors.black, fontSizeDelta: 4),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: qsController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter QS Ranking",
                      ),
                    ),
                  ),
                  if (qsRankingError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        qsRankingError!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  const SizedBox(height: UMSizes.spaceBtwInputFields),
                  Text("HEC Ranking",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: UMColors.black, fontSizeDelta: 4)),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: hecController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter HEC Ranking",
                      ),
                    ),
                  ),
                  if (hecRankingError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        hecRankingError!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  const SizedBox(height: UMSizes.spaceBtwInputFields),
                  Text(
                    "Apply Link",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .apply(color: UMColors.black, fontSizeDelta: 4),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: applyLinkController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Apply link",
                      ),
                    ),
                  ),
                  const SizedBox(height: UMSizes.spaceBtwInputFields),
                  Text(
                    "Cities",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .apply(color: UMColors.black, fontSizeDelta: 4),
                  ),
                  const SizedBox(height: 10.0),
                  Column(
                    children: cityControllers.map((controller) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter City",
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: UMSizes.spaceBtwInputFields),
                  ElevatedButton(
                    onPressed: addCityField,
                    child: const Text(
                      "Add Another City",
                      style: TextStyle(color: UMColors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: UMColors.primary,
                    ),
                  ),
                  const SizedBox(height: UMSizes.spaceBtwInputFields),
                  Text(
                    "Phone Number",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .apply(color: UMColors.black, fontSizeDelta: 4),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        errorText: phoneNumberError,
                      ),
                    ),
                  ),
                  const SizedBox(height: UMSizes.spaceBtwInputFields),
                  Text(
                    "Admission Criteria",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(color: UMColors.black, fontSizeDelta: 4),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        items: admissionCriteria.map((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedAdmissionCriteria = value;
                          });
                        },
                        value: selectedAdmissionCriteria,
                        hint: const Text("Select Admission Criteria"),
                        iconSize: 36,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        dropdownColor: Colors.white,
                      ),
                    ),
                  ),
                  Text("Select Province",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: UMColors.black, fontSizeDelta: 4)),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                      items: province
                          .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                              )))
                          .toList(),
                      onChanged: ((value) => setState(() {
                            provinceValue = value;
                          })),
                      dropdownColor: Colors.white,
                      hint: const Text("Select Province"),
                      iconSize: 36,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      value: provinceValue,
                    )),
                  ),
                  const SizedBox(height: UMSizes.spaceBtwInputFields),
                  Text("Select Sector",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: UMColors.black, fontSizeDelta: 4)),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                      items: sector
                          .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                              )))
                          .toList(),
                      onChanged: ((value) => setState(() {
                            sectorValue = value;
                          })),
                      dropdownColor: Colors.white,
                      hint: const Text("Select Sector"),
                      iconSize: 36,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      value: sectorValue,
                    )),
                  ),
                  const SizedBox(height: UMSizes.spaceBtwInputFields),
                  Text("Hostel Facility",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: UMColors.black, fontSizeDelta: 4)),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                      items: choose
                          .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                              )))
                          .toList(),
                      onChanged: ((value) => setState(() {
                            hostelValue = value;
                          })),
                      dropdownColor: Colors.white,
                      hint: const Text("Hostel Facility"),
                      iconSize: 36,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      value: hostelValue,
                    )),
                  ),
                  const SizedBox(height: UMSizes.spaceBtwInputFields),
                  Text("Transport Facility",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: UMColors.black, fontSizeDelta: 4)),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                      items: choose
                          .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                              )))
                          .toList(),
                      onChanged: ((value) => setState(() {
                            transportValue = value;
                          })),
                      dropdownColor: Colors.white,
                      hint: const Text("Transport Facility"),
                      iconSize: 36,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      value: transportValue,
                    )),
                  ),
                  const SizedBox(height: UMSizes.spaceBtwInputFields),
                  Text("WiFi",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: UMColors.black, fontSizeDelta: 4)),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                      items: choose
                          .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                              )))
                          .toList(),
                      onChanged: ((value) => setState(() {
                            wifiValue = value;
                          })),
                      dropdownColor: Colors.white,
                      hint: const Text("WiFi"),
                      iconSize: 36,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      value: wifiValue,
                    )),
                  ),
                  const SizedBox(height: UMSizes.spaceBtwInputFields),
                  Text("Sports Quota",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: UMColors.black, fontSizeDelta: 4)),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                      items: choose
                          .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                              )))
                          .toList(),
                      onChanged: ((value) => setState(() {
                            sportsValue = value;
                          })),
                      dropdownColor: Colors.white,
                      hint: const Text("Sports Quota"),
                      iconSize: 36,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      value: sportsValue,
                    )),
                  ),
                  const SizedBox(height: UMSizes.spaceBtwInputFields),
                  Text("Co-Education",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: UMColors.black, fontSizeDelta: 4)),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                      items: choose
                          .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                              )))
                          .toList(),
                      onChanged: ((value) => setState(() {
                            coEducationValue = value;
                          })),
                      dropdownColor: Colors.white,
                      hint: const Text("Co-Education"),
                      iconSize: 36,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      value: coEducationValue,
                    )),
                  ),
                  const SizedBox(height: UMSizes.spaceBtwInputFields),
                  Text("Provide Scholarship",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: UMColors.black, fontSizeDelta: 4)),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                      items: choose
                          .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                              )))
                          .toList(),
                      onChanged: ((value) => setState(() {
                            scholarshipValue = value;
                          })),
                      dropdownColor: Colors.white,
                      hint: const Text("Provide Scholarship"),
                      iconSize: 36,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      value: scholarshipValue,
                    )),
                  ),
                  const SizedBox(height: UMSizes.spaceBtwInputFields),
                  Text("Categories",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .apply(color: UMColors.black, fontSizeDelta: 4)),
                  const SizedBox(height: 10.0),
                  Wrap(
                    spacing: 8.0,
                    children: categories.map((category) {
                      return FilterChip(
                        label: Text(category),
                        selected: selectedCategories.contains(category),
                        onSelected: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              selectedCategories.add(category);
                            } else {
                              selectedCategories.remove(category);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: UMSizes.spaceBtwInputFields),
                  Text(
                    "Add University",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(color: UMColors.black, fontSizeDelta: 7),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: newDegreeController,
                    decoration: InputDecoration(
                      labelText: 'Add New Degree',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: addDegree,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    "Add Fee Structure",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(color: UMColors.black, fontSizeDelta: 7),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (String degree in degrees)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            '  $degree', // Add leading space
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width:
                                              8.0, // Spacing between degree and field
                                        ),
                                        // Fixed-width input field
                                        SizedBox(
                                          width: 200.0,
                                          height: 28,
                                          // Adjust width as needed
                                          child: TextField(
                                            controller: feeControllers[degree],
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              labelText:
                                                  '', // Remove label text
                                              border: OutlineInputBorder(),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                vertical: 12.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  GestureDetector(
                    onTap: saveUniversity,
                    child: Center(
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          width: 150,
                          decoration: BoxDecoration(
                            color: UMColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
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
      ),
    );
  }
}
