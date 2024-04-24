import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../HomePage/HomePage.dart';
import '../Login/Login.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<RegistrationPage> {
  String username = '';
  String password = '';
  String confirm_password = '';

  void initState() {
    super.initState();
  }

  bool checkAuth() {
    bool checkUsername = false;
    bool checkPassword = false;
    bool checkConPassword = false;
    if (username != '') {
      checkUsername = true;
    }
    if (password != '') {
      checkPassword = true;
    }
    if (checkConPassword != '') {
      checkConPassword = true;
    }
    if (password == confirm_password) {
      checkPassword = true;
    }
    if (checkUsername && checkPassword && checkConPassword) {
      return true;
    } else {
      return false;
    }
  }

  void login() {
    // Call your authentication service to verify the credentials
    // For example:
    bool isLoggedIn = checkAuth();

    // bool isLoggedIn = true; // Dummy value for demonstration
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Handle failed login
      // For example, show an error message
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
                          'Registration Page',
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
                          confirm_password = value;
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
                              'Sign In',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.white),
                            ),
                            onPressed: login,
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
