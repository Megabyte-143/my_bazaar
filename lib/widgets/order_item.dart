import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders_data_provider.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded
          ? min(widget.order.products.length * 50.0 + 1000, 200)
          : 110,
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8.0),
        elevation: 5,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: Text("\$${widget.order.amount.toStringAsFixed(2)}"),
                subtitle: Text(
                  DateFormat("dd/MM/yyyy hh:mm").format(widget.order.dateTime),
                ),
                trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                ),
              ),
            ),
            // if (_expanded)
            AnimatedContainer(
              curve: Curves.bounceIn,
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(10),
              height: _expanded
                  ? min(widget.order.products.length * 40.0 + 900, 100)
                  : 0,
              child: ListView(
                shrinkWrap: true,
                children: widget.order.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              prod.title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${prod.quantity}x \$${prod.price}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
