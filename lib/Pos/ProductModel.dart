class Product {
  final int productId;
  final String productStockId;
  final dynamic outletId;
  final String productType;
  final String productName;
  final String productNativeName;
  final String productCode;
  final dynamic categoryId;
  final dynamic barcodeSymbology;
  final String minOrderQty;
  final double costPrice;
  final double depoPrice;
  final double mrpPrice;
  final int taxMethod;
  final double productTax;
  final int measuringUnit;
  final dynamic weight;
  final int itemDiscount;
  final dynamic discount;
  final int tax;
  final String quantity;
  final String stockQuantity;
  final dynamic expiresDate;
  final Map<String, dynamic> disArray;

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
  });

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
      costPrice: double.parse(json['cost_price']),
      depoPrice: double.parse(json['depo_price']),
      mrpPrice: double.parse(json['mrp_price']),
      taxMethod: int.parse(json['tax_method']),
      productTax: double.parse(json['product_tax']),
      measuringUnit: int.parse(json['measuring_unit']),
      weight: json['weight'],
      itemDiscount: json['item_discount'],
      discount: json['discount'],
      tax: json['tax'],
      quantity: json['quantity'],
      stockQuantity: json['stock_quantity'],
      expiresDate: json['expires_date'],
      disArray: json['dis_array'],
    );
  }
}
