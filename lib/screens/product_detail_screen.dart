import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_data_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product_detail_screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedData = Provider.of<ProductsDataProvider>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     loadedData.title,
      //   ),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                loadedData.title,
                textAlign: TextAlign.center,
              ),
              background: Hero(
                tag: loadedData.id,
                child: Image.network(
                  loadedData.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            pinned: true,
            expandedHeight: 300,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "\$${loadedData.price}",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  child: Text(
                    "${loadedData.description}",
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 800,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
