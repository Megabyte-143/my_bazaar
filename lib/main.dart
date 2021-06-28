import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/cart_data_provider.dart';
import './providers/products_data_provider.dart';
import './providers/orders_data_provider.dart';
import './providers/auth_provider.dart';

import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/order_screen.dart';
import './screens/cart_screen.dart';
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
        ChangeNotifierProxyProvider<Auth, ProductsDataProvider>(
          create: (ctx) => ProductsDataProvider('', []),
          update: (ctx, auth, previousItems) => ProductsDataProvider(
              auth.token, previousItems == null ? [] : previousItems.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartDataProvider(),
        ),
        ChangeNotifierProxyProvider<Auth, OrdersDataProvider>(
          create: (ctx) => OrdersDataProvider('', []),
          update: (ctx, auth, previousItems) => OrdersDataProvider(
              auth.token, previousItems == null ? [] : previousItems.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.amber,
            fontFamily: 'Anton',
          ),
          home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routename: (ctx) => OrderScreen(),
            UserProductScreen.routename: (ctx) => UserProductScreen(),
            EditProductScreen.routename: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
