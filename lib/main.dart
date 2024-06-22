import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'HomePage/HomePage.dart';
import 'Pos/CartProvider.dart';
// import 'Auth/RegistrationPage.dart';
// import 'Pos/PosPage.dart';
// import 'Sales/SalesListPage.dart';
import 'Auth/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkAuth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Or any loading indicator
        } else {
          if (snapshot.hasError) {
            return MaterialApp(
              home: Scaffold(
                body: Center(child: Text('Error: ${snapshot.error}')),
              ),
            );
          } else {
            bool isUserLogin = snapshot.data ?? false;
            var myPageWidget = isUserLogin ? const HomePage() : const Login();

            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => CartProvider()),
                // ChangeNotifierProvider( create: (context) => DashboardController()),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/imageedit.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: myPageWidget,
                  ),
                ),
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
