import 'package:flutter/material.dart';
import 'package:practise_app1/models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:practise_app1/scoped-models/main.dart';

class EditProduct extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EditProduct();
}

class _EditProduct extends State<EditProduct> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'imgUrl': 'images/food.jpg',
    'price': null
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitleTextField(Product product) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Product Title"),
      initialValue: product == null ? "" : product.title,
      validator: (String value) {
        if (value.trim().length == 0 || value.length < 5) {
          return 'Title is required and should be more than 5 characters.';
        }
      },
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildDescriptionTextField(Product product) {
    return TextFormField(
      maxLines: 5,
      decoration: InputDecoration(labelText: "Product Description"),
      initialValue: product == null ? "" : product.description,
      validator: (String value) {
        if (value.isEmpty || value.length < 10) {
          return 'Description is required and should be more than 10 characters.';
        }
      },
      onSaved: (String value) {
        _formData['description'] = value;
      },
    );
  }

  Widget _buildPriceTextField(Product product) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Product Price"),
      initialValue: product == null ? "" : product.price.toString(),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Price is required and must be a number.';
        }
      },
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

  Widget _buildEditButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        int selectedIndex = model.selectedProductIndex;

        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
                color: Theme.of(context).accentColor,
                textColor: Colors.black,
                child: Text("Submit"),
                onPressed: () => _submitForm(model.addproduct,
                    model.updateProduct, model.selectProduct, selectedIndex),
              );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildTitleTextField(product),
              _buildDescriptionTextField(product),
              _buildPriceTextField(product),
              SizedBox(height: 10.0),
              _buildEditButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(
      Function addProduct, Function updateProduct, Function selectProduct,
      [int selectedProductIndex]) {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();
    if (selectedProductIndex != null) {
      updateProduct(
        _formData['title'],
        _formData['description'],
        _formData['imgUrl'],
        _formData['price'],
      ).then((bool isSuccess) {
        if (isSuccess) {
          Navigator.pushReplacementNamed(context, '/products');
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Something Went Wrong !!!"),
                content: Text("Try editing products later"),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Okay !"),
                  ),
                ],
              );
            },
          );
        }
      });
    } else {
      addProduct(
        _formData['title'],
        _formData['description'],
        _formData['imgUrl'],
        _formData['price'],
      ).then((bool isSuccess) {
        if (isSuccess) {
          Navigator.pushReplacementNamed(context, '/products');
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Something Went Wrong !!!"),
                content: Text("Try adding products later"),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Okay !"),
                  ),
                ],
              );
            },
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedProduct);

        return model.selectedProductId == null
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text("Edit product"),
                ),
                body: pageContent,
              );
      },
    );
  }
}
