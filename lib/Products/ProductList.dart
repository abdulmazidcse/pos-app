import 'package:flutter/material.dart';
import 'package:pos/Products/ProductController.dart';
import 'package:pos/Products/EditProductPage.dart';
import 'package:pos/Products/ProductModel.dart';
import '../utils/Api.dart';
import '../utils/Helper.dart';
import '../utils/Drawer.dart';
import 'package:barcode_widget/barcode_widget.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  ProductListState createState() => ProductListState();
}

class ProductListState extends State<ProductList> {
  Helper helper = Helper(); // Create an instance of the Helper class
  ProductController controller = ProductController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _scrollController.addListener(_scrollListener);
  }

  List<ProductModel> _products = [];
  bool _isLoading = false;
  bool _hasMore = true; // Assume there could be more pages initially
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchProducts({int page = 1}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final newProducts = await controller.getProducts(page: page);
      setState(() {
        if (page == 1) {
          _products = newProducts;
        } else {
          _products.addAll(newProducts);
        }
        _hasMore = newProducts.length == Api().perPage;
        _currentPage = page;
      });
    } catch (e) {
      // Handle network error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Failed to fetch products. Please check your network connection.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteItem(int index) async {
    final success = await controller.deleteProduct(_products[index].id);
    if (success) {
      refresh();
    }
    setState(() {
      _products.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product delete successfully')),
    );
  }

  Future<void> _confirmDelete(BuildContext context, int index) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteItem(index); // Delete the product
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;

    final nextPage = _currentPage + 1;
    await fetchProducts(page: nextPage);
  }

  Future<void> refresh() async {
    await fetchProducts(page: 1);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
// Your existing code...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Product List'),
        backgroundColor: Colors.transparent,
        elevation: 90,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/imageedit.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Glassy card and product list
          Column(
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: RefreshIndicator(
                    onRefresh: refresh,
                    child: _isLoading && _products.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: _products.length + (_hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _products.length) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              final product = _products[index];
                              return Dismissible(
                                key: Key(product.id.toString()),
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (direction) async {
                                  _confirmDelete(context, index);
                                  return null;
                                },
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  color: Colors.red,
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                child: Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(11.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.receipt_long_outlined,
                                                    color: Colors.green,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 8.0),
                                                  Text(
                                                    'P.Name: ${product.productName}',
                                                    style: const TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  color: Colors.blue),
                                              onPressed: () async {
                                                final updatedProduct =
                                                    await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditProductPage(
                                                            product: product),
                                                  ),
                                                );
                                                if (updatedProduct != null) {
                                                  setState(() {
                                                    _products[index] =
                                                        updatedProduct;
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.attach_money,
                                                    color: Colors.brown,
                                                    size: 20),
                                                const SizedBox(width: 8.0),
                                                Text(
                                                  'MRP Price: ${product.mrpPrice}',
                                                  style: const TextStyle(
                                                    color: Colors.brown,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.money_rounded,
                                                    color: Colors.indigo,
                                                    size: 20),
                                                const SizedBox(width: 8.0),
                                                Text(
                                                  'Cost Price: ${product.costPrice}',
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.indigo),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.barcode_reader,
                                                    color: Colors.blue,
                                                    size: 20),
                                                const SizedBox(width: 8.0),
                                                Text(
                                                  'P.Code: ${product.productCode}',
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                BarcodeWidget(
                                                  barcode: Barcode.code128(),
                                                  data: product.productCode,
                                                  width: 120,
                                                  height: 40,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
