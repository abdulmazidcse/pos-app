import 'package:flutter/material.dart';
import 'package:pos/Pos/CartItem.dart';
import 'package:pos/Pos/CartProvider.dart';
import 'package:pos/Pos/ProductModel.dart';
import 'package:pos/Pos/ProductController.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../utils/Drawer.dart';
import 'package:auto_size_text/auto_size_text.dart';

class PosPage extends StatefulWidget {
  const PosPage({Key? key}) : super(key: key);

  @override
  PosPageState createState() => PosPageState();
}

class PosPageState extends State<PosPage> {
  final TextEditingController _fieldTextEditingController =
      TextEditingController();
  final FocusNode _fieldFocusNode = FocusNode();
  bool _selectedOption = false;
  List<Product> _filteredProducts = [];

  @override
  void dispose() {
    _fieldTextEditingController.dispose();
    _fieldFocusNode.dispose();
    super.dispose();
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    if (barcodeScanRes.isNotEmpty && barcodeScanRes.length >= 3) {
      var productsData =
          await ProductController().fetchProducts(barcodeScanRes);
      if (productsData.isNotEmpty) {
        _addToCart(productsData[0]);
      }
    }
  }

  void _filterProducts(String searchTerm) async {
    if (searchTerm.isNotEmpty && searchTerm.length >= 3) {
      var productsData = await ProductController().fetchProducts(searchTerm);
      setState(() {
        _filteredProducts = productsData
            .where((product) => product.productName
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        _filteredProducts = [];
      });
    }
  }

  void _addToCart(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.productName} added to cart'),
        duration: const Duration(seconds: 2),
      ),
    );
    Provider.of<CartProvider>(context, listen: false).addToCart(product);
    setState(() {
      _filteredProducts = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCartItems = Provider.of<CartProvider>(context).cartItems;
    double screenHeight = MediaQuery.of(context).size.height;
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
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              children: [
                _buildCustomAutocompleteField(),
                SizedBox(
                  height: screenHeight -
                      220, // Adjust the height based on header and footer
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 5.0),
                    itemCount: selectedCartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = selectedCartItems[index];
                      return _buildCartItem(cartItem);
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_filteredProducts.isNotEmpty)
            Positioned(
              top: 60, // Adjust this value based on your layout
              left: 16,
              right: 16,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  height: 200, // Adjust the height as needed
                  child: ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_filteredProducts[index].productName),
                        onTap: () {
                          _addToCart(_filteredProducts[index]);
                          _fieldTextEditingController.clear();
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAutocompleteField() {
    return TextField(
      controller: _fieldTextEditingController,
      focusNode: _fieldFocusNode,
      onChanged: (value) => _filterProducts(value),
      decoration: InputDecoration(
        hintText: 'Search Products...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.barcode_reader),
          onPressed: scanBarcodeNormal,
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItem cartItem) {
    return Dismissible(
      key: Key(cartItem.product.productId.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: const Color.fromARGB(255, 251, 174, 169),
        child: const Icon(Icons.delete),
      ),
      onDismissed: (direction) {
        Provider.of<CartProvider>(context, listen: false)
            .removeCartItem(cartItem);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black26,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 11,
              child: Container(
                padding: const EdgeInsets.only(left: 8),
                color: Colors.black12,
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      'Name: ${cartItem.product.productName}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 40,
                      width: 100,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            final newPrice = double.tryParse(value) ?? 0;
                            cartItem.product.newPrice = newPrice;
                            Provider.of<CartProvider>(context, listen: false)
                                .updateCartItemPrice(cartItem, newPrice);
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          hintText: 'Enter price',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.only(right: 8),
                color: Colors.black12,
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildQuantityControl(Icons.remove, Colors.red, () {
                          if (cartItem.qty > 0) {
                            setState(() {
                              cartItem.qty--;
                              Provider.of<CartProvider>(context, listen: false)
                                  .updateCartItemQuantity(
                                      cartItem, cartItem.qty);
                            });
                          }
                        }),
                        const SizedBox(width: 5),
                        Text(
                          'Qty: ${cartItem.qty}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 5),
                        _buildQuantityControl(Icons.add, Colors.green, () {
                          setState(() {
                            cartItem.qty++;
                            Provider.of<CartProvider>(context, listen: false)
                                .updateCartItemQuantity(cartItem, cartItem.qty);
                          });
                        }),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Subtotal: ${cartItem.subtotal.toString()}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControl(
      IconData icon, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color),
        ),
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: color, size: 9),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      color: Colors.white.withOpacity(0.4),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Text(
                'Net Amount: ${cartProvider.netAmount.toString()}',
                style: const TextStyle(fontSize: 14, color: Colors.black),
              );
            },
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Submit Order'),
          ),
        ],
      ),
    );
  }
}
