import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:pos/Products/Product.dart';
import 'package:pos/Products/ProductModel.dart';
import 'package:pos/Sales/SaleModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  // static const String url = 'http://localhost:8000/api/';
  static const String url = 'https://backend.quickpossolution.com/api/';
  // static const String url = 'http://172.30.38.145:8000/api/'; // Office Net
  // static const String url = 'http://192.168.43.18:8000/api/'; // Mobile Net
  // static const String url = 'http://192.168.0.101:8000/api/'; // My Router
  final int perPage = 10;

  Future<ApiResponse> productSearchFetchData(String searchTerm) async {
    // var apiUrl = 'product/list?search=$searchTerm&column=0&dir=desc';
    var apiUrl = 'posproducts?search=$searchTerm';
    var fullUrl = url + apiUrl;

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
    var fullUrl = url + apiUrl;

    final urlParam = Uri.parse('$fullUrl&page=$page&length=$perPage');
    final response = await http.get(urlParam, headers: {
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
    var fullUrl = url + apiUrl;

    final urlParam = Uri.parse('$fullUrl&page=$page&length=$perPage');
    final response = await http.get(urlParam, headers: {
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

  Future<List<Customer>> fetchCustomers() async {
    final response = await http.get(Uri.parse('${Api.url}customers'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> customersJson = data['data'];
      return customersJson.map((json) => Customer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<List<SaleModel>> getSalesOrder({int page = 1, int perPage = 2}) async {
    var apiUrl = 'sale/list?search=&column=0&dir=desc';
    var fullUrl = url + apiUrl;

    final urlParam = Uri.parse('$fullUrl&page=$page&length=$perPage');
    final response = await http.get(urlParam, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${await _getToken()}',
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
    var fullUrl = url + apiUrl;
    fullUrl = url + apiUrl;
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
    String fullUrl;
    fullUrl = url + apiUrl;
    return await http
        .post(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      // ignore: prefer_interpolation_to_compose_strings
      'Authorization': 'Bearer ' + await _getToken()
    });
  }

  putData(data, apiUrl) async {
    String fullUrl;
    fullUrl = url + apiUrl;
    return await http.put(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      // ignore: prefer_interpolation_to_compose_strings
      'Authorization': 'Bearer ' + await _getToken()
    });
  }

  Future<http.Response> getData(String apiUrl,
      {int page = 0, int perPage = 0}) async {
    var fullUrl = url + apiUrl;

    // Build query parameters
    Map<String, String> queryParams = {};
    if (page != 0) {
      queryParams['page'] = page.toString();
    }
    if (perPage != 0) {
      queryParams['length'] = perPage.toString();
    }

    // Append query parameters to the URL
    final uri = Uri.parse(fullUrl).replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      // ignore: prefer_interpolation_to_compose_strings
      'Authorization': 'Bearer ' + await _getToken()
    });
    return response;
  }

  login(data, apiUrl) async {
    String fullUrl;
    fullUrl = url + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeadersWithout());
  }

  static Future<String> getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return token ?? '';
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
