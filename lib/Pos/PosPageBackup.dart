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
  const PosPage({Key? key}) : super(key: key);

  @override
  PosPageState createState() => PosPageState();
}

class PosPageState extends State<PosPage> {
  final TextEditingController _fieldTextEditingController =
      TextEditingController();
  final FocusNode _fieldFocusNode = FocusNode();
  bool _selectedOption = false;

  Helper helper = Helper(); // Create an instance of the Helper class
  List<Product> _filteredProducts = [];
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
        duration: const Duration(seconds: 2),
      ),
    );
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/imageedit.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
                  _fieldTextEditingController.clear();
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
                  fieldTextEditingController.clear();
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
                      fieldTextEditingController.clear();
                      _filteredProducts.clear();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Products...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.barcode_reader),
                      onPressed: () => scanBarcodeNormal(),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: screenHeight - 120,
              child: ListView.builder(
                padding: const EdgeInsets.only(
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
                      color: const Color.fromARGB(255, 251, 174, 169),
                      child: const Icon(Icons.delete),
                    ),
                    onDismissed: (direction) {
                      // Remove the item from the cart when dismissed
                      Provider.of<CartProvider>(context, listen: false)
                          .removeCartItem(cartItem);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 2.0,
                        bottom: 2.0,
                      ),
                      decoration: const BoxDecoration(
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
                                  padding: const EdgeInsets.only(left: 8),
                                  color: Colors.black12,
                                  height: 80, // Adjust the height as needed
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      Text(
                                        'Name ${cartItem.product.productName}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                        ), // Adjust the font size of the item name
                                      ),
                                      const SizedBox(height: 5),
                                      SizedBox(
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
                                  height: 80, // Adjust the height as needed
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const SizedBox(height: 5),
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
                                                ), // Set the icon color to red and adjust size
                                                padding: const EdgeInsets.all(
                                                  6,
                                                ),
                                                child: const Icon(
                                                  Icons.remove,
                                                  color: Colors.red,
                                                  size: 9,
                                                ), // Adjust padding as needed
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Qty: ${cartItem.qty}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ), // Adjust the font size of the quantity text
                                            ),
                                            const SizedBox(width: 5),
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
                                                ), // Set the icon color to green and adjust size
                                                padding: const EdgeInsets.all(
                                                  6,
                                                ),
                                                child: const Icon(
                                                  Icons.add,
                                                  color: Colors.green,
                                                  size: 9,
                                                ), // Adjust padding as needed
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          'Subtotal: ${double.tryParse(cartItem.subtotal.toString())}',
                                          style: const TextStyle(
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
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white.withOpacity(0.4),
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<CartProvider>(
                      builder: (context, cartProvider, child) {
                        return Text(
                          'Net Amount: ${cartProvider.netAmount.toString()}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Submit Order'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Consumer<CartProvider>(
      //         builder: (context, cartProvider, child) {
      //           return Text(
      //             'Net Amount: ${cartProvider.netAmount.toString()}',
      //             style: const TextStyle(fontSize: 14),
      //           );
      //         },
      //       ),
      //       ElevatedButton(
      //         onPressed: () {},
      //         child: const Text('Submit Order'),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
