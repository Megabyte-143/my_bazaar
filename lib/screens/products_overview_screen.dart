import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../providers/cart_data_provider.dart';
import '../providers/products_data_provider.dart';
import '../widgets/badge.dart';
import '../widgets/product_gird.dart';
import '../widgets/app_drawer.dart';

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
  var _initState = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<ProductsDataProvider>(context).fetchAndaddData(); //Can't use context in init state
    // Future.delayed(Duration.zero).then((value) =>
    //     Provider.of<ProductsDataProvider>(context).fetchAndaddData());// will change the order of execution
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initState) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsDataProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _initState = false;
    super.didChangeDependencies();
  }

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
            icon: Icon(
              Icons.more_vert,
            ),
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
          Consumer<CartDataProvider>(
            builder: (_, cart, ch) => Badge(
              child: IconButton(
                icon: Icon(
                  Icons.shopping_bag,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
              value: cart.itemCount.toString(),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFavOnly),
    );
  }
}
