import 'package:flutter/material.dart';
import 'package:practise_app1/Widgets/ui_elements/product_title.dart';
import 'package:practise_app1/models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:practise_app1/scoped-models/main.dart';

class ProductPage extends StatelessWidget {
  // void _showWarningDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Are you sure ?"),
  //         content: Text("This action cannot be undone."),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('Discard'),
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //           ),
  //           FlatButton(
  //             child: Text('Continue'),
  //             onPressed: () {
  //               Navigator.pop(context);
  //               Navigator.pop(context, true);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          final Product product = model.selectedProduct;
          return Scaffold(
            appBar: AppBar(
              title: Text("Product Detail"),
            ),
            body: Column(
              children: <Widget>[
                FadeInImage(
                  image: NetworkImage(product.image),
                  height: 300.0,
                  fit: BoxFit.cover,
                  placeholder: AssetImage('images/food.jpg'),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      ProductTitle(product.title),
                      SizedBox(height: 8.0),
                      Text(
                        '${product.address} | \$ ${product.price.toString()}',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Text(product.description)
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
