import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../utils/Api.dart';
import 'ProductModel.dart';

class ProductController {
  Future<List<ProductModel>> getProducts(
      {int page = 1, int perPage = 10}) async {
    var apiUrl = 'product/list?search=&column=0&dir=desc';
    var fullUrl = Api.url + apiUrl;

    final url = Uri.parse('$fullUrl&page=$page&length=$perPage');
    final response = await http.get(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await Api.getToken()}'
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final productsData = responseBody['data']['data']['data'];

      if (productsData is List) {
        return productsData
            .map((product) => ProductModel.fromJson(product))
            .toList();
      } else {
        throw Exception('Failed to fetch product: Unexpected data format');
      }
    } else {
      throw Exception('Failed to load product: ${response.statusCode}');
    }
  }

  Future<bool> updateProduct(ProductModel product) async {
    final apiUrl = 'products/${product.id}';
    final fullUrl = Api.url + apiUrl;
    final response = await http.put(
      Uri.parse(fullUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await Api.getToken()}',
      },
      body: jsonEncode({
        'name': product.productName,
        'product_type': 'standard',
        'product_name': product.productName,
        'product_native_name': product.productName,
        'product_code': product.productCode,
        'cost_price': product.costPrice,
        'mrp_price': product.mrpPrice,
        'category_id': 8,
        'sub_category_id': 9,
        'min_order_qty': 1,
        'tax_method': 1,
        'product_tax': 1,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteProduct(int productId) async {
    final apiUrl = 'products/$productId';
    final fullUrl = Api.url + apiUrl;
    final response = await http.delete(
      Uri.parse(fullUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await Api.getToken()}',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
