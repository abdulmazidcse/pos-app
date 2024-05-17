import 'package:flutter/material.dart';
import 'package:pos/Pos/CartProvider.dart';
import 'package:pos/Pos/ProductModel.dart';
import 'package:pos/Pos/ProductController.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../utils/Drawer.dart';
import '../utils/Helper.dart';

class PosPage extends StatefulWidget {
  @override
  _PosPageState createState() => _PosPageState();
}

class _PosPageState extends State<PosPage> {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  // Return an empty list when there's no text in the search field
                  return <String>[];
                } else if (textEditingValue.text.length >= 3) {
                  // Fetch products based on the search term
                  return ProductController()
                      .fetchProducts(textEditingValue.text)
                      .then((productsData) {
                    return productsData
                        .where((product) => product.productName
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()))
                        .map((product) => product.productName)
                        .toList();
                  });
                }
                return <String>[];
              },
              onSelected: (String selectedProduct) {
                dynamic selectedProductObj = _filteredProducts.firstWhere(
                  (product) => product?.productName == selectedProduct,
                );

                if (selectedProductObj != null) {
                  if (selectedProductObj.productCode.length > 0) {
                    _addToCartAndClearResults(selectedProductObj);
                    Provider.of<CartProvider>(context, listen: false)
                        .addToCart(selectedProductObj);
                  }
                  selectedProductObj = '';
                  selectedProduct = '';
                  _filteredProducts.clear();
                }
                setState(() {
                  _selectedOption = true;
                });
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted) {
                if (_selectedOption == true) {
                  _selectedOption = false;
                  fieldTextEditingController.text = '';
                  _filteredProducts.clear();
                }
                return TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  onChanged: (String value) {
                    // Update the autocomplete options when the text field value changes
                    _filterProducts(value);
                    if (_selectedOption == true) {
                      _selectedOption = false;
                      value = '';
                      _filteredProducts.clear();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Products...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.barcode_reader),
                      onPressed: () => scanBarcodeNormal(),
                    ),
                  ),
                );
              },
            ),
            Container(
              height: 400,
              child: ListView.builder(
                padding: EdgeInsets.only(
                  top: 5.0,
                ),
                itemCount: selectedCartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = selectedCartItems[index];
                  return Dismissible(
                    key: Key(cartItem.product.productId
                        .toString()), // Unique key for each item
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      color: Color.fromARGB(255, 251, 174, 169),
                      child: Icon(Icons.delete),
                    ),
                    onDismissed: (direction) {
                      // Remove the item from the cart when dismissed
                      Provider.of<CartProvider>(context, listen: false)
                          .removeCartItem(cartItem);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 2.0,
                        bottom: 2.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black26,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 11,
                                child: Container(
                                  padding: EdgeInsets.only(left: 8),
                                  color: Colors.black12,
                                  height: 80, // Adjust the height as needed
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5),
                                      Text(
                                        'Name ${cartItem.product.productName}',
                                        style: TextStyle(
                                          fontSize: 11,
                                        ), // Adjust the font size of the item name
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        height:
                                            40, // Set the height of the container
                                        width:
                                            100, // Set the width of the container
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            setState(() {
                                              final newPrice =
                                                  double.tryParse(value) ?? 0;
                                              // Update the price directly in the cartItem
                                              cartItem.product.newPrice =
                                                  newPrice;
                                              // Call the method in CartProvider to update the item's price and recalculate netAmount
                                              Provider.of<CartProvider>(
                                                context,
                                                listen: false,
                                              ).updateCartItemPrice(
                                                cartItem,
                                                newPrice,
                                              );
                                            });
                                          },
                                          decoration: InputDecoration(
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
                                  padding: EdgeInsets.only(right: 8),
                                  color: Colors.black12,
                                  height: 80, // Adjust the height as needed
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (cartItem.qty > 0) {
                                                    cartItem.qty--;
                                                    // Call method to update cart quantity
                                                    Provider.of<CartProvider>(
                                                      context,
                                                      listen: false,
                                                    ).updateCartItemQuantity(
                                                      cartItem,
                                                      cartItem.qty,
                                                    );
                                                  }
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.green,
                                                  ), // Green border
                                                ),
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Colors.red,
                                                  size: 9,
                                                ), // Set the icon color to red and adjust size
                                                padding: EdgeInsets.all(
                                                  6,
                                                ), // Adjust padding as needed
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              'Qty: ${cartItem.qty}',
                                              style: TextStyle(
                                                fontSize: 12,
                                              ), // Adjust the font size of the quantity text
                                            ),
                                            SizedBox(width: 5),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  cartItem.qty++;
                                                  // Call method to update cart quantity
                                                  Provider.of<CartProvider>(
                                                    context,
                                                    listen: false,
                                                  ).updateCartItemQuantity(
                                                    cartItem,
                                                    cartItem.qty,
                                                  );
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.green,
                                                  ), // Green border
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.green,
                                                  size: 9,
                                                ), // Set the icon color to green and adjust size
                                                padding: EdgeInsets.all(
                                                  6,
                                                ), // Adjust padding as needed
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          'Subtotal: ${double.tryParse(cartItem.subtotal.toString())}',
                                          style: TextStyle(
                                            fontSize: 12,
                                          ), // Adjust the font size of the subtotal text
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                          // You can add more widgets here as needed
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return Text(
                  'Net Amount: ${cartProvider.netAmount.toString()}',
                  style: TextStyle(fontSize: 14),
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
      ),
    );
  }
}
