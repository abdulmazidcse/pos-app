import 'package:flutter/material.dart';
import 'package:pos/Pos/CartProvider.dart';
import 'package:pos/Pos/ProductModel.dart';
import 'package:pos/Pos/ProductController.dart';
import 'package:provider/provider.dart';
import '../utils/Drawer.dart';

class PosPage extends StatefulWidget {
  @override
  _PosPageState createState() => _PosPageState();
}

class _PosPageState extends State<PosPage> {
  final TextEditingController _productSearchController =
      TextEditingController();
  List<Product> _filteredProducts = [];

  void _filterProducts(String searchTerm) async {
    if (searchTerm.isEmpty) {
      _filteredProducts =
          []; //fetchProducts(''); // Show all products on empty search
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(width: 10),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  // Return an empty list when there's no text in the search field
                  return <String>[];
                } else if (textEditingValue.text.length >= 3) {
                  // Fetch products based on the search term
                  // _productSearchController.clear();
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
                // Return an empty list when the search term is less than 3 characters
                return <String>[];
              },
              onSelected: (String selectedProduct) {
                // Find the selected product from the list of filtered products
                Product selectedProductObj = _filteredProducts.firstWhere(
                  (product) => product.productName == selectedProduct,
                  orElse: () => Product(
                      productId: 0,
                      productStockId: '',
                      outletId: '',
                      productType: '',
                      productName: '',
                      productNativeName: '',
                      productCode: '',
                      categoryId: '',
                      barcodeSymbology: '',
                      minOrderQty: '',
                      costPrice: 0,
                      depoPrice: 0,
                      mrpPrice: 0,
                      taxMethod: 0,
                      productTax: 0,
                      measuringUnit: 0,
                      weight: 0,
                      itemDiscount: 0,
                      discount: 0,
                      tax: 0,
                      quantity: '',
                      stockQuantity: '',
                      expiresDate: '',
                      disArray: {},
                      newPrice: 0), // Default empty product
                  // Return null if product is not found
                );

                // Check if the selected product is found
                if (selectedProductObj != null) {
                  // Add the selected product to the cart and show a message
                  _addToCartAndClearResults(selectedProductObj);
                  Provider.of<CartProvider>(context, listen: false)
                      .addToCart(selectedProductObj);
                } else {
                  // Handle case when product is not found
                  print('Product not found');
                  // You can show a message or perform any other action here
                }

                // Clear the search field after selecting a product or if no product is found
                _productSearchController.clear();
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  onChanged: (String value) {
                    // Update the autocomplete options when the text field value changes
                    _filterProducts(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Products...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.barcode_reader),
                      onPressed: () {
                        // Handle barcode icon press here
                      },
                    ),
                  ),
                );
              },
            ),
            // CartItemList(),

            Expanded(
              child: ListView.builder(
                itemCount: selectedCartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = selectedCartItems[index];
                  return Padding(
                    padding:
                        EdgeInsets.all(2.0), // Add padding of 5px on all sides
                    child: ListTile(
                      title: Text('Name ${cartItem.product.productCode}'),
                      subtitle: Row(
                        children: [
                          Text('Qty: ${cartItem.qty}'),
                          SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 35, // Set the desired height
                              width: 50, // Set the desired width
                              child: TextField(
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    final newPrice =
                                        double.tryParse(value) ?? 0;
                                    // Update the price directly in the cartItem
                                    cartItem.product.newPrice = newPrice;
                                    // Call the method in CartProvider to update the item's price and recalculate netAmount
                                    Provider.of<CartProvider>(context,
                                            listen: false)
                                        .updateCartItemPrice(
                                            cartItem, newPrice);
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Price',
                                  hintText: 'Enter price',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                              'Subtotal: ${double.tryParse(cartItem.product.newPrice.toString())}'),
                        ],
                      ),
                      tileColor: Colors.lightGreenAccent,
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  return Text(
                    'Net Amount: ${cartProvider.netAmount.toString()}',
                    style: TextStyle(fontSize: 24),
                  );
                },
              ),
            ),
            // Cart item list with quantity and subtotal

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
