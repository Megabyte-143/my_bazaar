import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductDataProvider with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;

  bool isFav;

  ProductDataProvider({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFav = false,
  });

  void _favStatus(bool newState) {
    isFav = newState;
    notifyListeners();
  }

  Future<void> toggleFav() async {
    final oldStatus = isFav;

    isFav = !isFav;
    notifyListeners();
    final url =
        'https://my-bazaar-fe792-default-rtdb.firebaseio.com/products/$id.json';
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
