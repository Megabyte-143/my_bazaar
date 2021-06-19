import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;

class CartItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Expanded(
          child: ListView.builder(
        itemBuilder: (ctx, i) => Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: ListTile(
              leading: CircleAvatar(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FittedBox(
                    child: Text("\$${cart.items.values.toList()[i].price}"),
                  ),
                ),
              ),
              title: Text(cart.items.values.toList()[i].title),
              subtitle: Text(
                  "Total: \$${((cart.items.values.toList()[i].price) * (cart.items.values.toList()[i].quantity))}"),
              trailing: Text("${cart.items.values.toList()[i].quantity} x"),
            ),
          ),
        ),
        itemCount: cart.items.length,
      ),
    );
  }
}
