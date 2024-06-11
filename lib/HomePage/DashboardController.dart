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
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // print("Error fetching data: $error");
      rethrow;
    }
  }
}


// class DashboardController with ChangeNotifier {
//   bool _isLoading = false;
//   DashboardModel? _dashboardData;

//   bool get isLoading => _isLoading;
//   DashboardModel? get dashboardData => _dashboardData;

//   Future<void> fetchData() async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final response = await Api().getData('dashboard');
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         print('API Response: $data'); // Log the API response
//         _dashboardData = DashboardModel.fromJson(data);
//         print('Parsed Data: $_dashboardData'); // Log the parsed data
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (error) {
//       print("Error fetching data: $error");
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
