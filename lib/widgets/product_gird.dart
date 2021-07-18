import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import './product_item.dart';

import '../providers/products_data_provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavOnly;
  ProductGrid(this.showFavOnly);
  @override
  Widget build(BuildContext context) {
    final productsData =
        Provider.of<ProductsDataProvider>(context, listen: false);
    final productData =
        showFavOnly ? productsData.favItems : productsData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: productData.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: productData[i],
        child: ProductItem(
            // productData[i].id,
            // productData[i].title,
            // productData[i].imageUrl,
            ),
      ),
      padding: EdgeInsets.all(20),
    );
  }
}
