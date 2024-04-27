import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  final String _url = 'https://inventory.kathergolpo.com/backend/api/';

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
