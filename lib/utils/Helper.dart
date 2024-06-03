import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Helper {
  dialogBox(context, title, msg) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? 'Failed'),
        content: Text(msg ?? 'Invalid'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
      // barrierColor: const Color.fromARGB(255, 207, 207, 207),
    );
  }

  validationToast(isSet, errMessage) {
    Fluttertoast.showToast(
        msg: isSet ? errMessage : 'An error occurred',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  errorToast(errMessage) {
    Fluttertoast.showToast(
        msg: errMessage ? errMessage : 'An error occurred',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  successToast(msg) {
    Fluttertoast.showToast(
        msg: msg ?? 'Success!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xFFDDFFDD),
        textColor: Colors.black,
        fontSize: 16.0);
  }

  Widget btn(bool _isLoading, VoidCallback createProduct) {
    return Container(
      child: _isLoading
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: createProduct,
              style: ElevatedButton.styleFrom(
                elevation: 9.0,
                backgroundColor: Colors.green,
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(75),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}
