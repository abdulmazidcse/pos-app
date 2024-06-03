import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../utils/Api.dart';
import '../utils/Helper.dart';
import '../utils/Drawer.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({Key? key}) : super(key: key);
  @override
  CustomerPageState createState() => CustomerPageState();
}

class CustomerPageState extends State<CustomerPage> {
  Helper helper = Helper(); // Create an instance of the Helper class
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    userData();
  }

  String customerName = '';
  String customerCode = '';
  dynamic phoneNumber = '';
  dynamic address = '';
  int companyId = 0;

  void userData() async {
    final userInfo = await Api().userInfo();
    var decodeInfo = jsonDecode(userInfo);
    if (decodeInfo != null) {
      setState(() {
        companyId = decodeInfo['company_id'];
      });
    }
  }

  createProduct() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    const String apiUrl = 'customers';
    var customer = {
      'name': customerName,
      'customer_code': customerCode,
      'phone': phoneNumber,
      'address': address,
      'customer_group_id': 1,
      'company_id': companyId,
      'discount_percent': 0,
      'customer_receivable_account': 0,
    };
    final response = await Api().postData(customer, apiUrl);

    if (response.statusCode == 200) {
      helper.successToast('Customer created successfully');
      setState(() {
        _isLoading = false; // Show loading indicator
      });
    } else {
      if (response.statusCode == 422) {
        final responseData = json.decode(response.body);
        final errors = responseData['errors'];
        String customerCodeError =
            errors['customer_code'] != null ? errors['customer_code'][0] : '';
        String customerNameError =
            errors['name'] != null ? errors['name'][0] : '';
        String customerPhoneError =
            errors['phone'] != null ? errors['phone'][0] : '';
        String customerAddressError =
            errors['address'] != null ? errors['address'][0] : '';
        if (customerNameError != '') {
          helper.validationToast(true, customerNameError);
        }
        if (customerPhoneError != '') {
          helper.validationToast(true, customerPhoneError);
        }
        if (customerCodeError != '') {
          helper.validationToast(true, customerCodeError);
        }
        if (customerAddressError != '') {
          helper.validationToast(true, customerAddressError);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Create Customer'),
        backgroundColor: Colors.transparent,
        elevation: 90, // Removes the shadow
      ),
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
                          'Create Customer Account',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'Customer Name',
                        hintStyle: TextStyle(color: Colors.black),
                        icon: Icon(Icons.person, color: Colors.black),
                      ),
                      onChanged: (value) {
                        setState(() {
                          customerName = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'Customer Code',
                        hintStyle: TextStyle(color: Colors.black),
                        icon: Icon(Icons.qr_code, color: Colors.black),
                      ),
                      onChanged: (value) {
                        setState(() {
                          customerCode = value;
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
                          phoneNumber = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: 'Address',
                        hintStyle: TextStyle(color: Colors.black),
                        icon: Icon(Icons.home, color: Colors.black),
                      ),
                      onChanged: (value) {
                        setState(() {
                          address = double.parse(value);
                        });
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Padding(padding: EdgeInsets.only(top: 10.0)),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: createProduct,
                                  style: ElevatedButton.styleFrom(
                                      elevation: 9.0,
                                      backgroundColor: Colors.green,
                                      fixedSize: const Size(300, 50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(75))),
                                  child: const Text(
                                    'Save',
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
