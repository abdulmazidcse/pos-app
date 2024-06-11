import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart'; // Import for currency formatting
import 'package:pos/Sales/SaleModel.dart';
import '../utils/DashedBorder.dart';
import 'package:barcode_widget/barcode_widget.dart';

class InvoiceWidget extends StatelessWidget {
  final SaleModel saleData;

  InvoiceWidget({required this.saleData});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(symbol: '\$'); // Currency formatting

    // Calculate the sum of sub_total values
    final double subTotalSum =
        saleData.salesItems.fold(0, (sum, item) => sum + item.subTotal);
    // ignore: non_constant_identifier_names
    final double TotalAmount = subTotalSum - saleData.orderDiscountValue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          padding: const EdgeInsets.all(
              15.0), // Approximate 2mm padding (1mm = 3.78px)
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: const Color.fromARGB(255, 205, 206, 206),
                width: 5), // Set the border color and width
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 15.0),
                            child: AutoSizeText(
                              saleData.outlet.name, // 'Retail Shop',
                              style: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Expanded(
                              child: Text(
                            '${saleData.outlet.address}',
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          )),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Customer : ${saleData.customerName}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 15, // 10%
                      child: Text(
                        // 'Address: H-405,R-29,Mohakhali Dohs,Dhaka-1212',
                        'Address: ${saleData.customer.address}',
                        style: const TextStyle(fontSize: 12),
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Mobile: ${saleData.customer.phone}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Srvd by: ${saleData.createdBy.name}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${saleData.invoiceNumber}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    saleData.createdAt,
                    style: const TextStyle(fontSize: 13),
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
                  ),
                  color: Colors.white,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 25, // 20%
                        child: Text(
                          'Item Name',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 10, // 10%
                        child: Text(
                          'Qty',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 15, // 10%
                        child: Text(
                          'MRP',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 15, // 10%
                        child: Text(
                          'Dis',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 15, // 10%
                        child: Text(
                          'Value',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 20,

                        /// 10%
                        child: Text(
                          'Total',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                    discount: item.discount,
                    total: (item.mrpPrice - item.discount),
                    subTotal: item.subTotal,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Invoice Totals - Net Total, VAT, Total Due
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sub Total:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    currencyFormatter
                        .format(subTotalSum), // Display calculated subTotalSum
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Discount:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    currencyFormatter.format(saleData.orderDiscountValue),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    currencyFormatter
                        .format(TotalAmount), // Use currency formatter
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Text('Payment Description:'),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Description'),
                  Text('Amount'),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('cash'),
                  Text(saleData.collectionAmount.toString()),
                ],
              ),
              Center(
                child: BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: saleData.invoiceNumber,
                  width: 120,
                  height: 50,
                ),
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
  final dynamic discount;
  final num subTotal;
  // final double vat;
  final num total;

  const InvoiceItemRow({
    super.key,
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.discount,
    required this.subTotal,
    // required this.vat,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorder(
        color: Colors.black,
        strokeWidth: 1.0,
        dashWidth: 1.0,
        dashSpace: 3.0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 25, // 20%
              child: Text(
                description,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              flex: 10, // 10%
              child: Text(
                quantity.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              flex: 15, // 10%
              child: Text(
                '\$${unitPrice.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              flex: 15, // 10%
              child: Text(
                '\$${discount.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              flex: 15, // 10%
              child: Text(
                '\$${total.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              flex: 20, // 10%
              child: Text(
                '\$${subTotal.toStringAsFixed(2)}',
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
