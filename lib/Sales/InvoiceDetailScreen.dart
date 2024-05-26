import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SalesPage(),
    );
  }
}

class SalesPage extends StatefulWidget {
  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final List<SaleData> _salesData = [
    SaleData(
      id: 1,
      invoiceNumber: "652035",
      customerName: "Mazid",
      createdAt: "Dec 13, 2023, 7:00 PM",
      collectionAmount: 958,
      grandTotal: 1000,
      salesItemsSumDiscount: 42,
      salesItemsCount: 5,
    ),
    SaleData(
      id: 2,
      invoiceNumber: "652029",
      customerName: "Mazid",
      createdAt: "Dec 13, 2023, 6:56 PM",
      collectionAmount: 958,
      grandTotal: 1000,
      salesItemsSumDiscount: 42,
      salesItemsCount: 5,
    ),
  ];

  final ScrollController _scrollController = ScrollController();
  bool _hasMore = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales Data"),
      ),
      body: ListView.builder(
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
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("CANCEL"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: Colors.red,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'INV: #${saleData.invoiceNumber}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          'Date: ${saleData.createdAt}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.grey),
                        SizedBox(width: 8.0),
                        Text(
                          'C.Name: ${saleData.customerName}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.attach_money, color: Colors.grey),
                        SizedBox(width: 8.0),
                        Text(
                          'Paid: ${saleData.collectionAmount}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.money, color: Colors.grey),
                        SizedBox(width: 8.0),
                        Text(
                          'T.Amount: ${saleData.grandTotal}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.discount, color: Colors.grey),
                        SizedBox(width: 8.0),
                        Text(
                          'T.Dis: ${saleData.salesItemsSumDiscount}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.list, color: Colors.grey),
                        SizedBox(width: 8.0),
                        Text(
                          'T.Items: ${saleData.salesItemsCount}',
                          style: TextStyle(fontSize: 12),
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
    );
  }
}

class SaleData {
  final int id;
  final String invoiceNumber;
  final String customerName;
  final String createdAt;
  final double collectionAmount;
  final double grandTotal;
  final double salesItemsSumDiscount;
  final int salesItemsCount;

  SaleData({
    required this.id,
    required this.invoiceNumber,
    required this.customerName,
    required this.createdAt,
    required this.collectionAmount,
    required this.grandTotal,
    required this.salesItemsSumDiscount,
    required this.salesItemsCount,
  });
}
