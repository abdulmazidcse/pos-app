// To parse this JSON data, do
//
//     final InvoiceModel = InvoiceModelFromJson(jsonString);

class InvoiceModel {
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
  dynamic collectionAmount;
  CustomerMdl customer;
  Outlet outlet;
  CreatedBy createdBy;
  List<SalesItem> salesItems;

  InvoiceModel({
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
    required this.salesItems,
    required this.customer,
    required this.outlet,
    required this.createdBy,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
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
      salesItems: List<SalesItem>.from(
          json['sales_items'].map((x) => SalesItem.fromJson(x))),
      customer: CustomerMdl.fromJson(json["customer"]),
      outlet: Outlet.fromJson(json["outlets"]),
      createdBy: CreatedBy.fromJson(json["created_by"]),
    );
  }
  @override
  String toString() =>
      'InvoiceModel{ id: $id, invoiceNumber: $invoiceNumber, grandTotal: $grandTotal, totalAmount: $totalAmount }';
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

class CustomerMdl {
  int id;
  String name;
  dynamic email;
  dynamic phone;
  dynamic address;

  CustomerMdl({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory CustomerMdl.fromJson(Map<String, dynamic> json) => CustomerMdl(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
      );

  @override
  String toString() =>
      'CustomerMdl{ id: $id, name: $name, email: $email, phone: $phone }';

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
      };
}

class Outlet {
  int id;
  dynamic name;
  dynamic address;
  dynamic outletNumber;

  Outlet({
    required this.id,
    required this.name,
    required this.address,
    required this.outletNumber,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) => Outlet(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        outletNumber: json["outlet_number"],
      );

  @override
  String toString() =>
      'CustomerMdl{ id: $id, name: $name, address: $address, phone: $outletNumber }';

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "outlet_number": outletNumber,
      };
}

class CreatedBy {
  int id;
  String name;
  String email;
  String phone;

  CreatedBy({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
      );

  @override
  String toString() =>
      'CustomerMdl{ id: $id, name: $name, email: $email, phone: $phone }';

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
      };
}
