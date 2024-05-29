class Customer {
  final int id;
  final String customerCode;
  final String name;
  final String email;
  final String phone;
  final String address;

  Customer({
    required this.id,
    required this.customerCode,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      customerCode: json['customer_code'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }

  @override
  @override
  String toString() {
    return 'Customer{id: $id, Name: $name, code: $customerCode, phone: $phone, email: $email , address: $address}';
  }
}
