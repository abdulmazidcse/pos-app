import 'package:flutter/foundation.dart';
import 'package:pos/Pos/CartItem.dart';
import 'package:pos/Pos/ProductModel.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];
  double _netAmount = 0.00;

  List<CartItem> get cartItems => _cartItems;
  double get netAmount => _netAmount;

  void addToCart(Product product) {
    final existingItemIndex = _cartItems
        .indexWhere((item) => item.product.productId == product.productId);

    if (existingItemIndex != -1) {
      _cartItems[existingItemIndex].qty++;
    } else {
      _cartItems.add(CartItem(product: product, qty: 1, newPrice: 0));
    }
    _calculateNetAmount();
    notifyListeners();
  }

  void removeCartItem(CartItem item) {
    _cartItems.remove(item);
    _calculateNetAmount();
    notifyListeners();
  }

  void updateCartItemQuantity(CartItem item, int newQuantity, double newPrice) {
    if (newQuantity > 0) {
      item.qty = newQuantity;
      _calculateNetAmount();
      notifyListeners();
    }
  }

  void _calculateNetAmount() {
    _netAmount = 0.00;
    // for (var item in _cartItems) {
    //   final price = double.tryParse(item.product.mrpPrice) ??
    //       0.0; // Handle potential conversion failure
    //   _netAmount += price * item.qty;
    // }
  }
}
