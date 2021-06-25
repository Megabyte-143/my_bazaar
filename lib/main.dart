import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/cart_data_provider.dart';
import './providers/products_data_provider.dart';
import './providers/orders_data_provider.dart';
import './providers/auth_provider.dart';

import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/order_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProductsDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrdersDataProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Anton',
        ),
        home: AuthScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routename: (ctx) => OrderScreen(),
          UserProductScreen.routename: (ctx) => UserProductScreen(),
          EditProductScreen.routename: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
