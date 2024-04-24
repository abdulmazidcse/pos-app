import 'package:flutter/material.dart';
import 'Login/login.dart';
import 'HomePage/HomePage.dart';

void main() {
  runApp(MyApp(false));
}

class MyApp extends StatelessWidget {
  bool isUserLogin;
  MyApp(this.isUserLogin);

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
