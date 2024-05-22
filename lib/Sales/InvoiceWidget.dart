import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart'; // Import for currency formatting
import 'package:pos/Sales/SaleModel.dart';

class InvoiceWidget extends StatelessWidget {
  final SaleModel saleData;

  InvoiceWidget({required this.saleData});

  // const InvoiceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(symbol: '\$'); // Currency formatting

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          padding: const EdgeInsets.all(
              8.0), // Approximate 2mm padding (1mm = 3.78px)
          decoration: BoxDecoration(
            color: Colors.white,
            // Background color
            border: Border.all(
              color: const Color.fromARGB(255, 255, 255, 181), // Border color
              width: 5.0, // Border width
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 96, // 1 inch blur radius
                spreadRadius: -24, // -0.25 inch spread radius
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 15.0),
                            child: const AutoSizeText(
                              'Retail Shop',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '34/4/A/10, North Bashaboo, Dhaka 1000',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Invoice',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Customer : Delta Force',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Address: H-405,R-29,Mohakhali Dohs,Dhaka-1212',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Mobile: 01741575914',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Srvd by: Super Admin',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${saleData.invoiceNumber}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    '${saleData.createdAt}',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.black, // Border color
                      width: 1.0, // Border width
                    ),
                    bottom: BorderSide(
                      color: Colors.black, // Border color
                      width: 1.0, // Border width
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Item Name',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Qty',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'MRP',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Value',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Total',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // Invoice Description Table Body - List of Items
              ListView.builder(
                shrinkWrap: true, // Makes the list view non-scrollable
                itemCount: saleData.salesItems
                    .length, // Assuming 'items' is a List<SalesItem> in SaleModel
                itemBuilder: (context, index) {
                  SalesItem item =
                      saleData.salesItems[index]; // Get the current item
                  return InvoiceItemRow(
                    description: item.products.productName,
                    quantity: item.quantity,
                    unitPrice: item.mrpPrice,
                    total: item.mrpPrice,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Invoice Totals - Net Total, VAT, Total Due
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Net Total:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    currencyFormatter
                        .format(saleData.grandTotal), // Use currency formatter
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vat 19.5%:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Vat 19.5%:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount Due:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    currencyFormatter
                        .format(saleData.totalAmount), // Use currency formatter
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Invoice Footer - Company Address (Optional)
              // You can uncomment this section and add your company address details
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '123 Main Street\nAnytown, CA 12345',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InvoiceItemRow extends StatelessWidget {
  final String description;
  final int quantity;
  final num unitPrice;
  // final double vat;
  final num total;

  const InvoiceItemRow({
    super.key,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    // required this.vat,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black, // Border color
            width: 1.0, // Border width
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            description,
            style: TextStyle(fontSize: 12),
          ),
          Text(
            quantity.toString(),
            style: TextStyle(fontSize: 12),
          ),
          Text(
            '\$${unitPrice.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 12),
          ),
          Text(
            '00',
            style: TextStyle(fontSize: 12),
          ),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Invoice Header
//         Text(
//           'Retail Shop 1',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         Text('34/4/A/10, North Bashaboo, Dhaka 1000'),
//         Text('INVOICE'),

//         // Customer Details
//         Text(
//           'Customer: Delta Force',
//           style: TextStyle(fontSize: 16),
//         ),
//         Text('Address: H-405,R-29,Mohakhali Dohs, Dhaka-1212'),
//         Text('Mobile: 01741575914'),
//         Text('Srvd by: Super Admin'),

//         // Invoice Details
//         Text('Invoice #INV00124000164'),
//         Text('Invoice Date: 22 Feb 2024'),

//         // Product Table
//         DataTable(
//           columns: const [
//             DataColumn(label: Text('Item Name')),
//             DataColumn(label: Text('Qty')),
//             DataColumn(label: Text('Unit Price')),
//             DataColumn(label: Text('MRP')),
//             DataColumn(label: Text('Value')),
//             DataColumn(label: Text('Amount')),
//           ],
//           rows: const [
//             DataRow(
//               cells: [
//                 DataCell(Text('A4 Kham')),
//                 DataCell(Text('3')),
//                 DataCell(Text('5.00')),
//                 DataCell(Text('15.00')),
//                 DataCell(Text('9.00')),
//                 DataCell(Text('27.00')),
//               ],
//             ),
//             DataRow(
//               cells: [
//                 DataCell(Text('Flower Mop')),
//                 DataCell(Text('2')),
//                 DataCell(Text('130.00')),
//                 DataCell(Text('260.00')),
//                 DataCell(Text('260.00')),
//                 DataCell(Text('520.00')),
//               ],
//             ),
//           ],
//         ),

//         // Summary
//         Text('Total Amount: 797.00'),
//         Text('Discount: 0.00'),
//         Text('VAT: 0.00'),
//         Text('Net Amount: 797.00'),
//         Text('Paid Amount: 0.00'),

//         // Payment Details
//         Text('Payment Method: Cash on Delivery'),
//         Text('Amount Paid: 0.00'),

//         // Footer
//         Text('Invoice #INV00124000164'),
//         Text('System By: Invoice App'),
//       ],
//     );
//   }
// }
