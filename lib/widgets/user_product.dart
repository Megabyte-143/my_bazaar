import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_data_provider.dart';

import '../screens/edit_product_screen.dart';

class UserProduct extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProduct({required this.id, required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      title: Text(title),
      trailing: Container(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Spacer(),
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routename, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
              ),
              color: Theme.of(context).errorColor,
              onPressed: () async {
                try {
                  await Provider.of<ProductsDataProvider>(context,
                          listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Couldn't Delete the product",
                      textAlign: TextAlign.center,
                    ),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
