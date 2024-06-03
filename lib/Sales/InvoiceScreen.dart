import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for currency formatting
import 'package:pos/Sales/SaleModel.dart';

class InvoiceScreen extends StatelessWidget {
  final SaleModel saleData;

  InvoiceScreen({required this.saleData});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(symbol: '\$'); // Currency formatting

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Invoice Header - Company Information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Flutter Approach',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                          text: 'John Doe\n', style: TextStyle(fontSize: 12)),
                      TextSpan(
                        text: 'john@gmail.com',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue), // Optional: Email as a link
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Invoice Details - Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: ${saleData.createdAt}', // Assuming 'date' exists in SaleModel
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Invoice Details - Customer Information (Optional)
            // You can add a Text widget here if needed for customer information

            const SizedBox(height: 16),

            // Invoice Description Table Header
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Description',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Quantity',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Unit Price',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  'VAT',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),

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
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
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
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          description,
          style: const TextStyle(fontSize: 12),
        ),
        Text(
          quantity.toString(),
          style: const TextStyle(fontSize: 12),
        ),
        Text(
          '\$${unitPrice.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 12),
        ),
        const Text(
          '00',
          style: TextStyle(fontSize: 12),
        ),
        Text(
          '\$${total.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
