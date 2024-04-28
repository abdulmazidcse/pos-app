import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Login/Login.dart';
import '../Products/ProductPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Pos",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text("smd.tanjib@gmail.com",
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
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }
            ),
            ListTile(
              leading: Icon(Icons.grid_3x3_outlined),
              title: Text("Products"),
              onTap: () async {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ProductPage()));
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/imageedit.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),



          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: new AutoSizeText(
                          'This is Home Page',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    // ElevatedButton(
                    //   child: Text(
                    //     'Logout',
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 13,
                    //         color: Colors.white),
                    //   ),
                    //   onPressed: () async {
                    //     SharedPreferences prefs =
                    //         await SharedPreferences.getInstance();
                    //     await prefs.clear();
                    //     Navigator.of(context).pushReplacement(
                    //         MaterialPageRoute(builder: (context) => LogIn()));
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //       elevation: 9.0,
                    //       primary: Colors.green,
                    //       fixedSize: const Size(300, 50),
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(75))),
                    // ),
                    // SizedBox(height: 20.0),
                    // ElevatedButton(
                    //   child: Text(
                    //     'Products',
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 13,
                    //         color: Colors.white),
                    //   ),
                    //   onPressed: () async {
                    //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //         builder: (context) => ProductPage()));
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //       elevation: 9.0,
                    //       primary: Colors.green,
                    //       fixedSize: const Size(300, 50),
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(75))),
                    // ),
                    // SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
