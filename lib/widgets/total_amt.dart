import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class TotalAmt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Card(
      margin: EdgeInsets.all(15),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Total Amount",
              style: TextStyle(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
            Spacer(),
            Chip(
              label: Text(
                "\$${cart.totalAmount}",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Order Now',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
