import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'HomePage/HomePage.dart';
import 'Pos/CartProvider.dart';
import 'package:pos/Login/login.dart';
import 'Pos/PosPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkAuth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Or any loading indicator
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            bool isUserLogin = snapshot.data!;
            var defaultRoot = isUserLogin ? HomePage() : LogIn();

            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => CartProvider()),
              ],
              child: MaterialApp(
                title: 'My App',
                debugShowCheckedModeBanner: false,
                home: defaultRoot, // Assuming HomePage is your initial screen
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
              ),
            );
          }
        }
      },
    );
  }

  Future<bool> checkAuth() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var isLoggedIn = localStorage.getString('token') ?? '';
    return isLoggedIn.isNotEmpty;
  }
}
