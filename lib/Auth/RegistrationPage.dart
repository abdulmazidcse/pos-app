import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pos/utils/Api.dart';
import 'package:pos/utils/Helper.dart';
import 'dart:convert';
import 'Login.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  bool _isLoading = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  dynamic last8Digits = '';
  bool checkInternet = false;

  Helper helper = Helper(); // Helper instance

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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

  registerUser() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    if ((_phoneController.text != '') && (_phoneController.text.isNotEmpty)) {
      last8Digits =
          _phoneController.text.substring(_phoneController.text.length - 8);
    }

    var user = {
      'name': _nameController.text,
      'user_code': last8Digits, // Set userCode if generated on server
      'phone': _phoneController.text, // Include if required by your API
      'email': _emailController.text,
      'password': _passwordController.text,
      'password_confirmation': _confirmPasswordController.text,
    };

    try {
      checkInternetConnection();
      if (!checkInternet) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No Internet Connection')),
        );
      } else {
        var response = await Api().postData(user, 'auth/register');

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          helper.successToast(responseData['message']);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
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

          if (responseData.containsKey('email') &&
              responseData['email'] != '') {
            errors.add(responseData['email'][0]);
          }

          if (responseData.containsKey('phone') &&
              responseData['phone'] != '') {
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(allErrors)),
            );
          }
          setState(() {
            _isLoading = false;
          });
        } else {
          // print(response.toString());
        }
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                        controller: _nameController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Name',
                          hintStyle: TextStyle(color: Colors.black),
                          icon: Icon(Icons.person, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.black),
                          icon: Icon(Icons.email, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: _phoneController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Phone Number',
                          hintStyle: TextStyle(color: Colors.black),
                          icon: Icon(Icons.phone, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: _passwordController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.black),
                          icon: Icon(Icons.lock, color: Colors.black),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: _confirmPasswordController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(color: Colors.black),
                          icon: Icon(Icons.lock, color: Colors.black),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20.0),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: registerUser,
                              style: ElevatedButton.styleFrom(
                                elevation: 9.0,
                                backgroundColor: Colors.green,
                                fixedSize: const Size(200, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                'Registration',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                      const SizedBox(height: 20.0),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                          );
                        },
                        child: const Text(
                          "Already Member ? Login..",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
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
