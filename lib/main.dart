import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'HomePage/HomePage.dart';
import 'Pos/CartProvider.dart';
import 'package:pos/Auth/Login.dart';
// import 'Pos/PosPage.dart';
// import 'Pos/PosPageGlassy.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // const WidgetsFlutterBinding.ensureInitialized();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkAuth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Or any loading indicator
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            bool isUserLogin = snapshot.data!;
            var myPageWidget = isUserLogin ? const HomePage() : const Login();

            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => CartProvider()),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/imageedit.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: myPageWidget,
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
