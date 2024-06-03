import 'package:flutter/material.dart';
import 'package:pos/utils/Api.dart';
import 'dart:convert';

import 'package:pos/utils/Drawer.dart';
import 'package:pos/utils/Helper.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  Helper helper = Helper(); // Create an instance of the Helper class
  bool _isLoading = false;

  final borderRadius = BorderRadius.circular(10);

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  // String _otpChannel = 'Email';

  _changePassword() async {
    setState(() {
      _isLoading = true; // Hide loading indicator
    });
    if (_formKey.currentState!.validate()) {
      var data = {
        'current_password': _currentPasswordController.text,
        'new_password': _newPasswordController.text,
        'new_password_confirmation': _confirmPasswordController.text,
        // 'otp_channel': _otpChannel,
      };

      final response = await Api().postData(data, 'auth/change-password');

      if (response.statusCode == 200) {
        helper.successToast('Password changed successfully');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Customer created successfully')),
        // );
        setState(() {
          _isLoading = false; // Show loading indicator
        });
      } else {
        if (response.statusCode == 422) {
          final responseData = json.decode(response.body);
          dynamic newPassError = '';
          if (responseData['new_password'] != null) {
            newPassError = responseData['new_password'][0];
          }

          dynamic currentPassError = '';
          if (responseData['current_password'] != null) {
            currentPassError = responseData['current_password'][0];
          }

          if (newPassError != '') {
            helper.validationToast(true, newPassError);
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text(newPassError)),
            // );
          }

          if (currentPassError != '') {
            helper.validationToast(true, currentPassError);
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text(currentPassError)),
            // );
          }

          setState(() {
            _isLoading = false; // Show loading indicator
          });
        }
      }
    } else {
      setState(() {
        _isLoading = false; // Show loading indicator
      });
      helper.validationToast(true, 'Something is wrong!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: true, // This adds the back button
        title: const Text('Change Login Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPasswordField('Old Password*', _currentPasswordController),
              _buildPasswordField('New Password*', _newPasswordController),
              _buildPasswordField(
                  'Retype New Password*', _confirmPasswordController),
              const SizedBox(height: 16),
              // const Text(
              //   'OTP Channel:',
              //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              // ),
              // Row(
              //   children: [
              //     _buildRadioButton('Email', 'Email'),
              //     _buildRadioButton('SMS', 'SMS'),
              //     _buildRadioButton('Both', 'Both'),
              //   ],
              // ),
              const SizedBox(height: 16),
              Center(
                child: _isLoading // Check the _isLoading flag
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _changePassword,
                        style: ElevatedButton.styleFrom(
                          elevation: 9.0,
                          backgroundColor: Colors.green,
                          fixedSize: const Size(300, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: borderRadius,
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
              ),
              const SizedBox(height: 16),
              const Text(
                'Notes:',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              ..._buildNotes(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }

  // Widget _buildRadioButton(String label, String value) {
  //   return Row(
  //     children: [
  //       Radio<String>(
  //         value: value,
  //         groupValue: _otpChannel,
  //         onChanged: (String? newValue) {
  //           setState(() {
  //             _otpChannel = newValue!;
  //           });
  //         },
  //         activeColor: Colors.red,
  //       ),
  //       Text(label),
  //     ],
  //   );
  // }

  List<Widget> _buildNotes() {
    return [
      _buildNoteText('1. Please do not use any of your last four passwords.'),
      _buildNoteText('2. Must contain at least 1 character(s) of a-z'),
      _buildNoteText('3. Must contain at least 1 character(s) of A-Z'),
      _buildNoteText('4. Must contain at least 1 character(s) of 0-9'),
      _buildNoteText(
          '5. Must contain at least one special character. [Allowed character(s) is(are): @#!*\$&%]'),
      _buildNoteText(
          '6. Password minimum length is 8 characters and maximum length is 12'),
    ];
  }

  Widget _buildNoteText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.red),
      ),
    );
  }
}
