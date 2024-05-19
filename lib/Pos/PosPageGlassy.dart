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
  const PosPageGlassy({Key? key}) : super(key: key);
  @override
  PosPageGlassyState createState() => PosPageGlassyState();
}

class PosPageGlassyState extends State<PosPageGlassy> {
  Helper helper = Helper(); // Create an instance of the Helper class
  String productCode = '';

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

  void _addToCartAndClearResults(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.productName} added to cart'),
        duration: const Duration(seconds: 2),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MyDrawer(),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/imageedit.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child: const AutoSizeText(
                        'This is Home Page',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0)
                ],
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
                    style: const TextStyle(
                        fontSize: 14, color: Colors.transparent),
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Submit Order'),
              ),
            ],
          ),
        ));
  }
}
