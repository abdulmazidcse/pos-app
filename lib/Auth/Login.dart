import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pos/HomePage/HomePage.dart';
import 'package:pos/Auth/RegistrationPage.dart';
import 'package:pos/Auth/ForgetPassword.dart';
import 'package:pos/utils/Api.dart';
import 'package:pos/utils/Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final borderRadius = BorderRadius.circular(75);
  bool _isLoading = false;
  String username = '';
  String password = '';
  bool checkInternet = false;

  Helper helper = Helper(); // Create an instance of the Helper class

  @override
  initState() {
    super.initState();
    checkInternetConnection();
  }

  checkInternetConnection() async {
    var interNet = await helper.checkConnectivity();
    if (interNet) {
      setState(() {
        checkInternet = true;
      });
    } else {
      setState(() {
        checkInternet = false;
      });
    }
  }

  storeUserDataAndToken(Map<String, dynamic> body) async {
    var user = body['data']['user'];
    var token = body['data']['access_token'];
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    localStorage.setString('user_id', user['id'].toString());
    localStorage.setString('user', json.encode(user));
    localStorage.setString('token', token);
  }

  fetchData(data) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    var res = await Api().login(data, 'auth/login');
    setState(() {
      _isLoading = false; // Hide loading indicator
    });
    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      storeUserDataAndToken(body);
    } else {
      helper.validationToast(true, 'Invalid username or password');
    }
  }

  checkAuth() async {
    var isLoggedIn = '';
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    isLoggedIn = localStorage.getString('token').toString();
    if ((isLoggedIn == 'null') || (isLoggedIn.isEmpty)) {
      return false; // User is logged in
    } else {
      return true; // User is not logged in
    }
  }

  handleLoginButtonPress() async {
    checkInternetConnection();
    if (!checkInternet) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Internet Connection')),
      );
    } else {
      bool isLoggedIn = false;
      if ((username == '') || (password == '')) {
        helper.validationToast(true, 'Username & Password required field');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username & Password required field')),
        );
      } else {
        var data = {'email': username, 'password': password};
        await fetchData(data);
        isLoggedIn = await checkAuth();
      }

      if (isLoggedIn) {
        helper.successToast('Login Success');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/imageedit.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Glassy login card
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          child: const AutoSizeText(
                            'Welcome to IMS Software',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.black),
                          icon: Icon(Icons.email, color: Colors.black),
                        ),
                        onChanged: (value) {
                          setState(() {
                            username = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.black),
                          icon: Icon(Icons.lock, color: Colors.black),
                        ),
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        obscureText: true,
                      ),
                      const SizedBox(height: 20.0),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Padding(padding: EdgeInsets.only(top: 10.0)),
                            _isLoading // Check the _isLoading flag
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: handleLoginButtonPress,
                                    style: ElevatedButton.styleFrom(
                                      elevation: 9.0,
                                      backgroundColor: Colors.green,
                                      fixedSize: const Size(200, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgetPassword(),
                                ),
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Not a Member?',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
