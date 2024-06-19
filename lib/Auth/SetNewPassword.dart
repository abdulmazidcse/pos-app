import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
// import 'package:pos/HomePage/HomePage.dart';
import 'package:pos/Auth/Login.dart';
import 'package:pos/utils/Api.dart';
import 'package:pos/utils/Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({super.key});
  @override
  SetNewPasswordState createState() => SetNewPasswordState();
}

class SetNewPasswordState extends State<SetNewPassword> {
  bool _isLoading = false;
  dynamic email = '';
  String otp = '';
  String password = '';
  String passwordConfirmation = '';

  Helper helper = Helper(); // Create an instance of the Helper class
  @override
  void initState() {
    super.initState();
    localStorageData();
  }

  void localStorageData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    dynamic userEmail =
        localStorage.getString('forget_password_user').toString();
    if (userEmail != null) {
      setState(() {
        email = userEmail;
      });
    }
  }

  fetchData(context, data) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    var res = await Api().postData(data, 'auth/reset-password');
    var body = json.decode(res.body);
    setState(() {
      _isLoading = false; // Hide loading indicator
    });
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(body['message'])),
      );
      helper.successToast(body['message']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } else {
      helper.validationToast(true, body['message']);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(body['message'])),
      );
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

  void _handleSubmit(context) async {
    if ((otp == '') || (passwordConfirmation == '') || (password == '')) {
      helper.validationToast(true, 'Username & Password required field');
    } else {
      var data = {
        'email': email,
        'otp': otp,
        'password_confirmation': passwordConfirmation,
        'password': password
      };
      await fetchData(context, data);
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
                            'Reset Your Password',
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
                            hintText: 'OTP',
                            hintStyle: TextStyle(color: Colors.black),
                            icon: Icon(Icons.lock, color: Colors.black),
                          ),
                          onChanged: (value) {
                            setState(() {
                              otp = value;
                            });
                          }),
                      const SizedBox(height: 20.0),
                      TextField(
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            hintText: 'New Password',
                            hintStyle: TextStyle(color: Colors.black),
                            icon: Icon(Icons.lock, color: Colors.black),
                          ),
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          }),
                      const SizedBox(height: 20.0),
                      TextField(
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(color: Colors.black),
                          icon: Icon(Icons.lock, color: Colors.black),
                        ),
                        onChanged: (value) {
                          setState(() {
                            passwordConfirmation = value;
                          });
                        },
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
                                    onPressed: () {
                                      _handleSubmit(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 9.0,
                                      backgroundColor: Colors.green,
                                      fixedSize: const Size(200, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
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
          ),
        ],
      ),
    );
  }
}
