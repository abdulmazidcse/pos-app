import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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

  Future<bool> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult[0] != ConnectivityResult.none;
  }

  noItemFound() {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //   AssetImage('assets/images/imageedit.jpg')
                    const SizedBox(height: 16),
                    Image.asset(
                      'assets/images/no-item-found.png',
                      height: 200,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your item is empty',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // checkConnectivity() async {
  //   dynamic connectivityResult = await Connectivity().checkConnectivity();
  //   if (connectivityResult[0] == ConnectivityResult.none) {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

  Widget btn(bool isLoading, VoidCallback createProduct) {
    return Container(
      child: isLoading
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
