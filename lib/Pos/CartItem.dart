import 'package:pos/Pos/ProductModel.dart';

class CartItem {
  final Product product;
  int qty;
  num newPrice;
  num subtotal; // Subtotal property to store the subtotal value

  CartItem({
    required this.product,
    required this.qty,
    required this.newPrice,
  }) : subtotal = 0.0; // Initialize subtotal to 0.0 in the constructor
}
