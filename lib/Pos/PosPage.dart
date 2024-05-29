import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pos/Pos/CartItem.dart';
import 'package:pos/Pos/CartProvider.dart';
import 'package:pos/Pos/ProductModel.dart';
import 'package:pos/Pos/CustomerModel.dart';
import 'package:pos/Pos/ProductController.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../Customer/CustomerModel.dart';
import '../utils/Drawer.dart';
import '../utils/Api.dart';
import '../utils/Helper.dart';
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

  List<Product> _filteredProducts = [];
  Future<List<Customer>>? futureCustomers;
  Customer? selectedCustomer;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    futureCustomers = fetchCustomers();
  }

  Helper helper = Helper(); // Create an instance of the Helper class

  @override
  void dispose() {
    _fieldTextEditingController.dispose();
    _fieldFocusNode.dispose();
    super.dispose();
  }

  Future<List<Customer>> fetchCustomers({int page = 1, int perPage = 2}) async {
    final response = await Api().getData('customers');
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final customersData = responseBody['data'] as List;
      return customersData.map((json) => Customer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
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

  _handleSubmitOrder() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final selectedCartItems = cartProvider.cartItems;

    final List<Map<String, dynamic>> cartItemsJson =
        selectedCartItems.map((item) {
      return {
        'product_stock_id': item.product.productStockId,
        'product_id': item.product.productId,
        'quantity': item.qty,
        'discount': 0,
        'tax': 0,
        'vat_id': 1,
        'mrp_price': item.product.newPrice,
        'uom': 1,
        'weight': '',
        'dis_array': []
      };
    }).toList();
    // Prepare the JSON payload
    final Map<String, dynamic> payload = {
      'items': cartItemsJson,
      'customer_id': 1,
      'total_amount': cartProvider.netAmount,
      'grand_total': cartProvider.netAmount,
      'total_collect_amount': cartProvider.netAmount,
      'paid_amount': cartProvider.netAmount,
      'return_type': 0,
      'order_discount': 0,
      'order_discount_value': 0,
      'order_vat': 0,
      'order_items_vat': 1,
      'status': 'paid',
      'sale_note': 0,
      'staff_note': 0,
      'return_amount': 0,
      'payments': [
        {
          'amount': cartProvider.netAmount,
          'paid_by': "cash",
          'gift_card': "",
          'bank_id': "",
          'card_reference_code': "",
          'wallet_id': "",
          'payment_note': "",
          'redeem_point': "",
        }
      ],
    };
    // selectedCartItems.forEach((item) {
    //   print(
    //       'Product: ${item.product.productName}, Quantity: ${item.qty}, Price: ${item.product.newPrice}');
    // });

    // Convert cart items to JSON format

    print('payload');
    print(cartProvider.toString());
    print(payload);
    const String apiUrl = 'sales';

    final response = await Api().postData(payload, apiUrl);

    if (response.statusCode == 200) {
      helper.successToast('Customer created successfully');
      // setState(() {
      //   _isLoading = false; // Show loading indicator
      // });
      final responseData = json.decode(response.body);
      print('responseData================= ');
      print(responseData.toString());
    } else {
      final responseData = json.decode(response.body);
      print('else ====== ');
      print(responseData.toString());
    }

    // Define the server endpoint
    // final String url = 'http://127.0.0.1:8000/api/sales';

    // try {
    //   final response = await http.post(
    //     Uri.parse(url),
    //     headers: {'Content-Type': 'application/json'},
    //     body: json.encode(payload),
    //   );

    //   if (response.statusCode == 200) {
    //     print('Order submitted successfully');
    //     // Handle successful order submission
    //   } else {
    //     print('Failed to submit order: ${response.body}');
    //     // Handle server errors
    //   }
    // } catch (e) {
    //   print('Error submitting order: $e');
    //   // Handle network errors
    // }
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
          SingleChildScrollView(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              children: [
                const SizedBox(height: 10.0),
                _buildCustomerDropdown(),
                const SizedBox(height: 10.0),
                _buildCustomAutocompleteField(),
                SizedBox(
                  height: screenHeight -
                      130, // Adjust the height based on header and footer
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
                  constraints: const BoxConstraints(
                    maxHeight: 250.0, // Set your maxHeight here
                  ),
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

  Widget _buildCustomerDropdown() {
    return FutureBuilder<List<Customer>>(
      future: futureCustomers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No customers available'));
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: DropdownSearch<Customer>(
                    items: snapshot.data!,
                    itemAsString: (Customer c) => c.name,
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Customer",
                        hintText: "Select a customer",
                      ),
                    ),
                    selectedItem: selectedCustomer,
                    onChanged: (Customer? customer) {
                      setState(() {
                        selectedCustomer = customer;
                      });
                    },
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _showAddCustomerDialog();
                },
              ),
            ],
          );
        }
      },
    );
  }

  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController emailController = TextEditingController();

        return AlertDialog(
          title: Text('Add New Customer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  final newCustomer = CustomerModel(
                    id: 0, // Adjust as necessary
                    name: nameController.text,
                    customerCode: '', // Adjust as necessary
                    phone: '', // Adjust as necessary
                    email: emailController.text,
                    address: '', // Adjust as necessary
                  );
                  // _customers.add(newCustomer);
                  // _selectedCustomer = newCustomer;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          cartItem.product.productName,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.attach_money,
                          color: Colors.brown, size: 20),
                      const SizedBox(width: 8.0),
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
                  Row(
                    children: [
                      Row(
                        children: [
                          _buildQuantityControl(Icons.remove, Colors.red, () {
                            if (cartItem.qty > 0) {
                              setState(() {
                                cartItem.qty--;
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .updateCartItemQuantity(
                                        cartItem, cartItem.qty);
                              });
                            }
                          }),
                          const SizedBox(width: 5.0),
                          Text(
                            'Qty: ${cartItem.qty}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 5.0),
                          _buildQuantityControl(Icons.add, Colors.green, () {
                            setState(() {
                              cartItem.qty++;
                              Provider.of<CartProvider>(context, listen: false)
                                  .updateCartItemQuantity(
                                      cartItem, cartItem.qty);
                            });
                          }),
                        ],
                      ),
                      const SizedBox(width: 20.0),
                      Text(
                        'Subtotal: ${cartItem.subtotal.toString()}',
                        style: const TextStyle(fontSize: 12),
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
      color: Colors.grey.withOpacity(0.4),
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
            onPressed: () {
              _handleSubmitOrder();
            },
            child: const Text('Submit Order'),
          ),
        ],
      ),
    );
  }
}
