import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductDataProvider with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFav;
  // final authToken;

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

  Future<void> toggleFav(String authToken, String userId) async {
    final oldStatus = isFav;

    isFav = !isFav;
    notifyListeners();
    final url =
        'https://my-bazaar-fe792-default-rtdb.firebaseio.com/usersFav/$userId/$id.json?auth=$authToken';
    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(isFav),
      );
      if (response.statusCode >= 400) {
        _favStatus(oldStatus);
      }
    } catch (error) {
      _favStatus(oldStatus);
    }
  }
}
