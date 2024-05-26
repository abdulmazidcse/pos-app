import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/Api.dart';
import 'CustomerModel.dart';

class CustomerController {
  Future<List<CustomerModel>> getCustomers(
      {int page = 1, int perPage = 10}) async {
    var apiUrl = 'customers/list?search=&column=1&dir=desc';
    var fullUrl = Api.url + apiUrl;

    final url = Uri.parse('$fullUrl&page=$page&length=$perPage');
    final response = await http.get(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      // ignore: prefer_interpolation_to_compose_strings
      'Authorization': 'Bearer ' + await Api.getToken()
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final productsData = responseBody['data']['data']['data'];

      if (productsData is List) {
        return productsData
            .map((product) => CustomerModel.fromJson(product))
            .toList();
      } else {
        throw Exception('Failed to fetch customer: Unexpected data format');
      }
    } else {
      throw Exception('Failed to load customer: ${response.statusCode}');
    }
  }
}
