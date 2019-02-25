import 'package:flutter/material.dart';
import 'package:practise_app1/Widgets/ui_elements/product_title.dart';
import 'package:practise_app1/models/product.dart';

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

  final Product product;
  ProductPage(this.product);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Product Detail"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5.0),
                child: FadeInImage(
                  image: NetworkImage(product.imageUrl),
                  height: 300.0,
                  fit: BoxFit.cover,
                  placeholder: AssetImage('images/food.jpg'),
                )
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
                    Text(
                      product.description,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
