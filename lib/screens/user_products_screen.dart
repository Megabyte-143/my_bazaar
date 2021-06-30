import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user_product.dart';
import '../providers/products_data_provider.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routename = "/userproductscreen";
  Future<void> _refreshProducts(BuildContext context) async {
    Provider.of<ProductsDataProvider>(context, listen: false)
        .fetchAndaddData(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productData = Provider.of<ProductsDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routename);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? Center(child: CircularProgressIndicator(),)
            : RefreshIndicator( 
                onRefresh: () => _refreshProducts(context),
                child: Consumer<ProductsDataProvider>(
                  builder: (ctx, productData, child) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: productData.items.length,
                      itemBuilder: (ctx, i) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            UserProduct(
                              id: productData.items[i].id,
                              imageUrl: productData.items[i].imageUrl,
                              title: productData.items[i].title,
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
