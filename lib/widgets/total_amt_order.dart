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
            OrderButton(cart: cart),
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final CartDataProvider cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0.0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
                print("setState1");
              });
              await Provider.of<OrdersDataProvider>(context, listen: false)
                  .addOrders(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading = false;
                print("setState2");
              });
              widget.cart.clear();
            },
      child: _isLoading? CircularProgressIndicator(): Text(
        'Order Now',
      ),
    );
  }
}
