import 'package:flutter/material.dart';

import '../widgets/cart_item.dart';
import '../widgets/total_amt.dart';


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
      body: Column(
        children: <Widget>[
          TotalAmt(),
          SizedBox(
            height: 10,
          ),
          CartItem(),
        ],
      ),
    );
  }
}
