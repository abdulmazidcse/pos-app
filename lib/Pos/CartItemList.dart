import 'package:flutter/material.dart';
import 'package:pos/Pos/CartProvider.dart';
import 'package:provider/provider.dart';

class CartItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the cart items from the CartProvider
    final cartItems = Provider.of<CartProvider>(context).cartItems;

    return Expanded(
      child: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = cartItems[index];
          return ListTile(
            title: Text(cartItem.product.productName),
            // Display quantity and editable price
            subtitle: Row(
              children: [
                Text('Qty: ${cartItem.qty}'),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 35, // Set the desired height
                    width: 50, // Set the desired width
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        // Update the price in the cart item
                        final newPrice = double.tryParse(value) ?? 0;
                        cartItem.newPrice = newPrice;
                        // Notify listeners to rebuild the UI
                        Provider.of<CartProvider>(context, listen: false)
                            .notifyListeners();
                      },
                      decoration: InputDecoration(
                        labelText: 'Price',
                        hintText: 'Enter price',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text('Subtotal: ${cartItem.newPrice * cartItem.qty}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
