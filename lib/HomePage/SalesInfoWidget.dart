import 'package:flutter/material.dart';

class SalesInfoWidget extends StatelessWidget {
  final Map<String, dynamic>? salesData;

  const SalesInfoWidget({super.key, this.salesData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Card(
              color: Colors.lightBlue,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${salesData?['annual_sale_item']?['total_price'] != null ? salesData!['annual_sale_item']['total_price'].toStringAsFixed(0) : 0}",
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    const Text("Annual Total Sales"),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Card(
              color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${salesData?['annual_sales']?['total_grand_total'] != null ? salesData!['annual_sales']['total_grand_total'].toStringAsFixed(0) : 0}",
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    const Text("Annual Grand Total sales"),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Card(
              color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${salesData?['annual_sale_item']?['total_cost_price'] != null ? salesData!['annual_sale_item']['total_cost_price'].toStringAsFixed(0) : 0}",
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    const Text("Annual Total cost price"),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Card(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${salesData?['annual_sale_item']?['total_profit'] != null && salesData?['annual_sales']?['total_order_discount'] != null ? (salesData!['annual_sale_item']['total_profit'] - salesData!['annual_sales']['total_order_discount']).toStringAsFixed(0) : 0}",
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    const Text("Annual Total Profit"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
