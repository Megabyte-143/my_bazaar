import 'package:flutter/material.dart';

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

  void toggleFav() {
    isFav = !isFav;
    notifyListeners();
  }
}
