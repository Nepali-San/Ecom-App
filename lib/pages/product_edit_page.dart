import 'dart:io';

import 'package:flutter/material.dart';
import 'package:practise_app1/Widgets/form_inputs/image.dart';
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
    'imgFile': null,
    'price': null,
    'address': null
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _priceTextController = TextEditingController();
  final _addressTextController = TextEditingController();

  Widget _buildTitleTextField(Product product) {
    if (_titleTextController.text.trim() == "") {
      _titleTextController.text = product.title;
    } else {
      _titleTextController.text = _titleTextController.text.trim();
    }

    return TextFormField(
      decoration: InputDecoration(labelText: "Product Title"),
      // initialValue: product.title,
      controller: _titleTextController,
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
    if (_descriptionTextController.text.trim() == "") {
      _descriptionTextController.text = product.description;
    } else {
      _descriptionTextController.text = _descriptionTextController.text.trim();
    }
    return TextFormField(
      maxLines: 5,
      decoration: InputDecoration(labelText: "Product Description"),
      // initialValue: product.description,
      controller: _descriptionTextController,
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
    if (_priceTextController.text.trim() == "") {
      _priceTextController.text = product.price.toString();
    } else {
      _priceTextController.text = _priceTextController.text.trim();
    }
    return TextFormField(
      decoration: InputDecoration(labelText: "Product Price"),
      // initialValue: product.price.toString(),
      controller: _priceTextController,
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

  Widget _buildAddressTextField(Product product) {
    if (_addressTextController.text.trim() == "") {
      _addressTextController.text = product.address;
    } else {
      _addressTextController.text = _addressTextController.text.trim();
    }
    return TextFormField(
      decoration: InputDecoration(labelText: "Address"),
      // initialValue: product.address,
      controller: _addressTextController,
      validator: (String value) {
        if (value.trim().isEmpty) {
          return 'Address is not valid';
        }
      },
      onSaved: (String value) {
        _formData['address'] = value;
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
                onPressed: () =>
                    _submitForm(model.updateProduct, selectedIndex),
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
              _buildAddressTextField(product),
              SizedBox(height: 6.0),
              ImageInput(_setImage, product),
              SizedBox(height: 6.0),
              _buildEditButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _setImage(File image) {
    _formData['imgFile'] = image;
  }

  void dialogonFailure(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Something Went Wrong !!!"),
          content: Text(msg),
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

  void _submitForm(Function updateProduct, int selectedProductIndex) {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();
    updateProduct(
      _titleTextController.text,
      _descriptionTextController.text,
      _formData['imgFile'],
      double.parse(_priceTextController.text),
      _addressTextController.text,
    ).then((bool isSuccess) {
      if (isSuccess) {
        Navigator.pop(context);       
      } else {
        dialogonFailure("Try editing products later");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Edit product"),
          ),
          body: _buildPageContent(context, model.selectedProduct),
        );
      },
    );
  }
}
