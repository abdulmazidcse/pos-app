class CustomerListResponse {
  bool success;
  CustomerListData data;
  String message;

  CustomerListResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory CustomerListResponse.fromJson(Map<String, dynamic> json) {
    return CustomerListResponse(
      success: json['success'] ?? false,
      data: CustomerListData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

class CustomerListData {
  CustomerListPagination pagination;
  List<CustomerModel> products;

  CustomerListData({
    required this.pagination,
    required this.products,
  });

  factory CustomerListData.fromJson(Map<String, dynamic> json) {
    List<CustomerModel> sortedProducts = (json['data'] as List<dynamic>?)
            ?.map((product) => CustomerModel.fromJson(product))
            .toList() ??
        [];

    // Sort the products by id in descending order
    sortedProducts.sort((a, b) => b.id.compareTo(a.id));

    return CustomerListData(
      pagination: CustomerListPagination.fromJson(json['pagination'] ?? {}),
      products: sortedProducts,
    );
  }
}

class CustomerListPagination {
  int currentPage;
  int lastPage;
  int perPage;
  int total;

  CustomerListPagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory CustomerListPagination.fromJson(Map<String, dynamic> json) {
    return CustomerListPagination(
      currentPage: json['current_page'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class CustomerModel {
  int id;
  String name;
  String customerCode;
  dynamic customerGroupId;
  dynamic customerReceivableAccount;
  dynamic phone;
  dynamic email;
  dynamic address;

  CustomerModel({
    required this.id,
    required this.name,
    required this.customerCode,
    required this.customerGroupId,
    required this.customerReceivableAccount,
    required this.phone,
    required this.email,
    required this.address,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      customerCode: json['customer_code'] ?? '',
      customerGroupId: json['customer_group_id'] ?? '',
      customerReceivableAccount: json['customer_receivable_account'] ?? '',
      phone: json['phone'] ?? 0,
      email: json['email'] ?? 0,
      address: json['address'],
    );
  }

  @override
  String toString() {
    return 'CustomerModel{id: $id, Name: $name, code: $customerCode, phone: $phone, email: $email , address: $address}';
  }
}
