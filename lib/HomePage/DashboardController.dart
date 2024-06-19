import 'dart:convert';
import 'package:pos/utils/Api.dart';
import 'DashboardModel.dart';

class DashboardController {
  Future<DashboardModel> fetchData() async {
    try {
      final response = await Api().getData('dashboard');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final resData = data['data'];
        return DashboardModel.fromJson(resData);
      } else {
        // print('Failed to fetch data: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // print("Error fetching data: $error");
      rethrow;
    }
  }
}
