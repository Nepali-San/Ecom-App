import 'package:flutter/material.dart';
import 'package:practise_app1/Widgets/products/products_card.dart';
import 'package:practise_app1/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/product.dart';

class Products extends StatelessWidget {
  Widget _buildProductList(List<Product> products) {

    Widget productCard;

    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductsCard(products[index], index),
        itemCount: products.length,
      );
    } else {
      productCard = Container();
    }

    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(

      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildProductList(model.displayProducts);
      },

    );
  }
}
