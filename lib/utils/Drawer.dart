import 'package:flutter/material.dart';
import 'package:pos/HomePage/HomePage.dart';
import 'package:pos/Pos/PosPage.dart';
import 'package:pos/Products/ProductPage.dart';

class MyDrawer extends StatelessWidget {
  // Use a named class for clarity
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              "Pos",
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              "smd.tanjib@gmail.com",
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://appmaking.co/wp-content/uploads/2021/08/appmaking-logo-colored.png"),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://appmaking.co/wp-content/uploads/2021/08/android-drawer-bg.jpeg",
                ),
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
          SizedBox(height: 100.0),
          ListTile(
            leading: Icon(Icons.production_quantity_limits),
            title: Text("Logout"),
            onTap: () async {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ProductPage()));
            },
          ),
        ],
      ),
    );
  }
}
