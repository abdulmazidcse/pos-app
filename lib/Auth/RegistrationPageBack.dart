import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pos/utils/Api.dart'; // Assuming this contains your API configuration
import 'package:pos/utils/Helper.dart'; // Assuming this provides utility functions
import '../Auth/Login.dart';
import 'dart:convert';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});
  @override
  RegistrationState createState() => RegistrationState();
}

class RegistrationState extends State<RegistrationPage> {
  bool _isLoading = false;
  String _name = '';
  String _email = '';
  String _phone = ''; // Optional
  String _password = '';
  String _confirmPassword = '';
  dynamic last8Digits = '';

  Helper helper = Helper(); // Helper instance

  @override
  void initState() {
    super.initState();
  }

  void registerUser() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    if ((_phone != '') && (_phone.isNotEmpty)) {
      last8Digits = _phone.substring(_phone.length - 8);
    }

    var user = {
      'name': _name,
      'user_code': last8Digits, // Set userCode if generated on server
      'phone': _phone, // Include if required by your API
      'email': _email,
      'password': _password,
      'password_confirmation': _confirmPassword,
    };

    try {
      var response = await http.post(
          Uri.parse(
              '${Api.url}auth/register'), // Replace with your API endpoint
          body: jsonEncode(user),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          });
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        helper.successToast(responseData['message']);
        setState(() {
          _isLoading = false;
        });
        navigateToLogin();
      } else if (response.statusCode == 422) {
        final responseData = json.decode(response.body);
        List<String> errors = [];

        if (responseData.containsKey('name') && responseData['name'] != '') {
          errors.add(responseData['name'][0]);
        }

        if (responseData.containsKey('email') && responseData['email'] != '') {
          errors.add(responseData['email'][0]);
        }

        if (responseData.containsKey('phone') && responseData['phone'] != '') {
          errors.add(responseData['phone'][0]);
        }

        if (responseData.containsKey('password') &&
            responseData['password'] != '') {
          errors.add(responseData['password'][0]);
        }

        if (errors.isNotEmpty) {
          String allErrors =
              errors.join('\n'); // Combine errors with line breaks
          helper.validationToast(true, allErrors);
        }
        setState(() {
          _isLoading = false;
        });
      }
    } finally {}
  }

  validationFass(isError) {
    if (isError) {
      return false;
    } else {
      return true;
    }
  }

  void navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const Login()), // Navigate to login page
    );
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
          Expanded(
            child: Center(
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
                            'Registration Page',
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
                          hintText: 'Name',
                          hintStyle: TextStyle(color: Colors.black),
                          icon: Icon(Icons.person, color: Colors.black),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                        },
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
                            _email = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Phone Number',
                          hintStyle: TextStyle(color: Colors.black),
                          icon: Icon(Icons.phone, color: Colors.black),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _phone = value;
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
                            _password = value;
                          });
                        },
                        obscureText: true,
                      ),
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
                            _confirmPassword = value;
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
                                    onPressed: registerUser,
                                    style: ElevatedButton.styleFrom(
                                        elevation: 9.0,
                                        backgroundColor: Colors.green,
                                        fixedSize: const Size(300, 50),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(75))),
                                    child: const Text(
                                      'Registration',
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
                      Container(
                          padding: const EdgeInsets.all(20),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                              );
                            },
                            child: const Align(
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
          ),
        ],
      ),
    );
  }
}
