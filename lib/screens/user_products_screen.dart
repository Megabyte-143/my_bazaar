import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user_product.dart';
import '../providers/products_data_provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routename = "/userproductscreen";

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: productData.items.length,
        itemBuilder: (ctx, i) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              UserProduct(
                imageUrl: productData.items[i].imageUrl,
                title: productData.items[i].title,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
