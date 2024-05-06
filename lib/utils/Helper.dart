import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';

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
            child: Text('OK'),
          ),
        ],
      ),
      // barrierColor: const Color.fromARGB(255, 207, 207, 207),
    );
  }

  errorToast(msg) {
    Fluttertoast.showToast(
        msg: msg ?? 'An error occurred',
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
        backgroundColor: Color(0xFFDDFFDD),
        textColor: Colors.black,
        fontSize: 16.0);
  }

  printArrayOrObject(dynamic data) {
    if (data is List) {
      debugPrint('List:');
      data.forEach((element) => debugPrint(element.toString()));
    } else if (data is Map) {
      debugPrint('Map:');
      data.forEach((key, value) => debugPrint('$key: $value'));
    } else {
      debugPrint(data.toString());
    }
  }
}
