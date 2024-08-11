import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';
import 'package:unimatcher_admin/dashboard/dashboard.dart';
import 'package:unimatcher_admin/utils/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLogin extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFededeb),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2,
                  ),
                  padding: const EdgeInsets.only(
                    top: 45.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 53, 51, 51),
                        UMColors.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.elliptical(
                        MediaQuery.of(context).size.width,
                        110.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 30.0, right: 30.0, top: 60.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          "Let's start with\nAdmin!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2.2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(height: 50.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: TextFormField(
                                        controller: usernameController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Enter Username';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          hintText: "Username",
                                          prefixIcon: Icon(Iconsax.user),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 40.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: TextFormField(
                                      controller: passwordController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please Enter Password';
                                        }
                                        return null;
                                      },
                                      obscureText: true,
                                      onEditingComplete: () =>
                                          loginAdmin(context),
                                      decoration: const InputDecoration(
                                        hintText: "Password",
                                        prefixIcon: Icon(Icons.lock),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
                                  GestureDetector(
                                    onTap: () => loginAdmin(context),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 1.0),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: UMColors.primary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "LogIn",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
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
                      ],
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

  void loginAdmin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance.collection("Admin").get();
        bool isAdminFound = false;

        for (QueryDocumentSnapshot result in snapshot.docs) {
          var data = result.data()
              as Map<String, dynamic>?; // Safely cast to Map<String, dynamic>
          if (data != null &&
              data['id'] == usernameController.text.trim() &&
              data['password'] == passwordController.text.trim()) {
            String adminId = result.id; // Firebase-generated ID

            // Save admin ID in SharedPreferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('adminId', adminId);

            isAdminFound = true;
            Get.offAll(() => DashboardScreen(
                adminId: adminId)); // Pass the ID to DashboardScreen
            return;
          }
        }

        if (!isAdminFound) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Your id or password is not correct",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "An error occurred: $e",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
        print("Error logging in: $e");
      }
    }
  }
}
