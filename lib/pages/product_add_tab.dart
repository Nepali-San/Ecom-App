import 'dart:io';

import 'package:flutter/material.dart';
import 'package:practise_app1/Widgets/form_inputs/image.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:practise_app1/scoped-models/main.dart';

class AddProduct extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddProduct();
}

class _AddProduct extends State<AddProduct> {
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

  Widget _buildTitleTextField() {
    if (_titleTextController.text.trim() != "") {
      _titleTextController.text = _titleTextController.text.trim();
    }

    return TextFormField(
      decoration: InputDecoration(labelText: "Title/Name"),
      controller: _titleTextController,
      validator: (String value) {
        if (value.trim().length == 0 || value.length < 5) {
          return 'Title is required and should be more than 5 characters.';
        }
      },
      onSaved: (String value) {
        _formData['title'] = value.trim();
      },
    );
  }

  Widget _buildDescriptionTextField() {
    if (_descriptionTextController.text.trim() != "") {
      _descriptionTextController.text = _descriptionTextController.text;
    }

    return TextFormField(
      maxLines: 5,
      decoration: InputDecoration(labelText: "Description"),
      controller: _descriptionTextController,
      validator: (String value) {
        if (value.trim().isEmpty || value.length < 10) {
          return 'Description is required and should be more than 10 characters.';
        }
      },
      onSaved: (String value) {
        _formData['description'] = value.trim();
      },
    );
  }

  Widget _buildPriceTextField() {
    if (_priceTextController.text.trim() != "") {
      _priceTextController.text = _priceTextController.text.trim();
    }
    return TextFormField(
      decoration: InputDecoration(labelText: "Price"),
      validator: (String value) {
        if (value.trim().isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Price is required and must be a number.';
        }
      },
      controller: _priceTextController,
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        _formData['price'] = double.parse(value.trim());
      },
    );
  }

  Widget _buildAddressTextField() {
    if (_addressTextController.text.trim() != "") {
      _addressTextController.text = _addressTextController.text.trim();
    }
    return TextFormField(
      decoration: InputDecoration(labelText: "Address"),
      validator: (String value) {
        if (value.trim().isEmpty) {
          return 'Invalid address';
        }
      },
      controller: _addressTextController,
      onSaved: (String value) {
        _formData['address'] = value.trim();
      },
    );
  }

  Widget _buildEditButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
                color: Theme.of(context).accentColor,
                textColor: Colors.black,
                child: Text("Submit"),
                onPressed: () => _submitForm(model.addproduct),
              );
      },
    );
  }

  Widget _buildPageContent(BuildContext context) {
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
              _buildTitleTextField(),
              _buildDescriptionTextField(),
              _buildPriceTextField(),
              _buildAddressTextField(),
              SizedBox(height: 6.0),
              ImageInput(_setImage),
              SizedBox(height: 10.0),
              _buildEditButton(),
            ],
          ),
        ),
      ),
    );
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

  void _submitForm(Function addProduct) {
    if (!_formKey.currentState.validate() || (_formData['imgFile'] == null))
      return;

    _formKey.currentState.save();

    addProduct(
      _titleTextController.text,
      _descriptionTextController.text,
      _formData['imgFile'],
      double.parse(_priceTextController.text),
      _formData['address'],
    ).then((bool isSuccess) {
      if (isSuccess) {
        // Navigator.pushReplacementNamed(context, '/');
        Navigator.pop(context);
      } else {
        dialogonFailure("Try adding products later");
      }
    });
  }

  void _setImage(File image) {
    _formData['imgFile'] = image;
  }

  @override
  Widget build(BuildContext context) {
    return _buildPageContent(context);
  }
}
