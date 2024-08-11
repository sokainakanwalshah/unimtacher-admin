import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unimatcher_admin/utils/constants/colors.dart';

import '../utils/constants/sizes.dart';

class EditUniversityScreen extends StatefulWidget {
  final DocumentSnapshot uni;
  final VoidCallback? onClose;

  EditUniversityScreen({required this.uni, this.onClose});

  @override
  _EditUniversityScreenState createState() => _EditUniversityScreenState();
}

class _EditUniversityScreenState extends State<EditUniversityScreen> {
  final List<String> admissionCriteria = [
    '40%-50%',
    '60%-70%',
    '80%-85%',
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
  TextEditingController categoryController = TextEditingController();
  String? selectedAdmissionCriteria;
  String? provinceValue;
  String? sectorValue;
  String? hostelValue;
  String? sportsValue;
  String? coEducationValue;
  String? scholarshipValue;

  final List<String> sector = ['Public', 'Private'];
  final List<String> province = [
    'Punjab',
    'KPK',
    'Balochistan',
    'Sindh',
    'Gilgit Baltistan'
  ];
  final List<String> choose = ['Yes', 'No'];
  Uint8List? image;
  TextEditingController nameController = TextEditingController();
  TextEditingController qsController = TextEditingController();
  TextEditingController hecController = TextEditingController();
  List<TextEditingController> cityControllers = [];
  Map<String, TextEditingController> feeControllers = {};

  final List<String> degrees = [
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
  TextEditingController newDegreeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.uni['Name'];
    qsController.text = widget.uni['QSRanking'];
    hecController.text = widget.uni['HECRanking'];
    List<dynamic> cityList = widget.uni['Cities'];
    for (String city in cityList) {
      cityControllers.add(TextEditingController(text: city));
    }
    // Initialize other fields if needed
    provinceValue = widget.uni['provinceValue'];
    sectorValue = widget.uni['sectorValue'];
    hostelValue = widget.uni['hostelValue'];
    sportsValue = widget.uni['sportsValue'];
    coEducationValue = widget.uni['coEducationValue'];
    scholarshipValue = widget.uni['scholarshipValue'];
    selectedAdmissionCriteria = widget.uni['AdmissionCriteria'];
    selectedCategories = List<String>.from(widget.uni['Categories']);
    for (String degree in degrees) {
      feeControllers[degree] =
          TextEditingController(text: widget.uni['degreeValues'][degree]);
    }
  }

  Future<void> updateUniversity(Map<String, dynamic> updatedData) async {
    await widget.uni.reference.update(updatedData);
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    final XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      final Uint8List img = await _file.readAsBytes();
      setState(() {
        image = img;
      });
    }
  }

  Future<void> saveUniversity() async {
    final String name = nameController.text;
    final String qsRanking = qsController.text;
    final String hecRanking = hecController.text;
    final List<String> cityValues =
        cityControllers.map((controller) => controller.text).toList();

    if (name.isNotEmpty &&
        qsRanking.isNotEmpty &&
        hecRanking.isNotEmpty &&
        cityValues.isNotEmpty) {
      try {
        Map<String, String> degreeValues = {};
        degrees.forEach((degree) {
          degreeValues[degree] = feeControllers[degree]!.text;
        });

        await updateUniversity({
          'Name': name,
          'QSRanking': qsRanking,
          'HECRanking': hecRanking,
          'cityValues': cityValues,
          'provinceValue': provinceValue,
          'sectorValue': sectorValue,
          'hostelValue': hostelValue,
          'sportsValue': sportsValue,
          'coEducationValue': coEducationValue,
          'scholarshipValue': scholarshipValue,
          'AdmissionCriteria': selectedAdmissionCriteria!,
          'degreeValues': degreeValues,
          'Categories': selectedCategories,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('University updated successfully')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update university')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the fields')),
      );
    }
  }

  void addCityField() {
    setState(() {
      cityControllers.add(TextEditingController());
    });
  }

  void addDegree() {
    setState(() {
      final newDegree = newDegreeController.text.trim();
      if (newDegree.isNotEmpty && !degrees.contains(newDegree)) {
        degrees.add(newDegree);
        feeControllers[newDegree] = TextEditingController();
        newDegreeController.clear();
      }
    });
  }

  void addCategory() {
    setState(() {
      final category = categoryController.text.trim();
      if (category.isNotEmpty && !categories.contains(category)) {
        categories.add(category);
        categoryController.clear();
      }
    });
  }

  void removeCategory(String category) {
    setState(() {
      categories.remove(category);
      selectedCategories.remove(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit University'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (widget.onClose != null) {
                widget.onClose!();
              }
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 800),
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  padding: EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'University Picture',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10.0),
                            Center(
                              child: Stack(
                                children: [
                                  image != null
                                      ? CircleAvatar(
                                          radius: 64,
                                          backgroundImage: MemoryImage(image!),
                                        )
                                      : CircleAvatar(
                                          radius: 64,
                                          // Use NetworkImage if image is stored in Firebase Storage
                                          // backgroundImage: NetworkImage(selectedImageUrl),
                                          child: Icon(Icons.school),
                                        ),
                                  Positioned(
                                    bottom: -10,
                                    left: 80,
                                    child: IconButton(
                                      icon: Icon(Icons.add_a_photo),
                                      onPressed: () {
                                        pickImage(ImageSource.gallery);
                                      },
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
                                  .apply(
                                      color: UMColors.black, fontSizeDelta: 3),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter University Name",
                                ),
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              "QS Ranking",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .apply(
                                      color: UMColors.black, fontSizeDelta: 3),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: qsController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter QS Ranking",
                                ),
                              ),
                            ),
                            const SizedBox(height: UMSizes.spaceBtwInputFields),
                            Text("HEC Ranking",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .apply(
                                        color: UMColors.black,
                                        fontSizeDelta: 3)),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextField(
                                controller: hecController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter HEC Ranking",
                                ),
                              ),
                            ),
                            const SizedBox(height: UMSizes.spaceBtwInputFields),
                            Text(
                              "Admission Criteria",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .apply(
                                      color: UMColors.black, fontSizeDelta: 3),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
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
                                        style: TextStyle(
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
                                  hint: Text("Select Admission Criteria"),
                                  iconSize: 36,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  dropdownColor: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: UMSizes.spaceBtwInputFields),
                            Text(
                              "City",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .apply(
                                      color: UMColors.black, fontSizeDelta: 3),
                            ),
                            SizedBox(height: 30.0),
                            Column(
                              children: cityControllers.map((controller) {
                                return Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  margin: EdgeInsets.only(bottom: 10.0),
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
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    controller: controller,
                                    decoration: InputDecoration(
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
                            Text("Select Province",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .apply(
                                        color: UMColors.black,
                                        fontSizeDelta: 3)),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Color(0xFFececf8),
                                  borderRadius: BorderRadius.circular(10)),
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                items: province
                                    .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black),
                                        )))
                                    .toList(),
                                onChanged: ((value) => setState(() {
                                      provinceValue = value;
                                    })),
                                dropdownColor: Colors.white,
                                hint: Text("Select Province"),
                                iconSize: 36,
                                icon: Icon(
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
                                    .apply(
                                        color: UMColors.black,
                                        fontSizeDelta: 3)),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
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
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black),
                                        )))
                                    .toList(),
                                onChanged: ((value) => setState(() {
                                      sectorValue = value;
                                    })),
                                dropdownColor: Colors.white,
                                hint: Text("Select Sector"),
                                iconSize: 36,
                                icon: Icon(
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
                                    .apply(
                                        color: UMColors.black,
                                        fontSizeDelta: 3)),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
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
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black),
                                        )))
                                    .toList(),
                                onChanged: ((value) => setState(() {
                                      hostelValue = value;
                                    })),
                                dropdownColor: Colors.white,
                                hint: Text("Hostel Facility"),
                                iconSize: 36,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                                value: hostelValue,
                              )),
                            ),
                            const SizedBox(height: UMSizes.spaceBtwInputFields),
                            Text("Sports Quota",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .apply(
                                        color: UMColors.black,
                                        fontSizeDelta: 3)),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
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
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black),
                                        )))
                                    .toList(),
                                onChanged: ((value) => setState(() {
                                      sportsValue = value;
                                    })),
                                dropdownColor: Colors.white,
                                hint: Text("Sports Quota"),
                                iconSize: 36,
                                icon: Icon(
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
                                    .apply(
                                        color: UMColors.black,
                                        fontSizeDelta: 3)),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
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
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black),
                                        )))
                                    .toList(),
                                onChanged: ((value) => setState(() {
                                      coEducationValue = value;
                                    })),
                                dropdownColor: Colors.white,
                                hint: Text("Co-Education"),
                                iconSize: 36,
                                icon: Icon(
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
                                    .apply(
                                        color: UMColors.black,
                                        fontSizeDelta: 3)),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
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
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black),
                                        )))
                                    .toList(),
                                onChanged: ((value) => setState(() {
                                      scholarshipValue = value;
                                    })),
                                dropdownColor: Colors.white,
                                hint: Text("Provide Scholarship"),
                                iconSize: 36,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                                value: scholarshipValue,
                              )),
                            ),
                            Text(
                              "Categories",
                              style:
                                  Theme.of(context).textTheme.bodyText1!.apply(
                                        color: UMColors.black,
                                        fontSizeDelta: 4,
                                      ),
                            ),
                            const SizedBox(height: 10.0),
                            TextField(
                              controller: categoryController,
                              decoration: InputDecoration(
                                labelText: "Add Category",
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: addCategory,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Wrap(
                              spacing: 8.0,
                              children: categories.map((category) {
                                return FilterChip(
                                  label: Text(category),
                                  selected:
                                      selectedCategories.contains(category),
                                  onSelected: (isSelected) {
                                    setState(() {
                                      if (isSelected) {
                                        selectedCategories.add(category);
                                      } else {
                                        selectedCategories.remove(category);
                                      }
                                    });
                                  },
                                  onDeleted: () => removeCategory(category),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: UMSizes.spaceBtwInputFields),
                            SizedBox(height: 20.0),
                            Text(
                              "Add Fee Structure",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .apply(
                                      color: UMColors.black, fontSizeDelta: 4),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (String degree in degrees)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      '  $degree',
                                                      style: const TextStyle(
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 8.0,
                                                  ),
                                                  SizedBox(
                                                    width: 200.0,
                                                    height: 28,
                                                    child: TextField(
                                                      controller:
                                                          feeControllers[
                                                              degree],
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText: '',
                                                        border:
                                                            OutlineInputBorder(),
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
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
                                  SizedBox(height: 10.0),
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
                                  SizedBox(height: 30.0),
                                  GestureDetector(
                                    onTap: saveUniversity,
                                    child: Center(
                                      child: Material(
                                        elevation: 5.0,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          width: 150,
                                          decoration: BoxDecoration(
                                            color: UMColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )));
  }
}
