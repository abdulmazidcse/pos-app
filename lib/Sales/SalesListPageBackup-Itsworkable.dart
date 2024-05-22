import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos/Sales/SaleModel.dart';
import '../utils/Api.dart';
import '../utils/Helper.dart';
import '../utils/Drawer.dart';

class SalesListPage extends StatefulWidget {
  const SalesListPage({Key? key}) : super(key: key);

  @override
  SalesListPageState createState() => SalesListPageState();
}

class SalesListPageState extends State<SalesListPage> {
  Helper helper = Helper(); // Create an instance of the Helper class
  List<SaleModel> _salesData = [];
  bool _isLoading = false;
  bool _hasMore = true; // Assume there could be more pages initially
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  List<SaleModel> get products => _salesData;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  @override
  void initState() {
    super.initState();
    fetchSalesOrders();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> fetchSalesOrders({int page = 1}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final newProducts = await Api().fetchSales(page: page);
      setState(() {
        if (page == 1) {
          _salesData = newProducts;
        } else {
          _salesData.addAll(newProducts);
        }
        _hasMore = newProducts.length == Api().perPage;
        _currentPage = page;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProduct(int index) async {
    // Implement your product deletion logic here
    setState(() {
      _salesData.removeAt(index);
    });

    await fetchSalesOrders(page: 1);
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
                _deleteProduct(index); // Delete the product
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
    await fetchSalesOrders(page: nextPage);
  }

  Future<void> refresh() async {
    await fetchSalesOrders(page: 1);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Order List'),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: RefreshIndicator(
                      onRefresh: refresh,
                      child: _isLoading && _salesData.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: _salesData.length + (_hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == _salesData.length) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                final saleData = _salesData[index];
                                return Dismissible(
                                  key: Key(saleData.id.toString()),
                                  direction: DismissDirection.endToStart,
                                  confirmDismiss: (direction) async {
                                    return showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Confirm"),
                                          content: const Text(
                                              "Are you sure you want to delete this item?"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: const Text("CANCEL"),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text("DELETE"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  onDismissed: (direction) {
                                    setState(() {
                                      _salesData.removeAt(index);
                                    });
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
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: ListTile(
                                      title: Text(saleData.invoiceNumber),
                                      subtitle: Text(
                                        'Code: ${saleData.id}\nPrice: \$${saleData.grandTotal}',
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
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