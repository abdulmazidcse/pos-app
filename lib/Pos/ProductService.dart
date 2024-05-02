import 'package:pos/Pos/Product.dart';

class ProductService {
  // static List<Product> products = [
  //   Product(id: 1, name: 'Product 1', price: 10.00, qty: 0),
  //   Product(id: 2, name: 'Product 2', price: 15.50, qty: 0),
  // ];

  static List<Product> products = [];

  static Future<List<Product>> getProducts() async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay
    return products;
  }

  static Future<void> addProductToCart(Product product) async {
    // Implement your logic to add product to cart (e.g., update in-memory data store or send to server)
    print('Product ${product.productName} added to cart!');
  }
}
