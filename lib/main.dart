import 'package:flutter/material.dart';
import 'Login/login.dart';
import 'HomePage/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // MyApp myApp = MyApp(false);
  // bool isUserLoggedIn = myApp.checkAuth();
  runApp(MyApp(false));
}

class MyApp extends StatelessWidget {
  bool isUserLogin;
  MyApp(this.isUserLogin);

  checkAuth() async {
    var isLoggedIn = '';
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    isLoggedIn = localStorage.getString('token').toString();
    if ((isLoggedIn == 'null') || (isLoggedIn.isEmpty)) {
      return isUserLogin = false; // User is logged in
    } else {
      return isUserLogin = true; // User is not logged in
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var defaultRoot = isUserLogin ? HomePage() : LogIn();

    final material = MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: defaultRoot,
    );
    return material;
  }
}
