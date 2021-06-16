import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './product_item.dart';
import '../providers/products_data_provider.dart';

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsDataProvider>(context);
    final productData = productsData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: productData.length,
      itemBuilder: (ctx, i) => ProductItem(
        productData[i].id,
        productData[i].title,
        productData[i].imageUrl,
      ),
      padding: EdgeInsets.all(20),
    );
  }
}
