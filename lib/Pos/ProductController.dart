import 'dart:convert';
import '../utils/Api.dart';
import 'ProductModel.dart';

class ProductController {
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
}
