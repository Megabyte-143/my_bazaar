import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders_data_provider.dart' show OrdersDataProvider;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routename = '/orderscreen';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrdersDataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Orders",
        ),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
        itemCount: orderData.orders.length,
      ),
      drawer: AppDrawer(),
    );
  }
}
