class ProductListResponse {
  bool success;
  ProductListData data;
  String message;

  ProductListResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      success: json['success'] ?? false,
      data: ProductListData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

class ProductListData {
  ProductListPagination pagination;
  List<ProductModel> products;

  ProductListData({
    required this.pagination,
    required this.products,
  });

  factory ProductListData.fromJson(Map<String, dynamic> json) {
    return ProductListData(
      pagination: ProductListPagination.fromJson(json['pagination'] ?? {}),
      products: (json['data'] as List<dynamic>?)
              ?.map((product) => ProductModel.fromJson(product))
              .toList() ??
          [],
    );
  }
}

class ProductListPagination {
  int currentPage;
  int lastPage;
  int perPage;
  int total;

  ProductListPagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory ProductListPagination.fromJson(Map<String, dynamic> json) {
    return ProductListPagination(
      currentPage: json['current_page'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class ProductModel {
  int id;
  String productName;
  String productNativeName;
  String productCode;
  int categoryId;
  int subCategoryId;
  dynamic brandId;
  // dynamic barcodeSymbology;
  dynamic minOrderQty;
  num costPrice;
  num depoPrice;
  num mrpPrice;
  // dynamic abpPrice;
  // dynamic abpQty;
  int taxMethod;
  int productTax;
  // dynamic alertQuantity;
  // dynamic thumbnail;
  // dynamic shortDescription;
  // dynamic description;
  // dynamic purchaseMeasuringUnit;
  // dynamic salesMeasuringUnit;
  // dynamic convertionRate;
  // dynamic cartonSize;
  // dynamic cartonCpu;
  int quantity;
  int status;
  int discount;
  // CategoryModel category;

  ProductModel({
    required this.id,
    required this.productName,
    required this.productNativeName,
    required this.productCode,
    required this.categoryId,
    required this.subCategoryId,
    required this.brandId,
    // required this.barcodeSymbology,
    required this.minOrderQty,
    required this.costPrice,
    required this.depoPrice,
    required this.mrpPrice,
    // required this.abpPrice,
    // required this.abpQty,
    required this.taxMethod,
    required this.productTax,
    // required this.alertQuantity,
    // required this.thumbnail,
    // required this.shortDescription,
    // required this.description,
    // required this.purchaseMeasuringUnit,
    // required this.salesMeasuringUnit,
    // required this.convertionRate,
    // required this.cartonSize,
    // required this.cartonCpu,
    required this.quantity,
    required this.status,
    required this.discount,
    // required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      productName: json['product_name'] ?? '',
      productNativeName: json['product_native_name'] ?? '',
      productCode: json['product_code'] ?? '',
      categoryId: json['category_id'] ?? 0,
      subCategoryId: json['sub_category_id'] ?? 0,
      brandId: json['brand_id'],
      // barcodeSymbology: json['barcode_symbology'],
      minOrderQty: json['min_order_qty'] ?? 0,
      costPrice: json['cost_price'] ?? 0,
      depoPrice: json['depo_price'] ?? 0,
      mrpPrice: json['mrp_price'] ?? 0,
      // abpPrice: json['abp_price'] ?? 0,
      // abpQty: json['abp_qty'] ?? 0,
      taxMethod: json['tax_method'] ?? 0,
      productTax: json['product_tax'] ?? 0,
      // alertQuantity: json['alert_quantity'],
      // thumbnail: json['thumbnail'],
      // shortDescription: json['short_description'],
      // description: json['description'],
      // purchaseMeasuringUnit: json['purchase_measuring_unit'],
      // salesMeasuringUnit: json['sales_measuring_unit'],
      // convertionRate: json['convertion_rate'],
      // cartonSize: json['carton_size'],
      // cartonCpu: json['carton_cpu'],
      quantity: json['quantity'] ?? 0,
      status: json['status'] ?? 0,
      discount: json['discount'] ?? 0,
      // category: CategoryModel.fromJson(json['category'] ?? {}),
    );
  }

  @override
  String toString() {
    return 'ProductModel{id: $id, productName: $productName, productCode: $productCode, costPrice: $costPrice, mrpPrice: $mrpPrice}';
  }
}

class CategoryModel {
  int id;
  String name;
  String imgUrl;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imgUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imgUrl: json['img_url'] ?? '',
    );
  }
}
