import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pos/HomePage/HomePage.dart';
import 'package:pos/Auth/Login.dart';
import 'package:pos/utils/Api.dart';
import 'package:pos/utils/Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);
  @override
  ForgetPasswordState createState() => ForgetPasswordState();
}

class ForgetPasswordState extends State<ForgetPassword> {
  bool _isLoading = false;
  String username = '';
  String password = '';

  Helper helper = Helper(); // Create an instance of the Helper class
  @override
  void initState() {
    super.initState();
  }

  void storeUserDataAndToken(Map<String, dynamic> body) async {
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
      helper.errorToast('Invalid username or password');
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

  void login() async {
    bool isLoggedIn = false;
    if ((username == '') || (password == '')) {
      helper.errorToast('Username & Password required field');
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
                    const TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.black),
                        icon: Icon(Icons.email, color: Colors.black),
                      ),
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
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      elevation: 9.0,
                                      backgroundColor: Colors.green,
                                      fixedSize: const Size(300, 50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(75))),
                                  child: const Text(
                                    'Submit',
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
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                        child: const Text(
                          'Login?',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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
