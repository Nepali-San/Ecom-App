import 'package:flutter/material.dart';
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

class _ListProduct extends State<ListProduct>{

  @override
  initState(){
    widget.model.fetchProducts();
    super.initState();
  }
  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(model.allproducts[index].id);
        Navigator.pushNamed(context, '/editProduct')
        .then((_){
          model.selectProduct(null);
        });
      },
    );
  }

  Widget _build(BuildContext context, int index, MainModel model) {
    Color colorv = Colors.red;
    return Dismissible(
      key: Key(model.allproducts[index].title),
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.startToEnd) {
          model.selectProduct(model.allproducts[index].id);
          model.deleteProduct();
        }else{
          model.selectProduct(model.allproducts[index].id);
          model.deleteProduct();
        }
      },
      background: Container(
        color: colorv,
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
                backgroundImage: NetworkImage(model.allproducts[index].image)),
            title: Text(model.allproducts[index].title),
            subtitle: Text('\$ ${model.allproducts[index].price.toString()}'),
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
          itemCount: model.allproducts.length,
        );
      },
    );
  }
}