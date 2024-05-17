import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pos/Auth/Login.dart';
import 'package:pos/Auth/RegistrationPage.dart';
import 'package:pos/Products/ProductPage.dart';
import 'package:pos/HomePage/HomePage.dart';
import 'package:pos/Pos/PosPage.dart';
import 'package:pos/Pos/PosPageGlassy.dart';

void navigateToSettings(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => HomePage()),
  );
}

class ManuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LogIn(),
                ));
              },
              style: ElevatedButton.styleFrom(
                elevation: 9.0,
                primary: Colors.green,
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(75),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text(
                'Products',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ProductPage(),
                ));
              },
              style: ElevatedButton.styleFrom(
                elevation: 9.0,
                primary: Colors.green,
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(75),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text(
                'Pos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => PosPage(),
                ));
              },
              style: ElevatedButton.styleFrom(
                elevation: 9.0,
                primary: Colors.green,
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(75),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text(
                'Pos Page 2',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => PosPageGlassy(),
                ));
              },
              style: ElevatedButton.styleFrom(
                elevation: 9.0,
                primary: Colors.green,
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(75),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text(
                'RegistrationPage',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => RegistrationPage(),
                ));
              },
              style: ElevatedButton.styleFrom(
                elevation: 9.0,
                primary: Colors.green,
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(75),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text(
                'Login Page',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LogIn(),
                ));
              },
              style: ElevatedButton.styleFrom(
                elevation: 9.0,
                primary: Colors.green,
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(75),
                ),
              ),
            ),
            SizedBox(height: 20.0)
          ],
        ),
      ),
    );
  }
}
