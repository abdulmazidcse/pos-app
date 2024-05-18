import 'package:flutter/material.dart';
import 'package:pos/HomePage/HomePage.dart';
import 'package:pos/Pos/PosPage.dart';
import 'package:pos/Products/ProductPage.dart';
import 'package:pos/Products/ProductList.dart';
import 'package:pos/Auth/Login.dart';
import 'package:pos/utils/Api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);
  @override
  MyDrawerState createState() => MyDrawerState();
}

class MyDrawerState extends State<MyDrawer> {
  dynamic userName = '';
  dynamic userEmail = '';
  dynamic userId = '';
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    userData(); // Call userData in initState
  }

  void userData() async {
    final userInfo = await Api().userInfo();
    var decodeInfo = jsonDecode(userInfo);
    if (decodeInfo != null) {
      setState(() {
        userName = decodeInfo['name'];
        userEmail = decodeInfo['email'];
        userId = decodeInfo['id'];
        isLogin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              userName,
              style: const TextStyle(
                fontSize: 15.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              userEmail,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background_image.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text("Home"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }),
          const SizedBox(height: 10.0),
          ListTile(
            leading: const Icon(Icons.production_quantity_limits),
            title: const Text("POS"),
            onTap: () async {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => PosPage()));
            },
          ),
          const SizedBox(height: 10.0),
          ListTile(
            leading: const Icon(Icons.production_quantity_limits),
            title: const Text("Products List"),
            onTap: () async {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const ProductList()));
            },
          ),
          const SizedBox(height: 10.0),
          ListTile(
            leading: const Icon(Icons.production_quantity_limits),
            title: const Text("Create Products"),
            onTap: () async {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ProductPage()));
            },
          ),
          const SizedBox(height: 10.0),
          ListTile(
            leading: const Icon(Icons.logout),
            title: isLogin ? const Text("Logout") : const Text('Login'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const Login(),
              ));
            },
          )
        ],
      ),
    );
  }
}
