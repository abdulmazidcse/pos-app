import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pos/Sales/SaleModel.dart';

class InvoiceDetailScreen extends StatelessWidget {
  final List<SalesItem> salesItems;

  InvoiceDetailScreen({required this.salesItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/imageedit.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Text('Sales Items:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: salesItems.length,
                itemBuilder: (context, index) {
                  final item = salesItems[index];
                  return ListTile(
                    title: const Text('Item Name'),
                    subtitle: Text('Price: \$${item.mrpPrice}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
