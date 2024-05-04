import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/material.dart';
import 'package:pos/Pos/CartProvider.dart';
import 'package:pos/Pos/ProductModel.dart';
import 'package:pos/Pos/ProductController.dart';
import 'package:pos/Pos/CartItemList.dart';
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

  @override
  void initState() {
    super.initState();
  }

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
    // print('Product Code: ${product.productCode}');
    // Provider.of<CartProvider>(context, listen: false).addToCart(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.productName} added to cart'),
        duration: Duration(seconds: 2),
      ),
    );
    // Clear the search results
    _productSearchController.clear();
    setState(() {
      _filteredProducts = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedCartItems = Provider.of<CartProvider>(context).cartItems;
    final cartProvider = Provider.of<CartProvider>(context);
    TextEditingController fieldTextEditingController = TextEditingController();

    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: Scaffold(
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
                  // Handle selecting a product from the autocomplete options
                  final selectedProductObj = _filteredProducts.firstWhere(
                      (product) => product.productName == selectedProduct);
                  print('selectedProductObj');
                  print(selectedProductObj.productCode);
                  print(selectedProduct);
                  if (selectedProductObj != null) {
                    _addToCartAndClearResults(selectedProductObj);
                    Provider.of<CartProvider>(context, listen: false)
                        .addToCart(selectedProductObj);
                    // Clear the text field after selecting a product
                  }
                  setState(() {
                    fieldTextEditingController.clear();
                  });
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
                      padding: EdgeInsets.all(
                          2.0), // Add padding of 5px on all sides
                      child: ListTile(
                        title: Text('Name ${cartItem.product.productCode}'),
                        subtitle: Row(
                          children: [
                            Text('Qty: ${cartItem.qty} '),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 35, // Set the desired height
                                width: 50, // Set the desired width
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    // Update the price in the cart item
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
                                'Subtotal: ${double.tryParse(cartItem.product.mrpPrice.toString())}'),
                          ],
                        ),
                        tileColor: Colors.lightGreenAccent,
                      ),
                    );
                  },
                ),
              ),

              Text(
                'Net Amount: ${cartProvider.netAmount.toString()}', // Display net amount
                style: TextStyle(fontSize: 24),
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
      ),
    );
  }
}
