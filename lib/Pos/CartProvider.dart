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

  void updateCartItemPrice(CartItem item, double newPrice) {
    // Update the price of the specified cart item
    item.product.newPrice = newPrice;
    item.subtotal = item.qty * newPrice;
    // Recalculate the net amount after updating the price
    _calculateNetAmount();
  }

  void removeCartItem(CartItem item) {
    _cartItems.remove(item);
    _calculateNetAmount();
    notifyListeners();
  }

  void updateCartItemQuantity(CartItem item, int newQuantity) {
    if (newQuantity > 0) {
      item.qty = newQuantity;
      // item.product.newPrice = newPrice; // Update the price as well
      _calculateNetAmount();
      notifyListeners();
    }
  }

  void _calculateNetAmount() {
    _netAmount = 0.00;
    for (var item in _cartItems) {
      final price = item.product.newPrice != null
          ? item.product.newPrice
          : item.product.mrpPrice;
      final subtotal = (price * item.qty);
      item.subtotal = subtotal; // Update the subtotal for the current item
      _netAmount += subtotal;
    }
    notifyListeners(); // Notify listeners after updating net amount
  }
}
