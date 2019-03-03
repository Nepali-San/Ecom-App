import 'package:flutter/material.dart';
import 'package:practise_app1/Widgets/products/address_tag.dart';
import 'package:practise_app1/Widgets/products/price_tag.dart';
import 'package:practise_app1/Widgets/ui_elements/product_title.dart';
import 'package:practise_app1/models/product.dart';
import 'package:practise_app1/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsCard extends StatelessWidget {
  final Product product;  

  ProductsCard(this.product);

  ButtonBar _buildActionButtons(BuildContext context, MainModel model) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.pushNamed<bool>(context, '/product/' + product.id)
                .then((_) => model.selectProduct(null));
          },
          icon: Icon(Icons.info),
          color: Colors.green,
        ),
        IconButton(
          icon: Icon(product.isFavorite
              ? Icons.favorite
              : Icons.favorite_border),
          color: Colors.red,
          onPressed: () {
            model.selectProduct(product.id);
            model.toogleFavourite();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Hero(
            tag: product.id,
            child: FadeInImage(
              image: NetworkImage(product.imageUrl),
              height: 300.0,
              fit: BoxFit.cover,
              placeholder: AssetImage('images/food.jpg'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ProductTitle(product.title),
                SizedBox(width: 8.0),
                PriceTag(product.price.toString()),
              ],
            ),
          ),
          AddressTag(product.address),
          SizedBox(width: 6.0),
          // Text(product.userEmail),
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return _buildActionButtons(context, model);
            },
          )
        ],
      ),
    );
  }
}
