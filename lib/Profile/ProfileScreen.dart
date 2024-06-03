import 'package:flutter/material.dart';
import 'package:pos/Profile/CompanyProfileScreen.dart';
import 'package:pos/Profile/OutletProfileScreen.dart';
import 'package:pos/profile/ChangePasswordScreen.dart';
import 'package:pos/profile/UserProfileScreen.dart';
import '../utils/Drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  ProfileScreenPageState createState() => ProfileScreenPageState();
}

class ProfileScreenPageState extends State<ProfileScreen> {
  // const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 90, // Removes the shadow
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildGridItem(context, Icons.person, 'User Profile',
                const UserProfileScreen()),
            _buildGridItem(context, Icons.vpn_key, 'Change Password',
                const ChangePasswordScreen()),
            _buildGridItem(context, Icons.storefront, 'Outlet Profile',
                const OutletProfileScreen()),
            _buildGridItem(context, Icons.store, 'Company Profile',
                const CompanyProfileScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(
      BuildContext context, IconData icon, String label, dynamic routeName) {
    return InkWell(
      onTap: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => routeName,
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.orange.withOpacity(0.2),
              child: Icon(icon, color: Colors.orange, size: 60),
            ),
            SizedBox(height: 10),
            Text(label,
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
