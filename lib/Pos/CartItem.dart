import 'package:pos/Pos/ProductModel.dart';

class CartItem {
  final Product product;
  int qty;
  double newPrice;

  CartItem({required this.product, required this.qty, required this.newPrice});
}
