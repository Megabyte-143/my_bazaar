import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_data_provider.dart';
import '../providers/cart_data_provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/auth_provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductDataProvider>(context);
    final cart = Provider.of<CartDataProvider>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: productData.id);
          },
          child: Card(
            child: FadeInImage(
              placeholder: AssetImage('lib/assets/images/product-placeholder.png'),
              image: NetworkImage(productData.imageUrl),
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
                productData.toggleFav(auth.token, auth.userId);
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
                productData.id,
                productData.price,
                productData.title,
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Item Added"),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(productData.id);
                    },
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
