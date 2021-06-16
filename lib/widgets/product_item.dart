import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;

  ProductItem(
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.price,
  );

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Card(
        child: Image.network(imageUrl),
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        leading: Icon(Icons.favorite),
        title: Text(title),
        trailing: Icon(Icons.shopping_cart),
      ),
    );
  }
}
