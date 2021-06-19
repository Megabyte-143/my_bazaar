import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_data_provider.dart';
import '../providers/orders_data_provider.dart';

class TotalAmtOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartDataProvider>(context);
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
                "\$${cart.totalAmount.toStringAsFixed(2)}",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<OrdersDataProvider>(context, listen: false)
                    .addProducts(
                  cart.items.values.toList(),
                  cart.totalAmount,
                );
                cart.clear();
              },
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
