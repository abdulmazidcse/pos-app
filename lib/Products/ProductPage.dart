import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../utils/Api.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../utils/Helper.dart';
import '../utils/Drawer.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Helper helper = Helper(); // Create an instance of the Helper class
  bool _isLoading = false;

  // get productCodeController => null;
  final TextEditingController productCodeController = TextEditingController();
  void initState() {
    super.initState();
    userData();
  }

  String productName = '';
  String productCode = '';
  double costPrice = 0;
  double mrpPrice = 0;
  int companyId = 0;
  int outletId = 0;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      productCode = barcodeScanRes;
      productCodeController.text = barcodeScanRes;
    });
  }

  void userData() async {
    final userInfo = await Api().userInfo();
    var decodeInfo = jsonDecode(userInfo);
    if (decodeInfo != null) {
      setState(() {
        companyId = decodeInfo['company_id'];
        outletId = decodeInfo['outlet_id'];
      });
    }
  }

  createProduct() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    final String apiUrl = 'products';
    var product = {
      'product_type': 'standard',
      'product_name': productName,
      'product_native_name': productName,
      'product_code': productCode,
      'category_id': 8,
      'sub_category_id': 9,
      'cost_price': costPrice,
      'mrp_price': mrpPrice,
      'min_order_qty': 1,
      'tax_method': 1,
      'product_tax': 1,
      'company_id': companyId,
      'outlet_id': outletId,
    };
    final response = await Api().postData(product, apiUrl);

    if (response.statusCode == 200) {
      helper.successToast('Product created successfully');
      setState(() {
        _isLoading = false; // Show loading indicator
      });
    } else {
      if (response.statusCode == 422) {
        final responseData = json.decode(response.body);
        final errors = responseData['errors'];
        String productNameError =
            errors['product_name'] != null ? errors['product_name'][0] : '';
        String productNativeNameError = errors['product_native_name'] != null
            ? errors['product_native_name'][0]
            : '';
        String productCodeError =
            errors['product_code'] != null ? errors['product_code'][0] : '';
        if (productNameError != '') {
          helper.validationToast(true, productNameError);
        }
        if (productNativeNameError != '') {
          helper.validationToast(true, productNativeNameError);
        }
        if (productCodeError != '') {
          helper.validationToast(true, productCodeError);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
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
                          'Create Product',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () => scanBarcodeNormal(),
                        child: Text('Start barcode scan')),
                    SizedBox(height: 20.0),
                    TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Product Name',
                        hintStyle: TextStyle(color: Colors.black),
                        icon: Icon(Icons.email, color: Colors.black),
                      ),
                      onChanged: (value) {
                        setState(() {
                          productName = value;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      controller: productCodeController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Product Code',
                        hintStyle: TextStyle(color: Colors.black),
                        icon: Icon(Icons.barcode_reader, color: Colors.black),
                      ),
                      onChanged: (value) {
                        setState(() {
                          productCode = value;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Cost Price',
                        hintStyle: TextStyle(color: Colors.black),
                        icon: Icon(Icons.price_check, color: Colors.black),
                      ),
                      onChanged: (value) {
                        setState(() {
                          costPrice = double.parse(value);
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Sale Price',
                        hintStyle: TextStyle(color: Colors.black),
                        icon: Icon(Icons.price_check, color: Colors.black),
                      ),
                      onChanged: (value) {
                        setState(() {
                          mrpPrice = double.parse(value);
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: 10.0)),
                          _isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.white),
                                  ),
                                  onPressed: createProduct,
                                  style: ElevatedButton.styleFrom(
                                      elevation: 9.0,
                                      backgroundColor: Colors.green,
                                      fixedSize: const Size(300, 50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(75))),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
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
