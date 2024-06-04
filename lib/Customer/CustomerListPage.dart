import 'package:flutter/material.dart';
import 'package:pos/Customer/EditCustomerPage.dart';
import '../utils/Api.dart';
import 'CustomerModel.dart';
import 'CustomerController.dart';
import '../utils/Helper.dart';
import '../utils/Drawer.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({Key? key}) : super(key: key);

  @override
  CustomerListPageState createState() => CustomerListPageState();
}

class CustomerListPageState extends State<CustomerListPage> {
  Helper helper = Helper(); // Create an instance of the Helper class

  @override
  void initState() {
    super.initState();
    fetchCustomers();
    _scrollController.addListener(_scrollListener);
  }

  List<CustomerModel> _customers = [];
  bool _isLoading = false;
  bool _hasMore = true; // Assume there could be more pages initially
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  List<CustomerModel> get customers => _customers;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchCustomers({int page = 1}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final newCustomers = await CustomerController().getCustomers(page: page);
      setState(() {
        if (page == 1) {
          _customers = newCustomers;
        } else {
          _customers.addAll(newCustomers);
        }
        _hasMore = newCustomers.length == Api().perPage;
        _currentPage = page;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteItem(int index) async {
    CustomerController controller = CustomerController();
    final success = await controller.deleteCustomer(_customers[index].id);
    if (success) {
      refresh();
    }
    setState(() {
      _customers.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Customer delete successfully')),
    );
  }

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;

    final nextPage = _currentPage + 1;
    await fetchCustomers(page: nextPage);
  }

  Future<void> refresh() async {
    await fetchCustomers(page: 1);
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
        title: const Text('Customer List'),
        backgroundColor: Colors.transparent,
        elevation: 90, // Removes the shadow
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

          // Glassy card and customer list
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: SizedBox(
                    width: double.infinity,
                    // padding: const EdgeInsets.all(10.0),
                    // decoration: BoxDecoration(
                    //   color: Colors.white.withOpacity(0.4),
                    //   borderRadius: BorderRadius.circular(10.0),
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: Colors.white.withOpacity(0.2),
                    //       blurRadius: 10,
                    //       offset: const Offset(0, 5),
                    //     ),
                    //   ],
                    // ),
                    child: RefreshIndicator(
                      onRefresh: refresh,
                      child: _isLoading && _customers.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: _customers.length + (_hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == _customers.length) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                final customer = _customers[index];
                                return Dismissible(
                                  key: Key(customer.id
                                      .toString()), // Unique key for each customer
                                  direction: DismissDirection
                                      .endToStart, // Swipe from right to left to delete
                                  confirmDismiss: (direction) async {
                                    // Show a confirmation dialog before deleting
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
                                    _deleteItem(index);
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
                                      padding: const EdgeInsets.only(
                                          left: 11.0, right: 11.0, bottom: 8),
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
                                                      Icons.person,
                                                      color: Colors.green,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 6.0),
                                                    Text(
                                                      'Name: ${customer.name}',
                                                      style: const TextStyle(
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.edit_square,
                                                    color: Colors.redAccent,
                                                    size: 20),
                                                onPressed: () async {
                                                  final updatedCustomer =
                                                      await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditCustomerPage(
                                                                customer:
                                                                    customer)),
                                                  );
                                                  if (updatedCustomer != null) {
                                                    setState(() {
                                                      refresh();
                                                    });
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(Icons.phone,
                                                      color: Colors.indigo,
                                                      size: 20),
                                                  const SizedBox(width: 6.0),
                                                  Text(
                                                    '${customer.phone}',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.indigo),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 10,
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.home,
                                                      color: Colors.green,
                                                      size: 20,
                                                    ),
                                                    const SizedBox(width: 6.0),
                                                    Flexible(
                                                      child: Text(
                                                        'Address: ${customer.address}',
                                                        style: const TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                        ),
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
