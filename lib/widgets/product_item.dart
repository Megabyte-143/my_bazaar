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
        leading: IconButton(
          icon: Icon(Icons.favorite),
          onPressed: () {},
        ),
        title: Text(title),
        trailing: IconButton(
          icon: Icon(
            Icons.shopping_bag,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
