import 'package:flutter/material.dart';

class SalesInfoWidget extends StatelessWidget {
  final Map<String, dynamic>? salesData;

  const SalesInfoWidget({Key? key, this.salesData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
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
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    Text("Annual Total Sales"),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 16.0),
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
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    Text("Annual Grand Total sales"),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 16.0),
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
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    Text("Annual Total cost price"),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 16.0),
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
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    Text("Annual Total Profit"),
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
