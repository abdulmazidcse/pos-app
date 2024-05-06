import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'HomePage/HomePage.dart';
import 'Pos/CartProvider.dart';
import 'package:pos/Login/login.dart';
import 'Pos/PosPage.dart';
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
      // setState(() {
      //   isUserLogin = true;
      // });
      return isUserLogin = true; // User is not logged in
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var defaultRoot = isUserLogin ? HomePage() : PosPage();

    final material = MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'My App',
        home: defaultRoot, // Assuming HomePage is your initial screen
      ),
    );
    return material;

    // final material = MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: defaultRoot,
    // );
    // return material;
  }
}
