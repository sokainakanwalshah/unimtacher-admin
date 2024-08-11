import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unimatcher_admin/dashboard/Dashboard%20cards/userStats.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> getUsersCount() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('Users').get();
      return querySnapshot.size;
    } catch (e) {
      print('Error fetching users count: $e');
      return 0;
    }
  }

  Future<List<UserData>> getUsersRegisteredLast20Days() async {
    try {
      DateTime today = DateTime.now();
      DateTime startDate = today.subtract(Duration(days: 20));

      // Fetch users from Firestore
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();

      List<UserData> users = [];
      querySnapshot.docs.forEach((doc) {
        DateTime registrationDate =
            DateTime.parse(doc.id); // Convert document ID to DateTime
        if (registrationDate.isAfter(startDate)) {
          users.add(UserData(registrationDate.toString(), 1));
        }
      });

      return users;
    } catch (error) {
      // Handle errors
      print('Error fetching users: $error');
      return [];
    }
  }

  Future<Map<String, int>> getUserRegistrationSources() async {
    try {
      // Simulate random registration sources and their counts
      Map<String, int> registrationSources = {
        'Direct Sign-up': Random().nextInt(100),
        'Sign-up with Google': Random().nextInt(100),
        'Sign-up with Facebook': Random().nextInt(100),
        'Sign-up with Apple': Random().nextInt(100),
        // Add more registration sources here if needed
      };

      return registrationSources;
    } catch (error) {
      // Handle errors
      print('Error fetching user registration sources: $error');
      return {}; // Return an empty map if an error occurs
    }
  }
}
