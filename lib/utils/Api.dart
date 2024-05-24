import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:pos/Products/Product.dart';
import 'package:pos/Products/ProductModel.dart';
import 'package:pos/Sales/SaleModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  // final String _url = 'https://inventory.kathergolpo.com/backend/api/';
  // static const String _url = 'http://172.30.38.145:8000/api/';
  // static const String url = 'http://172.30.38.145:8000/api/';
  static const String _url = 'http://192.168.31.135:8000/api/';
  static const String url = 'http://192.168.31.135:8000/api/';
  // static const String _url = 'https://inventory.kathergolpo.com/backend/api/';
  // static const String url = 'https://inventory.kathergolpo.com/backend/api/';
  final int perPage = 10;

  Future<ApiResponse> productSearchFetchData(String searchTerm) async {
    // var apiUrl = 'product/list?search=$searchTerm&column=0&dir=desc';
    var apiUrl = 'posproducts?search=$searchTerm';
    var fullUrl = _url + apiUrl;

    final response = await http.get(Uri.parse(fullUrl), headers: {
      'Accept': 'application/json',
      // ignore: prefer_interpolation_to_compose_strings
      'Authorization': 'Bearer ' + await _getToken()
    });

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // print('ApiResponse.fromJson(jsonResponse)');
      return ApiResponse.fromJson(jsonResponse);
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load data');
    }
  }

  Future<List<ProductModel>> getProducts(
      {int page = 1, int perPage = 10}) async {
    var apiUrl = 'product/list?search=&column=0&dir=desc';
    var fullUrl = _url + apiUrl;

    final url = Uri.parse('$fullUrl&page=$page&length=$perPage');
    final response = await http.get(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      // ignore: prefer_interpolation_to_compose_strings
      'Authorization': 'Bearer ' + await _getToken()
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final productsData = responseBody['data']['data']['data'];

      if (productsData is List) {
        return productsData
            .map((product) => ProductModel.fromJson(product))
            .toList();
      } else {
        throw Exception('Failed to fetch products: Unexpected data format');
      }
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  Future<List<SaleModel>> fetchSales({int page = 1, int perPage = 10}) async {
    var apiUrl = 'orderlist-app?search=&column=0&dir=desc';
    var fullUrl = _url + apiUrl;

    final url = Uri.parse('$fullUrl&page=$page&length=$perPage');
    final response = await http.get(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      // ignore: prefer_interpolation_to_compose_strings
      'Authorization': 'Bearer ' + await _getToken()
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final productsData = responseBody['data']['data']['data'];

      if (productsData is List) {
        return productsData
            .map((product) => SaleModel.fromJson(product))
            .toList();
      } else {
        throw Exception('Failed to fetch products: Unexpected data format');
      }
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

  // Future<SaleModel> fetchSales({int page = 1, int perPage = 1}) async {
  //   var apiUrl = 'sale/list?search=&column=0&dir=desc';
  //   var fullUrl = _url + apiUrl;
  //   final url = Uri.parse('$fullUrl&page=$page&length=$perPage');
  //   final response = await http.get(url, headers: {
  //     'Content-type': 'application/json',
  //     'Accept': 'application/json',
  //     // ignore: prefer_interpolation_to_compose_strings
  //     'Authorization': 'Bearer ' + await _getToken(),
  //   });

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> responseBody = json.decode(response.body);
  //     final salesData = responseBody['data']['data']['data'];

  //     if (salesData is List) {
  //       return salesData.map((orders) => SaleModel.fromJson(orders)).toList();
  //     } else {
  //       throw Exception('Failed to fetch products: Unexpected data format');
  //     }
  //   } else {
  //     // Handle API errors
  //     throw Exception('Failed to fetch sales data');
  //   }
  // }

  Future<List<SaleModel>> getSalesOrder({int page = 1, int perPage = 2}) async {
    var apiUrl = 'sale/list?search=&column=0&dir=desc';
    var fullUrl = _url + apiUrl;

    final url = Uri.parse('$fullUrl&page=$page&length=$perPage');
    final response = await http.get(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + await _getToken(),
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final productsData = responseBody['data']['data']['data'];

      if (productsData is List) {
        return productsData
            .map((product) => SaleModel.fromJson(product))
            .toList();
      } else {
        throw Exception('Failed to fetch products: Unexpected data format');
      }
    } else {
      throw Exception('Failed to load sales data: ${response.statusCode}');
    }
  }

  Future<ApiResponse> registerUser(String data, String apiUrl) async {
    var fullUrl = _url + apiUrl;
    fullUrl = _url + apiUrl;
    final response =
        await http.post(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer '
    });
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // print('ApiResponse.fromJson(jsonResponse)');
      return ApiResponse.fromJson(jsonResponse);
    } else {
      //return response;
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load data');
    }
  }

  postData(data, apiUrl) async {
    var fullUrl;
    fullUrl = _url + apiUrl;
    return await http
        .post(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      // ignore: prefer_interpolation_to_compose_strings
      'Authorization': 'Bearer ' + await _getToken()
    });
  }

  // Future<void> login(data, apiUrl) async {
  //   final url = Uri.parse('http://192.168.31.135:8000/api/auth/login');
  //   try {
  //     final response = await http.post(url,
  //         body: jsonEncode(data), headers: _setHeadersWithout());
  //     if (response.statusCode == 200) {
  //       return response;
  //     } else {
  //       // Handle error
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  login(data, apiUrl) async {
    var fullUrl;
    fullUrl = _url + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeadersWithout());
  }

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token').toString();
    return token;
  }

  userInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    return localStorage.getString('user').toString();
  }

  _setHeadersWithout() =>
      {'Content-type': 'application/json', 'Accept': 'application/json'};
}
