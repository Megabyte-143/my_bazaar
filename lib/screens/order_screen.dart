import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders_data_provider.dart' show OrdersDataProvider;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatefulWidget {
  static const routename = '/orderscreen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future _ordersFuture;

  Future _obtainOrderFuture() {
    return Provider.of<OrdersDataProvider>(context, listen: false)
        .fecthAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrderFuture();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<OrdersDataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Orders",
        ),
      ),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.error != null) {
            return Center(
              child: Text("Error occured"),
            );
          } else {
            return Consumer<OrdersDataProvider>(
              builder: (ctx, orderData, child) => ListView.builder(
                itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                itemCount: orderData.orders.length,
              ),
            );
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
