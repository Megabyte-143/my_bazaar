import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_data_provider.dart';


class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product_detail_screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedData = Provider.of<ProductsDataProvider>(context,listen: false)
        .findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedData.title),
      ),
    );
  }
}
