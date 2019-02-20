import 'package:flutter/material.dart';
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
    'imgUrl': 'images/food.jpg',
    'price': null,
    'address': null
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Product Title"),
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

  Widget _buildDescriptionTextField() {
    return TextFormField(
      maxLines: 5,
      decoration: InputDecoration(labelText: "Product Description"),
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

  Widget _buildPriceTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Product Price"),
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

  Widget _buildAddressTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Address"),
      validator: (String value) {
        if (value.trim().isEmpty) {
          return 'Invalid address';
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
                onPressed: () => _submitForm(model.addproduct,
                    model.updateProduct, model.selectProduct, selectedIndex),
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

  void _submitForm(
      Function addProduct, Function updateProduct, Function selectProduct,
      [int selectedProductIndex]) {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();

    addProduct(
      _formData['title'],
      _formData['description'],
      _formData['imgUrl'],
      _formData['price'],
      _formData['address'],
    ).then((bool isSuccess) {
      if (isSuccess) {
        Navigator.pushReplacementNamed(context, '/');
      } else {
        dialogonFailure("Try adding products later");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildPageContent(context);
  }
}
