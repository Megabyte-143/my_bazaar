import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_data_provider.dart';
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductDataProvider>(context);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: productData.id);
          },
          child: Card(
            child: Image.network(
              productData.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<ProductDataProvider>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                productData.isFav ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                productData.toggleFav();
              },
            ),
          ),
          title: Text(productData.title),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_bag,
            ),
            onPressed: () {
              cart.addItem(
                  productData.id, productData.price, productData.title,);
            },
          ),
        ),
      ),
    );
  }
}
