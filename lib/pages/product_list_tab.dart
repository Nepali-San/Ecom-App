import 'package:flutter/material.dart';
import 'package:practise_app1/Widgets/ui_elements/custom_route.dart';
import 'package:practise_app1/pages/product_edit_page.dart';
import 'package:practise_app1/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ListProduct extends StatefulWidget {
  final MainModel model;
  ListProduct(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ListProduct();
  }
}

class _ListProduct extends State<ListProduct> {
  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(model.myproducts[index].id);
        // Navigator.pushNamed(context, '/editProduct').then((_) {
        //   model.selectProduct(null);
        // });
        Navigator.push(context, CustomRoute(builder: (BuildContext context) {
          return EditProduct();
        })).then((_) {
          model.selectProduct(null);
        });
      },
    );
  }

  Widget _build(BuildContext context, int index, MainModel model) {
    return Dismissible(
      key: Key(model.myproducts[index].id),
      onDismissed: (DismissDirection direction) {
        model.selectProduct(model.myproducts[index].id);
        model.deleteProduct().then((bool isSuccess) {
          if (!isSuccess) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Something Went Wrong !!!"),
                  content: Text("Try deleting products later"),
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
      },
      background: Container(
        color: Colors.red,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Hero(
              tag: model.myproducts[index].id,
              child: CircleAvatar(
                  backgroundImage:
                      NetworkImage(model.myproducts[index].imageUrl)),
            ),
            title: Text(model.myproducts[index].title),
            subtitle: Text('\$ ${model.myproducts[index].price.toString()}'),
            trailing: _buildEditButton(context, index, model),
          ),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
              _build(context, index, model),
          itemCount: model.myproducts.length,
        );
      },
    );
  }
}
