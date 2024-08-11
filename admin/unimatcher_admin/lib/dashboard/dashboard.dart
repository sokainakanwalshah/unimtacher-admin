import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:unimatcher_admin/admin_chat-screen.dart';
import 'package:unimatcher_admin/admin_login.dart';
import 'package:unimatcher_admin/dashboard/Dashboard%20cards/studyMaterial_Statics.dart';
import 'package:unimatcher_admin/dashboard/Dashboard%20cards/userStats.dart';
import 'package:unimatcher_admin/dashboard/Dashboard%20cards/universityStatis.dart';
import 'package:unimatcher_admin/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:unimatcher_admin/resources/admin_repo.dart';
import 'package:unimatcher_admin/study_material/study_material.dart';
import 'package:unimatcher_admin/univerities_data/alluniveritiesData.dart';
import 'package:unimatcher_admin/univerities_data/universities.dart';
import 'package:unimatcher_admin/utils/constants/colors.dart';
import 'package:unimatcher_admin/utils/constants/image_strings.dart';

class DashboardScreen extends StatefulWidget {
  final String adminId;

  DashboardScreen({required this.adminId});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedNavItem = 'Dashboard';
  late Map<String, dynamic> _adminDetails;

  @override
  void initState() {
    super.initState();
    _fetchAdminDetails();
  }

  void _fetchAdminDetails() {
    AdminRepository().getAdminDetails(widget.adminId).then((adminDetails) {
      setState(() {
        _adminDetails = adminDetails;
      });
    }).catchError((error) {
      // Handle error
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_adminDetails == null) {
      return CircularProgressIndicator();
    }

    return Scaffold(
      body: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              ),
              color: Colors.grey[100],
            ),
            child: NavigationMenu(
              onSelectItem: (item) {
                setState(() {
                  _selectedNavItem = item;
                });
              },
              adminId: widget.adminId, // Pass adminId to NavigationMenu
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                color: Colors.grey[100],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: DashboardContent(
                  selectedItem: _selectedNavItem,
                  adminId: widget.adminId, // Pass adminId to DashboardContent
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationMenu extends StatelessWidget {
  final Function(String) onSelectItem;
  final String adminId; // Add adminId parameter

  const NavigationMenu({
    Key? key,
    required this.onSelectItem,
    required this.adminId, // Initialize adminId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230.0,
      decoration: const BoxDecoration(
        color: UMColors.primary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          const ListTile(
            title: Center(
              child: Text(
                'Unimatcher',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: UMColors.white,
                ),
              ),
            ),
          ),
          NavItem(
            title: 'Dashboard',
            isSelected: false,
            onTap: () => onSelectItem('Dashboard'),
            adminId: adminId, // Pass adminId to NavItem
          ),
          NavItem(
            title: 'Universities',
            isSelected: false,
            onTap: () => Get.to(() => AllUniveritiesData()),
            adminId: adminId, // Pass adminId to NavItem
          ),
          NavItem(
            title: 'Study Material',
            isSelected: false,
            onTap: () => Get.to(() => StudyMaterialsScreen()),
            adminId: adminId, // Pass adminId to NavItem
          ),
          NavItem(
            title: 'Messages',
            isSelected: false,
            onTap: () => Get.to(() => AdminChatScreen()),
            adminId: adminId, // Pass adminId to NavItem
          ),
        ],
      ),
    );
  }
}

// Modify NavItem to accept adminId
class NavItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final void Function() onTap; // Change Function to void Function()

  const NavItem({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required String adminId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: UMColors.grey,
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(color: isSelected ? Colors.blue : Colors.black),
          ),
          onTap: onTap,
          selected: isSelected,
          selectedTileColor: Colors.blue.withOpacity(0.2),
        ),
      ),
    );
  }
}

// Modify DashboardContent to accept adminId
class DashboardContent extends StatelessWidget {
  final String selectedItem;
  final String adminId; // Add adminId parameter

  DashboardContent({
    Key? key,
    required this.selectedItem,
    required this.adminId, // Initialize adminId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdminRepository _adminRepository = AdminRepository();
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text(
                    'Welcome back,',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Map<String, dynamic> adminDetails =
                      await _adminRepository.getAdminDetails(adminId);
                  _showAdminDetailsDialog(context, adminDetails, adminId);
                },
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundImage: NetworkImage(
                    'https://www.google.com/url?sa=i&url=https%3A%2F%2Fin.pinterest.com%2Fpin%2Fadmin-vector-art-png-beautiful-admin-roles-line-vector-icon-line-icons-admin-icons-beautiful-icons-png-image-for-free-download--716494621973615879%2F&psig=AOvVaw26s5R6HrZ_Nw-TwPeRf3Qp&ust=1718120080497000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCJD11J2u0YYDFQAAAAAdAAAAABAE',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 5),
                  UserStatics(),
                  SizedBox(height: 5),
                  UniversityStatics(),
                  SizedBox(height: 5),
                  StudyMaterialStatics(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showAdminDetailsDialog(
    BuildContext context, Map<String, dynamic> adminDetails, String adminId) {
  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  final Offset offset = renderBox.localToGlobal(Offset.zero);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Admin Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Username: ${adminDetails['id']}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ), // Use the admin's username here

            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _logout(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: UMColors.primary,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Logout',
                    style: TextStyle(color: UMColors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showChangePasswordDialog(context, adminId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 223, 174, 14),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Change Password',
                    style: TextStyle(color: UMColors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}

void _logout(BuildContext context) {
  // Perform logout action here
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
        builder: (context) => AdminLogin()), // Navigate to your login screen
  );
}

void _showChangePasswordDialog(BuildContext context, String adminId) {
  String newPassword = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) {
                newPassword = value;
              },
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter New Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              // Call the repository method to change password
              bool success =
                  await AdminRepository().changePassword(adminId, newPassword);
              if (success) {
                // Password changed successfully
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Password changed successfully'),
                  duration: Duration(seconds: 2),
                ));
              } else {
                // Current password doesn't match
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Current password is incorrect'),
                  duration: Duration(seconds: 2),
                ));
              }
            },
            child: Text('Change', style: TextStyle(color: UMColors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: UMColors.primary,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      );
    },
  );
}

class DashboardCard extends StatelessWidget {
  final String title;

  const DashboardCard({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 205, 158, 4),
      elevation: 4.0,
      margin: const EdgeInsets.all(10.0),
      child: Container(
        // Wrap the child inside a Container
        width: double.infinity,
        height:
            200, // Make the width of the container to fill the available space
        padding: const EdgeInsets.all(
            20.0), // Add padding to increase the size of the card
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 24.0), // Increase the font size
          ),
        ),
      ),
    );
  }
}
