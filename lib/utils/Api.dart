import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
// import 'package:http/http.dart';
import 'package:pos/Products/Product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  final String _url = 'https://inventory.kathergolpo.com/backend/api/';
  final String url = 'https://inventory.kathergolpo.com/backend/api/';

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

  _setHeadersWithout() =>
      {'Content-type': 'application/json', 'Accept': 'application/json'};
  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + _getToken(),
      };
}
