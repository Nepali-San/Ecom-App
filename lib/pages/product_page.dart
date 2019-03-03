import 'dart:async';

import 'package:flutter/material.dart';
import 'package:practise_app1/Widgets/products/prouduct_fab.dart';
import 'package:practise_app1/Widgets/ui_elements/product_title.dart';
import 'package:practise_app1/models/product.dart';

class ProductPage extends StatelessWidget {

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
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 256.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(product.title,),                
                background: Hero(
                  tag: product.id,
                  child: FadeInImage(
                    image: NetworkImage(product.imageUrl),
                    height: 300.0,
                    fit: BoxFit.cover,
                    placeholder: AssetImage('images/food.jpg'),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                )
              ]),
            )
          ],
        ),
        floatingActionButton: FloatingButton(),
      ),
    );
  }
}
