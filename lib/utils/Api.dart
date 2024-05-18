import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
// import 'package:http/http.dart';
import 'package:pos/Products/Product.dart';
import 'package:pos/Products/ProductModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  // final String _url = 'https://inventory.kathergolpo.com/backend/api/';
  static const String _url = 'http://192.168.31.135:8000/api/';
  static const String url = 'http://192.168.31.135:8000/api/';
  final int perPage = 10;
  //static const String baseUrl = "http://your_api_domain/"; // Replace with your API base URL
  //static const String registerUrl = baseUrl + "register"; // Replace with your API endpoint for registration

  // final String url = 'https://inventory.kathergolpo.com/backend/api/';
  // final String url2 = 'http://192.168.31.135:8000/';

  _dGET(apiUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token').toString();
    var fullUrl = _url + apiUrl;
    // print(token);
    return await http.get(Uri.parse(fullUrl), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
  }

  Future<ApiResponse> productSearchFetchData(String searchTerm) async {
    // var apiUrl = 'product/list?search=$searchTerm&column=0&dir=desc';
    var apiUrl = 'posproducts?search=$searchTerm';
    var fullUrl = _url + apiUrl;

    final response = await http.get(Uri.parse(fullUrl), headers: {
      'Accept': 'application/json',
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
      'Authorization': 'Bearer ' + await _getToken()
    });
  }

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
    final user_info = localStorage.getString('user').toString();
    return user_info;
  }

  _setHeadersWithout() =>
      {'Content-type': 'application/json', 'Accept': 'application/json'};
  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + _getToken(),
      };
}
