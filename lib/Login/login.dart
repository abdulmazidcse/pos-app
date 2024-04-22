import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  void initState() {
    super.initState();
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
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.4),
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
                          'Welcome to IMS Software',
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
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white),
                        icon: Icon(Icons.email, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white),
                        icon: Icon(Icons.email, color: Colors.white),
                      ),
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
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                elevation: 9.0,
                                primary: Colors.green,
                                fixedSize: const Size(300, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(75))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                        padding: EdgeInsets.all(20),
                        child: InkWell(
                          onTap: () {},
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "Not a Member?",
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
