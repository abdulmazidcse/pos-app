import 'package:pos/Pos/Product.dart';

class CartItem {
  final Product product;
  int qty;
  double newPrice;

  CartItem({required this.product, required this.qty, required this.newPrice});
}
