class Outlet {
  final int id;
  final int companyId;
  final String name;
  final String contactPersonName;
  final String outletNumber;
  final int districtId;
  final String districtName;
  final int areaId;
  final String areaName;
  final String policeStation;
  final String roadNo;
  final String plotNo;
  final String latitude;
  final String longitude;
  final String address;
  final int status;
  final String addrs;
  // final Company? company;

  Outlet({
    required this.id,
    required this.companyId,
    required this.name,
    required this.contactPersonName,
    required this.outletNumber,
    required this.districtId,
    required this.districtName,
    required this.areaId,
    required this.areaName,
    required this.policeStation,
    required this.roadNo,
    required this.plotNo,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.status,
    required this.addrs,
    // this.company,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) => Outlet(
        id: json['id'] as int,
        companyId: json['company_id'] as int,
        name: json['name'] as String,
        contactPersonName: json['contact_person_name'] as String,
        outletNumber: json['outlet_number'] as String,
        districtId: json['district_id'] as int,
        districtName: json['district_name'] as String,
        areaId: json['area_id'] as int,
        areaName: json['area_name'] as String,
        policeStation: json['police_station'] as String,
        roadNo: json['road_no'] as String,
        plotNo: json['plot_no'] as String,
        latitude: json['latitude'] as String,
        longitude: json['longitude'] as String,
        address: json['address'] as String,
        status: json['status'] as int,
        addrs: json['addrs'] as String,
        // company: json['company'] != null
        //     ? Company.fromJson(json['company'] as Map<String, dynamic>)
        //     : null,
      );

  @override
  String toString() {
    return 'Outlet{id: $id, Name: $name, Address: $address}';
  }
}

// class Company {
//   final int id;
//   final String name;
//   final String address;
//   final String contactPersonName;
//   final String contactPersonNumber;
//   final int status;

//   Company({
//     required this.id,
//     required this.name,
//     required this.address,
//     required this.contactPersonName,
//     required this.contactPersonNumber,
//     required this.status,
//   });

//   factory Company.fromJson(Map<String, dynamic> json) => Company(
//         id: json['id'] as int,
//         name: json['name'] as String,
//         address: json['address'] as String,
//         contactPersonName: json['contact_person_name'] as String,
//         contactPersonNumber: json['contact_person_number'] as String,
//         status: json['status'] as int,
//       );

//   @override
//   String toString() {
//     return 'Company{id: $id, Name: $name, Address: $address}';
//   }
// }
