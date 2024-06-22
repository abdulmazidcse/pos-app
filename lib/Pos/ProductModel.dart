class Product {
  final int productId;
  final int productStockId;
  final dynamic outletId;
  final String productType;
  final String productName;
  final String productNativeName;
  final String productCode;
  final int categoryId;
  final dynamic barcodeSymbology;
  final dynamic minOrderQty;
  final num costPrice;
  final num depoPrice;
  final num mrpPrice;
  final int taxMethod;
  final int productTax;
  final int measuringUnit;
  final dynamic weight;
  final dynamic itemDiscount;
  final dynamic discount;
  final int tax;
  final dynamic quantity;
  final dynamic stockQuantity;
  final dynamic expiresDate;
  final Map<String, dynamic> disArray;

  // Price that can be changed
  num newPrice;

  Product({
    required this.productId,
    required this.productStockId,
    required this.outletId,
    required this.productType,
    required this.productName,
    required this.productNativeName,
    required this.productCode,
    required this.categoryId,
    required this.barcodeSymbology,
    required this.minOrderQty,
    required this.costPrice,
    required this.depoPrice,
    required this.mrpPrice,
    required this.taxMethod,
    required this.productTax,
    required this.measuringUnit,
    required this.weight,
    required this.itemDiscount,
    required this.discount,
    required this.tax,
    required this.quantity,
    required this.stockQuantity,
    required this.expiresDate,
    required this.disArray,
    required this.newPrice,
  });

  // Setter for mrpPrice
  // Method to change the price
  void changePrice(num price) {
    // mrpPrice = price;
    newPrice = price; // Update the new price property
  }

  // set mrpPrice(double price) {
  //   mrpPrice = price;
  // }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'],
      productStockId: json['product_stock_id'],
      outletId: json['outlet_id'],
      productType: json['product_type'],
      productName: json['product_name'],
      productNativeName: json['product_native_name'],
      productCode: json['product_code'],
      categoryId: json['category_id'],
      barcodeSymbology: json['barcode_symbology'],
      minOrderQty: json['min_order_qty'],
      costPrice: json['cost_price'],
      depoPrice: json['depo_price'],
      mrpPrice: json['mrp_price'],
      taxMethod: json['tax_method'],
      productTax: json['product_tax'],
      measuringUnit: json['measuring_unit'] ?? '',
      weight: json['weight'],
      itemDiscount: json['item_discount'],
      discount: json['discount'],
      tax: json['tax'],
      quantity: json['quantity'],
      stockQuantity: json['stock_quantity'],
      expiresDate: json['expires_date'],
      disArray: json['dis_array'],
      newPrice: json['mrp_price'],
    );
  }
}
