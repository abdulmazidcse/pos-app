import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  final List<Order> orders = [
    Order(
      id: "#652035",
      name: "Mazid",
      phone: "+8801821915515",
      address: "333 Segunbagicha Dhaka, Shahbagh, Dhaka City, Dhaka",
      date: "Dec 13, 2023, 7:00 PM",
      status: "Cancelled",
      amount: 958,
    ),
    Order(
      id: "#652029",
      name: "Mazid",
      phone: "+8801821915515",
      address: "333 Segunbagicha Dhaka, Shahbagh, Dhaka City, Dhaka",
      date: "Dec 13, 2023, 6:56 PM",
      status: "Cancelled",
      amount: 958,
    ),
  ];

  OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return OrderCard(order: orders[index]);
        },
      ),
    );
  }
}

class Order {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String date;
  final String status;
  final int amount;

  Order({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.date,
    required this.status,
    required this.amount,
  });
}

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order ID: ${order.id}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 11),
                ),
                const Chip(
                  avatar: Icon(Icons.delivery_dining, color: Colors.green),
                  label: Text(
                    "Regular Delivery",
                    style: TextStyle(color: Colors.green, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.green),
                const SizedBox(width: 4.0),
                Text(
                  order.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.green),
                const SizedBox(width: 4.0),
                Text(
                  order.phone,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey),
                const SizedBox(width: 8.0),
                Expanded(child: Text(order.address)),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.grey),
                    const SizedBox(width: 8.0),
                    Text("Date: ${order.date}"),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.cancel, color: Colors.red),
                    const SizedBox(width: 8.0),
                    Text(
                      "Status: ${order.status}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Amount Payable: ৳${order.amount}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Order Again"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
