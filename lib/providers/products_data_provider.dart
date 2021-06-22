import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:convert';
import './product_data_provider.dart';

class ProductsDataProvider with ChangeNotifier {
  List<ProductDataProvider> _items = [
    ProductDataProvider(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    ProductDataProvider(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    ProductDataProvider(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    ProductDataProvider(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  var showFavOnly = false;
  List<ProductDataProvider> get favItems {
    return _items.where((prodId) => prodId.isFav).toList();
  }

  List<ProductDataProvider> get items {
    return [..._items];
  }

  ProductDataProvider findById(String id) {
    return _items
        .firstWhere((productDataProvider) => productDataProvider.id == id,);
  }

  void addProductDataProvider(ProductDataProvider product) {
    const url =
        'https://my-bazaar-fe792-default-rtdb.firebaseio.com/products.json';
    http
        .post(
      Uri.parse(url),
      body: json.encode({
        "title": product.title,
        "description": product.description,
        "price": product.description,
        "imageUrl": product.imageUrl,
        "isFav": product.isFav,
      }),
    )
        .then((response) {
      final addProduct = ProductDataProvider(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.add(addProduct);
      notifyListeners();
    });
  }

  void updateProduct(String id, ProductDataProvider newProduct) {
    final prodId = _items.indexWhere((element) => element.id == id);
    if (prodId >= 0) {
      _items[prodId] = newProduct;
      notifyListeners();
    } else {
      print("...");
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
