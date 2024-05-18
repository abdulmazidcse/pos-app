import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pos/Auth/Login.dart';
import 'package:pos/Auth/RegistrationPage.dart';
import 'package:pos/Products/ProductPage.dart';
import 'package:pos/Products/ProductList.dart';
import 'package:pos/HomePage/HomePage.dart';
import 'package:pos/Pos/PosPage.dart';
import 'package:pos/Pos/PosPageGlassy.dart';

class ManuPage extends StatelessWidget {
  const ManuPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
              },
              style: ElevatedButton.styleFrom(
                elevation: 9.0,
                backgroundColor: Colors.green,
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(75),
                ),
              ),
              child: const Text(
                'Home',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const Login(),
                ));
              },
              style: ElevatedButton.styleFrom(
                elevation: 9.0,
                backgroundColor: Colors.green,
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(75),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ProductPage(),
                ));
              },
              style: ElevatedButton.styleFrom(
                elevation: 9.0,
                backgroundColor: Colors.green,
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(75),
                ),
              ),
              child: const Text(
                'Product create',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const ProductList(),
                ));
              },
              style: ElevatedButton.styleFrom(
                elevation: 9.0,
                backgroundColor: Colors.green,
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(75),
                ),
              ),
              child: const Text(
                'Product list',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => PosPage(),
                ));
              },
              style: ElevatedButton.styleFrom(
                elevation: 9.0,
                backgroundColor: Colors.green,
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(75),
                ),
              ),
              child: const Text(
                'Pos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => PosPageGlassy(),
                ));
              },
              style: ElevatedButton.styleFrom(
                elevation: 9.0,
                backgroundColor: Colors.green,
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(75),
                ),
              ),
              child: const Text(
                'Pos Page 2',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const RegistrationPage(),
                ));
              },
              style: ElevatedButton.styleFrom(
                elevation: 9.0,
                backgroundColor: Colors.green,
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(75),
                ),
              ),
              child: const Text(
                'RegistrationPage',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const Login(),
                ));
              },
              style: ElevatedButton.styleFrom(
                elevation: 9.0,
                backgroundColor: Colors.green,
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(75),
                ),
              ),
              child: const Text(
                'Login Page',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
