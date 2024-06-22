import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos/Pos/InvoiceModel.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../utils/DashedBorder.dart';

// Define the models here or import them if they are in separate files

void navigateToInvoiceScreen(BuildContext context, InvoiceModel saleData) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(10.0), // 98% screen coverage
        child: Stack(
          children: [
            Positioned(
              top: 10.0,
              right: 10.0,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.redAccent,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            // Positioned(
            //   top: 10.0,
            //   left: 10.0,
            //   child: IconButton(
            //     icon: const Icon(
            //       Icons.print,
            //       color: Colors.blue,
            //     ),
            //     onPressed: () {
            //       // Add your print functionality here
            //     },
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.only(top: 50.0), // Adjust for buttons
              child: SingleChildScrollView(
                child: InvoiceScreen(
                  saleData: saleData,
                  subTotalSum: saleData.salesItems
                      .fold(0, (sum, item) => sum + item.subTotal),
                  totalAmount: saleData.collectionAmount,
                  currencyFormatter: NumberFormat.currency(symbol: "\$"),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class InvoiceScreen extends StatelessWidget {
  final InvoiceModel saleData;
  final num subTotalSum;
  final dynamic totalAmount;
  final NumberFormat currencyFormatter;

  InvoiceScreen({
    required this.saleData,
    required this.subTotalSum,
    required this.totalAmount,
    required this.currencyFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: const Color.fromARGB(255, 205, 206, 206), width: 2),
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: AutoSizeText(
                          saleData.outlet.name,
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        '${saleData.outlet.address}',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Invoice',
                          style: TextStyle(fontSize: 18, color: Colors.black),
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
                  flex: 15,
                  child: Text(
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
                  color: Colors.black,
                  width: 1.0,
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
                    flex: 25,
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
                    flex: 10,
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
                    flex: 15,
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
                    flex: 15,
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
                    flex: 15,
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
          ListView.builder(
            shrinkWrap: true,
            itemCount: saleData.salesItems.length,
            itemBuilder: (context, index) {
              SalesItem item = saleData.salesItems[index];
              return InvoiceItemRow(
                description: item.products.productName,
                quantity: item.quantity,
                unitPrice: item.mrpPrice,
                discount: item.discount,
                total: (item.mrpPrice - item.discount),
                subTotals: item.subTotal,
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sub Total:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                currencyFormatter.format(subTotalSum),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                currencyFormatter.format(totalAmount),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
    );
  }
}

class InvoiceItemRow extends StatelessWidget {
  final String description;
  final int quantity;
  final dynamic unitPrice;
  final dynamic discount;
  final dynamic total;
  final dynamic subTotals;

  InvoiceItemRow({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.discount,
    required this.total,
    required this.subTotals,
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
              flex: 25,
              child: Text(
                description,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              flex: 10,
              child: Text(
                quantity.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              flex: 15,
              child: Text(
                unitPrice.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              flex: 15,
              child: Text(
                discount.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              flex: 15,
              child: Text(
                total.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              flex: 20,
              child: Text(
                subTotals.toString(),
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
