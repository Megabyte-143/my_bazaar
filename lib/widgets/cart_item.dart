import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_data_provider.dart' show CartDataProvider;

class CartItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartDataProvider>(context);
    final List cartItems = cart.items.values.toList();
    final List key = cart.items.keys.toList();
    return Expanded(
      child: ListView.builder(
        itemBuilder: (ctx, i) => Dismissible(
          key: ValueKey(cartItems[i].id),
          direction: DismissDirection.endToStart,
          background: Container(
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
            alignment: Alignment.centerRight,
            color: Theme.of(context).errorColor,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
          ),
          confirmDismiss: (direction) {
            return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                content: Text("Sochle, sasta  h khareed ni rha fir?"),
                title: Text("Are You Sure"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: Text('Yes'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (
            direction,
          ) {
            Provider.of<CartDataProvider>(context, listen: false)
                .removeItem(key[i]);
          },
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: ListTile(
                leading: CircleAvatar(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: FittedBox(
                      child: Text(
                        "\$${cartItems[i].price}",
                      ),
                    ),
                  ),
                ),
                title: Text(cartItems[i].title),
                subtitle: Text(
                  "Total: \$${((cartItems[i].price) * (cartItems[i].quantity))}",
                ),
                trailing: Text(
                  "${cartItems[i].quantity} x",
                ),
              ),
            ),
          ),
        ),
        itemCount: cart.items.length,
      ),
    );
  }
}
