import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './cart_data_provider.dart';

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
  final authToken;
  final userId;

  OrdersDataProvider(
    this.authToken,
    this.userId,
    this._orders,
  );
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fecthAndSetOrders() async {
    final url =
        'https://my-bazaar-fe792-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    Map<String, dynamic> extractedData = {};

    if (json.decode(response.body) != null) {
      extractedData = json.decode(response.body);
    }
    if (extractedData == {}) {
      return;
    }
    // if (response.body != "null") {
    //   extractedData = json.decode(response.body);
    // }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((cartItem) => CartItem(
                    id: cartItem['id'],
                    title: cartItem['title'],
                    price: cartItem['price'],
                    quantity: cartItem['quantity'],
                  ))
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

//   Future<void> addOrders(List<CartItem> cartProducts, double total) async {
//     final timeStamp = DateTime.now();
//     final url =
//         'https://my-bazaar-fe792-default-rtdb.firebaseio.com/orders.json?auth=$authToken';
//     final oldData = await http.get(Uri.parse(url));

//     var extractedData = [];
//     if (oldData.body != "null") {
//       extractedData = json.decode(oldData.body);
//     }
//     extractedData.add({
//       'amount': total,
//       'dateTime': timeStamp.toIso8601String(),
//       'products': cartProducts
//           .map((cp) => {
//                 'id': cp.id,
//                 'title': cp.title,
//                 'price': cp.price,
//                 'quantity': cp.quantity,
//               })
//           .toList(),
//     });
//     await http.put(
//       Uri.parse(url),
//       body: json.encode(extractedData),
//     );
//     // _orders.add(
//     //   OrderItem(
//     //     id: json.decode(response.body)['name'].toString(),
//     //     amount: total,
//     //     products: cartProducts,
//     //     dateTime: DateTime.now(),
//     //   ),
//     // );
//     notifyListeners();
//   }
// }
  Future<void> addOrders(List<CartItem> cartProducts, double total) async {
    final url =
        'https://my-bazaar-fe792-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    await http.post(
      Uri.parse(url),
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    // _orders.insert(
    //   0,
    //   OrderItem(
    //     id: json.decode(response.body)['name'].toString(),
    //     amount: total,
    //     dateTime: timestamp,
    //     products: cartProducts,
    //   ),
    // );
    notifyListeners();
  }
}
