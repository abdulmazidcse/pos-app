import 'package:flutter/material.dart';

class SearchResultItem extends StatelessWidget {
  final String name;
  final double price;
  final String imageUrl;

  const SearchResultItem(
      {required this.name, required this.price, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Image.network(imageUrl, width: 50.0, height: 50.0),
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontSize: 16.0)),
              Text("${price.toStringAsFixed(2)}",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              // Add product to cart (implementation details in next step)
            },
          ),
        ],
      ),
    );
  }
}
