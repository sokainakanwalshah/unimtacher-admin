import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unimatcher_admin/admin_login.dart';
import 'package:unimatcher_admin/dashboard/dashboard.dart';
import 'package:unimatcher_admin/univerities_data/alluniveritiesData.dart';
import 'package:unimatcher_admin/utils/constants/colors.dart';
import 'package:unimatcher_admin/study_material/study_material.dart';
import 'package:unimatcher_admin/admin_chat-screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'UniMatcher Admin Panel',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<String?>(
        future: _getSavedAdminId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: UMColors.primary,
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data != null) {
            return DashboardScreen(adminId: snapshot.data!);
          } else {
            return AdminLogin();
          }
        },
      ),
    );
  }

  Future<String?> _getSavedAdminId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('adminId');
  }
}

// flutter run -d chrome --web-hostname localhost --web-port 5050
