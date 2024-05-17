import 'package:flutter/material.dart';
import 'package:pos/HomePage/HomePage.dart';
import 'package:pos/Pos/PosPage.dart';
import 'package:pos/Products/ProductPage.dart';
import 'package:pos/Auth/login.dart';
import 'package:pos/utils/Api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  dynamic userName = '';
  dynamic userEmail = '';
  dynamic userId = '';
  bool isLogin = false;

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
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              userEmail,
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background_image.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListTile(
              leading: Icon(Icons.home_outlined),
              title: Text("Home"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }),
          SizedBox(height: 10.0),
          ListTile(
            leading: Icon(Icons.production_quantity_limits),
            title: Text("POS"),
            onTap: () async {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => PosPage()));
            },
          ),
          SizedBox(height: 10.0),
          ListTile(
            leading: Icon(Icons.production_quantity_limits),
            title: Text("Products List"),
            onTap: () async {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ProductPage()));
            },
          ),
          SizedBox(height: 10.0),
          ListTile(
            leading: Icon(Icons.production_quantity_limits),
            title: Text("Create Products"),
            onTap: () async {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ProductPage()));
            },
          ),
          SizedBox(height: 10.0),
          ListTile(
            leading: Icon(Icons.logout),
            title: isLogin ? Text("Logout") : Text('Login'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LogIn(),
              ));
            },
          )
        ],
      ),
    );
  }
}
