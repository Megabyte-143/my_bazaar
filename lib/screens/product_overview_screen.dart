import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../widgets/product_gird.dart';

enum FilterOption {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Bazaar"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOption slectedValue) {
              setState(() {
                if (slectedValue == FilterOption.Favorites) {
                  _showFavOnly = true;
                } else {
                  _showFavOnly = false;
                }
              });
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('only fav'),
                value: FilterOption.Favorites,
              ),
              PopupMenuItem(
                child: Text('all'),
                value: FilterOption.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: IconButton(
                icon: Icon(
                  Icons.shopping_bag,
                ),
                onPressed: () {},
              ),
              value: cart.itemCount.toString(),
            ),
          ),
        ],
      ),
      body: ProductGrid(_showFavOnly),
    );
  }
}
