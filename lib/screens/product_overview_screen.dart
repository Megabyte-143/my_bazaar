import 'package:flutter/material.dart';

import '../widgets/product_gird.dart';

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductGrid(),
      appBar: AppBar(
        title: Text("My Bazaar"),
      ),
    );
  }
}
