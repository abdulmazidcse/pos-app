import 'package:flutter/material.dart';
import 'package:pos/Sales/SaleModel.dart';
import 'package:barcode_widget/barcode_widget.dart';

class InvoicePage extends StatelessWidget {
  final SaleModel saleData;

  const InvoicePage({super.key, required this.saleData});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Retail Shop 1.',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('34/4-A/10, North Bashaboo, Dhaka 1000'),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'INVOICE',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer: Delta Force'),
                  Text('Address: H-405,R-29,Mohakhali Dohs,Dhaka-1212'),
                  Text('Mobile: 01741575914'),
                  Text('Served by: Super Admin'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('#INV00124000164'),
                  Text('22 Feb 2024'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(thickness: 2),
          Table(
            border: TableBorder.all(),
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
              5: FlexColumnWidth(1),
            },
            children: const [
              TableRow(children: [
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Item Name',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Qty',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Wt',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('MRP',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Value',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Amount',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
              ]),
              TableRow(children: [
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8), child: Text('A4 Kham'))),
                TableCell(
                    child:
                        Padding(padding: EdgeInsets.all(8), child: Text('3'))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8), child: Text('5.00'))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8), child: Text('15.00'))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8), child: Text('9.00'))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8), child: Text('9.00'))),
              ]),
              TableRow(children: [
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8), child: Text('Flower Mop'))),
                TableCell(
                    child:
                        Padding(padding: EdgeInsets.all(8), child: Text('2'))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8), child: Text('130.00'))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8), child: Text('260.00'))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8), child: Text('240.00'))),
                TableCell(
                    child: Padding(
                        padding: EdgeInsets.all(8), child: Text('240.00'))),
              ]),
            ],
          ),
          const Divider(thickness: 2),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount:'),
              Text('275.00'),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Discount:'),
              Text('0.00'),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('VAT:'),
              Text('0.00'),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Net Amount:'),
              Text('200.00'),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Paid Amount:'),
              Text('200.00'),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Payment Description:'),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Description'),
              Text('Amount'),
            ],
          ),
          const Divider(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('cash'),
              Text('200.00'),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: BarcodeWidget(
              barcode: Barcode.code128(),
              data: 'INV00124000164',
              width: 200,
              height: 80,
            ),
          ),
          const Center(child: Text('INV00124000164')),
          const SizedBox(height: 16),
          const Center(child: Text('System By: SSG-IT')),
        ],
      ),
    );
  }
}
