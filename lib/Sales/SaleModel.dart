// To parse this JSON data, do
//
//     final saleModel = saleModelFromJson(jsonString);

import 'dart:convert';

class SaleModel {
  int id;
  String createdAt;
  String invoiceNumber;
  num grandTotal;
  num totalAmount;
  dynamic subTotal;
  dynamic orderDiscountValue;
  dynamic customerDiscount;
  dynamic customerGroupDiscount;
  dynamic outletId;
  String customerName;
  num collectionAmount;
  num salesItemsCount;
  num salesItemsSumDiscount;
  num salesItemsSumMrpPrice;
  List<SalesItem> salesItems;

  SaleModel({
    required this.id,
    required this.createdAt,
    required this.invoiceNumber,
    required this.grandTotal,
    required this.totalAmount,
    required this.subTotal,
    required this.orderDiscountValue,
    required this.customerDiscount,
    required this.customerGroupDiscount,
    required this.outletId,
    required this.customerName,
    required this.collectionAmount,
    required this.salesItemsCount,
    required this.salesItemsSumDiscount,
    required this.salesItemsSumMrpPrice,
    required this.salesItems,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json["id"],
      createdAt: json["created_at"],
      invoiceNumber: json["invoice_number"],
      grandTotal: json["grand_total"],
      subTotal: json["sub_total"],
      totalAmount: json["total_amount"],
      orderDiscountValue: json["order_discount_value"],
      customerDiscount: json["customer_discount"],
      customerGroupDiscount: json["customer_group_discount"],
      outletId: json["outlet_id"],
      customerName: json["customer_name"],
      collectionAmount: json["collection_amount"],
      salesItemsCount: json["sales_items_count"],
      salesItemsSumDiscount: json["sales_items_sum_discount"],
      salesItemsSumMrpPrice: json["sales_items_sum_mrp_price"],
      salesItems: List<SalesItem>.from(
          json['sales_items'].map((x) => SalesItem.fromJson(x))),
    );
  }
  @override
  String toString() =>
      'SaleModel{ id: $id, invoiceNumber: $invoiceNumber, grandTotal: $grandTotal, totalAmount: $totalAmount }';
}

class SalesItem {
  int id;
  int saleId;
  int productId;
  dynamic quantity;
  dynamic discount;
  num mrpPrice;
  num costPrice;
  num subTotal;
  Products products;

  SalesItem({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.quantity,
    required this.discount,
    required this.mrpPrice,
    required this.costPrice,
    required this.subTotal,
    required this.products,
  });

  factory SalesItem.fromJson(Map<String, dynamic> json) => SalesItem(
        id: json["id"],
        saleId: json["sale_id"],
        productId: json["product_id"],
        quantity: json["quantity"],
        discount: json["discount"],
        mrpPrice: json["mrp_price"],
        costPrice: json["cost_price"],
        subTotal: (json["mrp_price"] - json["discount"]) * json["quantity"],
        products: Products.fromJson(json["products"]),
      );

  @override
  String toString() =>
      'SalesItem{ id: $id, saleId: $saleId, productId: $productId, mrpPrice: $mrpPrice }';

  Map<String, dynamic> toJson() => {
        "id": id,
        "sale_id": saleId,
        "product_id": productId,
        "quantity": quantity,
        "discount": discount,
        "mrp_price": mrpPrice,
        "cost_price": costPrice,
        "products": products.toJson(),
      };
}

class Products {
  int id;
  String productName;
  String productCode;
  num mrpPrice;
  num costPrice;

  Products({
    required this.id,
    required this.productName,
    required this.productCode,
    required this.mrpPrice,
    required this.costPrice,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        id: json["id"],
        productName: json["product_name"],
        productCode: json["product_code"],
        mrpPrice: json["mrp_price"],
        costPrice: json["cost_price"]?.toDouble(),
      );

  @override
  String toString() =>
      'Products{ id: $id, productName: $productName, productCode: $productCode, mrpPrice: $mrpPrice }';

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "product_code": productCode,
        "mrp_price": mrpPrice,
        "cost_price": costPrice,
      };
}
