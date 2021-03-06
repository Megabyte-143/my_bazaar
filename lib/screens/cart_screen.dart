import 'package:flutter/material.dart';

import '../widgets/cart_item.dart';
import '../widgets/total_amt_order.dart';
import '../widgets/app_drawer.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cartscreen";

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Cart",
        ),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          TotalAmtOrder(),
          SizedBox(
            height: 10,
          ),
          CartItem(),
        ],
      ),
    );
  }
}
