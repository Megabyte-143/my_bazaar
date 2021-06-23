import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cart_data_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class OrdersDataProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fecthAndaddData() async {
    const url =
        'https://my-bazaar-fe792-default-rtdb.firebaseio.com/orders.json';

    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    var extractedData = [];
    if (response.body != "null") {
      extractedData = json.decode(response.body);
    }

    print(json.decode(response.body));
    extractedData.forEach((orderData) {
      loadedOrders.add(OrderItem(
          id: extractedData.indexOf(orderData).toString(),
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((cartItem) => CartItem(
                    id: cartItem['id'],
                    title: cartItem['title'],
                    price: cartItem['price'],
                    quantity: cartItem['quantity'],
                  ))
              .toList()));
    });
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addProducts(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final url =
        'https://my-bazaar-fe792-default-rtdb.firebaseio.com/orders.json';
    final oldData = await http.get(Uri.parse(url));

    var extractedData = [];
    if (oldData.body != "null") {
      extractedData = json.decode(oldData.body);
    }
    extractedData.add({
      'amount': total,
      'dateTime': timeStamp.toIso8601String(),
      'products': cartProducts
          .map((cp) => {
                'id': cp.id,
                'title': cp.title,
                'price': cp.price,
                'quantity': cp.quantity,
              })
          .toList(),
    });
    await http.patch(
      Uri.parse(url),
      body: json.encode(extractedData),
    );
    // _orders.add(
    //   OrderItem(
    //     id: json.decode(response.body)['name'].toString(),
    //     amount: total,
    //     products: cartProducts,
    //     dateTime: DateTime.now(),
    //   ),
    // );
    notifyListeners();
  }
}
