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
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: Scaffold(
        drawer: MyDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(width: 10),
              TextField(
                controller: _productSearchController,
                onChanged: (value) => _filterProducts(value),
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
              ),

              Flexible(
                child: ListView.builder(
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = _filteredProducts[index];
                    return ListTile(
                      title: Text(product.productName,
                          style: TextStyle(color: Colors.black87)),
                      onTap: () {
                        // Handle adding product to cart
                        _addToCartAndClearResults(product);
                        Provider.of<CartProvider>(context, listen: false)
                            .addToCart(product);
                      },
                      tileColor: Colors.lightBlueAccent,
                    );
                  },
                ),
              ),

              CartItemList(),
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
