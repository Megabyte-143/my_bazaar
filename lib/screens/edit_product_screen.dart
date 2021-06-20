import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/products_data_provider.dart';
import '../providers/product_data_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routename = "/editproductscreen";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = ProductDataProvider(
    id: '',
    title: '',
    description: '',
    imageUrl: '',
    price: 0.0,
  );
  var _isInit = true;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      _editedProduct = Provider.of<ProductsDataProvider>(context, listen: false)
          .findById(productId);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    final validForm = _form.currentState!.validate();
    if (!validForm) {
      return;
    }
    _form.currentState!.save();
    Provider.of<ProductsDataProvider>(context, listen: false)
        .addProductDataProvider(_editedProduct);
    Navigator.of(context).pop();
  }

  void updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith("http") ||
              !_imageUrlController.text.startsWith("https")) &&
          (!_imageUrlController.text.endsWith(".png") ||
              !_imageUrlController.text.endsWith(".jpg") ||
              !_imageUrlController.text.endsWith(".jpeg"))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Provide a value";
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = ProductDataProvider(
                    id: '',
                    title: value.toString(),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Price"),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Provide a value";
                  }
                  if (double.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  if (double.parse(value) <= 0) {
                    return "Please Enter value greater than zero.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = ProductDataProvider(
                    id: '',
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    price: double.parse(value!),
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editedProduct = ProductDataProvider(
                    id: '',
                    title: _editedProduct.title,
                    description: value.toString(),
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                  );
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Provide a value";
                  }
                  if (value.length <= 10) {
                    return "Please Provide longer Discription";
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 10,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        style: BorderStyle.solid,
                        color: Colors.black54,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text("Enter Image URl")
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: "Image Url"),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editedProduct = ProductDataProvider(
                          id: '',
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          imageUrl: value.toString(),
                          price: _editedProduct.price,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Provide a value";
                        }
                        if (!value.startsWith("http") ||
                            !value.startsWith("https")) {
                          return "Please provide valid URL";
                        }
                        if (value.endsWith(".png") ||
                            value.endsWith(".jpg") ||
                            value.endsWith(".jpeg")) {
                          return "Please provide valid URL";
                        }
                        return null;
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}