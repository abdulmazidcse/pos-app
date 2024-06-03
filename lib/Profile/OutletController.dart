import 'dart:convert';
import 'package:pos/utils/Api.dart';
import 'OutletModel.dart'; // Ensure the path is correct
import 'CompanyModel.dart'; // Ensure the path is correct

class OutletController {
  Future<Outlet> fetchOutlet() async {
    const url = 'outlet';
    final response = await Api().getData(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['success'] == true) {
        final Map<String, dynamic> outletJson = data['data'];
        return Outlet.fromJson(outletJson);
      } else {
        throw Exception(
            'Failed to fetch outlet. Message: ${data['message'] ?? 'Unknown error'}');
      }
    } else {
      throw Exception(
          'Failed to fetch outlet. Status code: ${response.statusCode}');
    }
  }

  Future<bool> updateOutlet(outlet, outletId) async {
    var outletBody = {
      'name': outlet.name,
      'company_id': outlet.companyId.toString(),
      'contact_person_name': outlet.contactPersonName,
      'outlet_number': outlet.outletNumber,
      'district_id': outlet.districtId.toString(),
      'police_station': outlet.policeStation,
      'road_no': outlet.roadNo,
      'plot_no': outlet.plotNo,
      'latitude': outlet.latitude,
      'longitude': outlet.longitude,
      'address': outlet.addrs,
    };
    String url = 'outlets/$outletId';
    final response = await Api().putData(outletBody, url);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Company> fetchCompany(companyId) async {
    String url = 'companies/$companyId';
    print(url);
    final response = await Api().getData(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['success'] == true) {
        final Map<String, dynamic> outletJson = data['data'];
        return Company.fromJson(outletJson);
      } else {
        throw Exception(
            'Failed to fetch company. Message: ${data['message'] ?? 'Unknown error'}');
      }
    } else {
      throw Exception(
          'Failed to fetch company. Status code: ${response.statusCode}');
    }
  }

  // Future<Outlet> updateCompany(Company data, companyId) async {
  //   var companyBody = {
  //     'name': data.name,
  //     'contact_person_name': data.contactPersonName,
  //     'contact_person_number': data.contactPersonNumber,
  //     'status': data.status,
  //     'address': data.address,
  //   };
  //   var url = 'companies/$companyId';
  //   final response = await Api().putData(companyBody, url);
  // if (response.statusCode == 200) {
  //   final Map<String, dynamic> updatedCompanyJson = jsonDecode(response.body);
  //   return Outlet.fromJson(updatedCompanyJson); // Return updated outlet
  // } else {
  //   throw Exception(
  //       'Failed to update company. Status code: ${response.statusCode}');
  // }
  // }

  Future<bool> updateCompany(Company data, comapanyId) async {
    dynamic companyBody = {
      'name': data.name,
      'contact_person_name': data.contactPersonName,
      'contact_person_number': data.contactPersonNumber,
      'status': data.status,
      'address': data.address,
    };
    var url = 'companies/$comapanyId';
    final response = await Api().putData(companyBody, url);
    print(response.body.toString());
    // if (response.statusCode == 200) {
    //   // final Map<String, dynamic> updatedCompanyJson = jsonDecode(response.body);
    //   return jsonDecode(response.body);
    //   // return Company.fromJson(updatedCompanyJson); // Return updated outlet
    // } else {
    //   throw Exception(
    //       'Failed to update company. Status code: ${response.statusCode}');
    // }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
