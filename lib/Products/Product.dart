import 'dart:convert';
import '../utils/Api.dart';

Future<List<Product>> fetchProducts(String searchTerm) async {
  final response = await Api().productSearchFetchData(searchTerm);
  if (response.success) {
    final productsData = response.data;
    if (productsData != null) {
      if (productsData is List) {
        return productsData
            .map((product) => Product.fromJson(product))
            .toList();
      } else if (productsData is Map) {
        // Assuming 'data' key holds the actual product data (modify if needed)
        final productData = productsData['data'];
        if (productData is List) {
          return productData
              .map((product) => Product.fromJson(product))
              .toList();
        } else if (productData is Map) {
          // Check if the 'data' field is a Map
          if (productData is Map<String, dynamic>) {
            // If it's a Map, parse the product data
            final productsDataData = productData['data'];
            // print(productsDataData);
            if (productsDataData is List) {
              return productsDataData
                  .map((product) => Product.fromJson(product))
                  .toList();
            } else {
              // Handle the case when 'data' field is not a List
              throw Exception('Data is not in the expected format');
            }
          } else {
            // Handle the case when 'data' field is not a Map
            throw Exception('Data is not in the expected format');
          }

          // return [Product.fromJson(productData as Map<String, dynamic>)];
        } else {
          throw Exception('Unexpected data format in response');
        }
      } else {
        throw Exception('Unexpected data format in response');
      }
    } else {
      throw Exception('Failed to fetch products'); // or handle differently
    }
  } else {
    throw Exception(response.message); // Use error message from ApiResponse
  }
}

Future<List<Product>> parseProductsResponse(String response) async {
  final data = jsonDecode(response) as Map<String, dynamic>;
  if (data['success'] as bool) {
    final productList = data['data']['data'] as List;
    return productList.map((item) => Product.fromJson(item)).toList();
  } else {
    throw Exception(data['message']); // Handle API errors
  }
}

class Product {
  final int id;
  final String productName;
  final String productNativeName;
  final String productCode;
  final dynamic categoryId;
  final dynamic subCategoryId;
  final dynamic brandId;
  final dynamic barcodeSymbology;
  final dynamic minOrderQty;
  final String costPrice;
  final String depoPrice;
  final String mrpPrice;
  final dynamic abpPrice;
  final dynamic abpQty;
  final dynamic taxMethod;
  final dynamic productTax;
  final dynamic alertQuantity;
  final dynamic thumbnail;
  final dynamic shortDescription;
  final dynamic description;
  final dynamic purchaseMeasuringUnit;
  final dynamic salesMeasuringUnit;
  final dynamic convertionRate;
  final dynamic cartonSize;
  final dynamic cartonCpu;
  final String quantity;
  final dynamic status;
  final dynamic discount;
  final Category category;

  Product({
    required this.id,
    required this.productName,
    required this.productNativeName,
    required this.productCode,
    required this.categoryId,
    required this.subCategoryId,
    required this.brandId,
    required this.barcodeSymbology,
    required this.minOrderQty,
    required this.costPrice,
    required this.depoPrice,
    required this.mrpPrice,
    required this.abpPrice,
    required this.abpQty,
    required this.taxMethod,
    required this.productTax,
    required this.alertQuantity,
    required this.thumbnail,
    required this.shortDescription,
    required this.description,
    required this.purchaseMeasuringUnit,
    required this.salesMeasuringUnit,
    required this.convertionRate,
    required this.cartonSize,
    required this.cartonCpu,
    required this.quantity,
    required this.status,
    required this.discount,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productName: json['product_name'],
      productNativeName: json['product_native_name'],
      productCode: json['product_code'],
      categoryId: json['category_id'],
      subCategoryId: json['sub_category_id'],
      brandId: json['brand_id'],
      barcodeSymbology: json['barcode_symbology'],
      minOrderQty: json['min_order_qty'],
      costPrice: json['cost_price'],
      depoPrice: json['depo_price'],
      mrpPrice: json['mrp_price'],
      abpPrice: json['abp_price'],
      abpQty: json['abp_qty'],
      taxMethod: json['tax_method'],
      productTax: json['product_tax'],
      alertQuantity: json['alert_quantity'],
      thumbnail: json['thumbnail'],
      shortDescription: json['short_description'],
      description: json['description'],
      purchaseMeasuringUnit: json['purchase_measuring_unit'],
      salesMeasuringUnit: json['sales_measuring_unit'],
      convertionRate: json['convertion_rate'],
      cartonSize: json['carton_size'],
      cartonCpu: json['carton_cpu'],
      quantity: json['quantity'],
      status: json['status'],
      discount: json['discount'],
      category: Category.fromJson(json['category']),
    );
  }
}

class Category {
  final dynamic id;
  final String name;
  final String imgUrl;

  Category({required this.id, required this.name, required this.imgUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      imgUrl: json['img_url'],
    );
  }
}

class ApiResponse {
  final bool success;
  final dynamic data;
  final String message;

  ApiResponse(
      {required this.success, required this.data, required this.message});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'],
      data: json['data'],
      message: json['message'],
    );
  }
}
