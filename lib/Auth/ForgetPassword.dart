import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pos/Auth/SetNewPassword.dart';
import 'package:pos/Auth/Login.dart';
import 'package:pos/utils/Api.dart';
import 'package:pos/utils/Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});
  @override
  ForgetPasswordState createState() => ForgetPasswordState();
}

class ForgetPasswordState extends State<ForgetPassword> {
  bool _isLoading = false;
  String email = '';
  bool checkInternet = false;

  Helper helper = Helper(); // Create an instance of the Helper class

  @override
  void initState() {
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

  void storeUserDataAndToken(Map<String, dynamic> body) async {
    var user = body['email'];
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('forget_password_user', user);
  }

  fetchData(context, data) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    checkInternetConnection();
    if (!checkInternet) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Internet Connection')),
      );
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    } else {
      var res = await Api().postData(data, 'auth/send-otp');
      // var body = json.decode(res.body);
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
      if (res.statusCode == 200) {
        dynamic body = data;
        storeUserDataAndToken(body);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SetNewPassword()),
        );
      } else {
        // helper.validationToast(true, 'Given data is invalid');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Given data is invalid')),
        );
      }
    }
  }

  void _handleSubmit(context) async {
    if (email == '') {
      helper.validationToast(true, 'Field is required');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Field is required')),
      );
    } else {
      var data = {'email': email};
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
                            'Forget Password Page',
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
                            email = value;
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
