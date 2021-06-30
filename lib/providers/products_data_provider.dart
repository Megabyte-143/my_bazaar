import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product_data_provider.dart';
import '../models/htpp_expection.dart';

class ProductsDataProvider with ChangeNotifier {
  List<ProductDataProvider> _items = [
    // ProductDataProvider(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // ProductDataProvider(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // ProductDataProvider(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // ProductDataProvider(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  final String authToken;
  final String userId;

  ProductsDataProvider(this.authToken, this.userId, this._items);
  var showFavOnly = false;
  List<ProductDataProvider> get favItems {
    return _items.where((prodId) => prodId.isFav).toList();
  }

  List<ProductDataProvider> get items {
    return [..._items];
  }

  ProductDataProvider findById(String id) {
    return _items.firstWhere(
      (productDataProvider) => productDataProvider.id == id,
    );
  }

  Future<void> fetchAndaddData([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://my-bazaar-fe792-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';

    try {
      final response = await http.get(Uri.parse(url));

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<ProductDataProvider> loadedProducts = [];
      // if (extractedData == null) {
      //   return;
      // }
      url =
          'https://my-bazaar-fe792-default-rtdb.firebaseio.com/usersFav/$userId.json?auth=$authToken';
      final favResponse = await http.get(Uri.parse(url));
      final favResponseData = json.decode(favResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(ProductDataProvider(
            id: prodId,
            title: prodData['title'],
            imageUrl: prodData['imageUrl'],
            price: (prodData['price']),
            description: prodData['description'],
            isFav: favResponseData == null
                ? false
                : favResponseData[prodId] ?? false));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProductDataProvider(ProductDataProvider product) async {
    final url =
        'https://my-bazaar-fe792-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFav": product.isFav,
          "creatorId": userId,
        }),
      );

      final addProduct = ProductDataProvider(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(addProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, ProductDataProvider newProduct) async {
    final prodId = _items.indexWhere((element) => element.id == id);
    if (prodId >= 0) {
      final url =
          'https://my-bazaar-fe792-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      try {
        await http.patch(Uri.parse(url),
            body: json.encode({
              'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl
            }));
      } catch (error) {
        print(error);
      } finally {
        _items[prodId] = newProduct;
        notifyListeners();
      }
    } else {
      print("...");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://my-bazaar-fe792-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';

    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    final existingProduct = _items[existingProductIndex];
    _items.removeWhere((element) => element.id == id);

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Couldn't delete product.");
    }
  }
}
