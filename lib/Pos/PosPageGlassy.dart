import 'package:flutter/material.dart';
import 'package:pos/Pos/CartProvider.dart';
import 'package:pos/Pos/ProductModel.dart';
import 'package:pos/Pos/ProductController.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../utils/Drawer.dart';
import '../utils/Helper.dart';

class PosPageGlassy extends StatefulWidget {
  @override
  _PosPageGlassyState createState() => _PosPageGlassyState();
}

class _PosPageGlassyState extends State<PosPageGlassy> {
  Helper helper = Helper(); // Create an instance of the Helper class
  List<Product> _filteredProducts = [];
  String productCode = '';
  bool? _selectedOption = false;

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    if (barcodeScanRes.isEmpty) {
      _filteredProducts = [];
    } else if (barcodeScanRes.length >= 3) {
      dynamic productsData =
          await ProductController().fetchProducts(barcodeScanRes);
      if (productsData.length > 0) {
        _addToCartAndClearResults(productsData[0]);
        Provider.of<CartProvider>(context, listen: false)
            .addToCart(productsData[0]);
      }
    }
  }

  void _filterProducts(String searchTerm) async {
    if (searchTerm.isEmpty) {
      _filteredProducts = [];
    } else if (searchTerm.length >= 3) {
      final productsData = await ProductController().fetchProducts(searchTerm);
      _filteredProducts = productsData
          .where((product) => product.productName
              .toLowerCase()
              .contains(searchTerm.toLowerCase()))
          .toList();
    }
    setState(() {}); // Update UI with filtered products
  }

  void _addToCartAndClearResults(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.productName} added to cart'),
        duration: Duration(seconds: 2),
      ),
    );
    setState(() {
      _filteredProducts = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCartItems = Provider.of<CartProvider>(context).cartItems;

    return Scaffold(
        drawer: MyDrawer(),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/imageedit.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: new AutoSizeText(
                          'This is Home Page',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0)
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  return Text(
                    'Net Amount: ${cartProvider.netAmount.toString()}',
                    style: TextStyle(fontSize: 14, color: Colors.transparent),
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  print('Order submitted! Net amount: Tk  ');
                },
                child: Text('Submit Order'),
              ),
            ],
          ),
        ));
  }
}
