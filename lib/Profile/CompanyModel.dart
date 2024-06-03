class Company {
  final int id;
  final String name;
  final String address;
  final String contactPersonName;
  final String contactPersonNumber;
  final int status;

  Company({
    required this.id,
    required this.name,
    required this.address,
    required this.contactPersonName,
    required this.contactPersonNumber,
    required this.status,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      contactPersonName: json['contact_person_name'],
      contactPersonNumber: json['contact_person_number'],
      status: json['status'],
    );
  }

  @override
  String toString() {
    return 'Company{id: $id, Name: $name, Address: $address}';
  }
}
