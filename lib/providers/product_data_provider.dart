import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductDataProvider with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  // final authToken;

  bool isFav;

  ProductDataProvider({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFav = false,
    // this.authToken,
  });

  void _favStatus(bool newState) {
    isFav = newState;
    notifyListeners();
  }

  Future<void> toggleFav(String authToken) async {
    final oldStatus = isFav;

    isFav = !isFav;
    notifyListeners();
    final url =
        'https://my-bazaar-fe792-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    try {
      final response = await http.patch(
        Uri.parse(url),
        body: json.encode({
          'isFav': oldStatus,
        }),
      );
      if (response.statusCode >= 400) {
        _favStatus(oldStatus);
      }
    } catch (error) {
      _favStatus(oldStatus);
    }
  }
}
