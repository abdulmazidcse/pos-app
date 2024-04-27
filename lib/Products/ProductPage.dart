import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../utils/Api.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String _scanBarcode = '';

  // get productCodeController => null;
  final TextEditingController productCodeController = TextEditingController();
  void initState() {
    super.initState();
  }

  String productName = '';
  String productCode = '';
  double costPrice = 0;
  double mrpPrice = 0;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      // print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      // _scanBarcode = barcodeScanRes;
      // productCode = barcodeScanRes;
      productCodeController.text = barcodeScanRes;
    });
  }

  createProduct() async {
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
    };
    final response = await Api().postData(product, apiUrl);

    if (response.statusCode == 200) {
      // Product created successfully
      print('Product created successfully');
    } else {
      // Error creating product
      print('Failed to create product. Error: ${response.statusCode}');
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
                          ElevatedButton(
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
                                    borderRadius: BorderRadius.circular(75))),
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
