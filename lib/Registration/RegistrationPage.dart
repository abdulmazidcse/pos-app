import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../HomePage/HomePage.dart';
import '../Auth/Login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/Helper.dart';
import '../utils/Api.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<RegistrationPage> {
  Helper helper = Helper(); // Create an instance of the Helper class
  String email = '';
  String name = '';
  String phoneNumber = '';
  String password = '';
  String confirmPassword = '';
  String last8Digits = '';

  void initState() {
    super.initState();
  }

  bool checkAuth() {
    bool checkName = false;
    bool checkEmail = false;
    bool checkPhoneNumber = false;
    bool checkPassword = false;
    bool checkConPassword = false;
    if (name != '') {
      checkName = true;
    }
    if (email != '') {
      checkEmail = true;
    }

    if (phoneNumber != '') {
      checkPhoneNumber = true;
    }
    if (password != '') {
      checkPassword = true;
    }
    if (confirmPassword != '') {
      checkConPassword = true;
    }
    if (password == confirmPassword) {
      checkPassword = true;
    }
    if (checkEmail &&
        checkName &&
        checkPhoneNumber &&
        checkPassword &&
        checkConPassword) {
      return true;
    } else {
      helper.errorToast('Username & Password required field');
      return false;
    }
  }

  void registerUser() async {
    if (phoneNumber.length > 0) {
      last8Digits = phoneNumber.substring(phoneNumber.length - 8);
    }
    var user = {
      'name': name,
      'user_code': last8Digits,
      'phone': phoneNumber,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword
    };

    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    try {
      var response = await http.post(
        Uri.parse('http://192.168.31.135:8000/api/auth/register'),
        headers: headers,
        body: jsonEncode(user),
      );

      if (response.statusCode == 200) {
        // Successful registration
        var responseData = jsonDecode(response.body);
        // Handle success, for example showing a success message
        print(responseData['message']);
      } else {
        // Registration failed
        var responseData = jsonDecode(response.body);
        // Handle failure, for example showing an error message
        print(responseData['message']);
      }
    } catch (e) {
      // Error occurred during registration
      print('Error: $e');
      // Handle error, for example showing an error message
    }
  }

  void login() {
    bool isLoggedIn = checkAuth();
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text('Invalid username or password.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
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
            decoration: BoxDecoration(
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
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: new AutoSizeText(
                          'Registration Page ff',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Name',
                        hintStyle: TextStyle(color: Colors.black),
                        icon: Icon(Icons.person, color: Colors.black),
                      ),
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.black),
                        icon: Icon(Icons.email, color: Colors.black),
                      ),
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(color: Colors.black),
                        icon: Icon(Icons.phone, color: Colors.black),
                      ),
                      onChanged: (value) {
                        setState(() {
                          phoneNumber = value;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
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
                    SizedBox(height: 20.0),
                    TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(color: Colors.black),
                        icon: Icon(Icons.lock, color: Colors.black),
                      ),
                      onChanged: (value) {
                        setState(() {
                          confirmPassword = value;
                        });
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 10.0)),
                          ElevatedButton(
                            child: Text(
                              'Registration',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.white),
                            ),
                            onPressed: registerUser,
                            style: ElevatedButton.styleFrom(
                                elevation: 9.0,
                                primary: Colors.green,
                                fixedSize: const Size(300, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(75))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                        padding: EdgeInsets.all(20),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LogIn()),
                            );
                          },
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "Already Member ? Login..",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ))
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
