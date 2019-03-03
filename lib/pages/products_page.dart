import 'package:flutter/material.dart';
import 'package:practise_app1/Widgets/products/products.dart';
import 'package:practise_app1/Widgets/ui_elements/myDrawer.dart';
import 'package:practise_app1/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsPage extends StatefulWidget {

  final MainModel model;
  ProductsPage(this.model);

  @override
  State<StatefulWidget> createState() {    
    return _ProductPage();
  }
}

class _ProductPage extends State<ProductsPage>{

  @override
  initState(){
    widget.model.fetchProducts();    
    super.initState();
  }

  Widget _buildProducts(){
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context,Widget child,MainModel model){

        Widget content =  Center(child: model.showOnlyFavourites ? Text("You haven't selected any product as favourite.") : Text("No products found"));
        if(model.displayProducts.length > 0 && !model.isLoading){
          content = Products();
        }else if(model.isLoading){
          content = Center(child:CircularProgressIndicator());
        }        
        return RefreshIndicator(child: content,onRefresh: model.fetchProducts);        
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: MyDrawer(1),
        appBar: AppBar(
          title: Text("Products"),
          actions: <Widget>[
            ScopedModelDescendant<MainModel>(
              builder:
                  (BuildContext context, Widget child, MainModel model) {
                return IconButton(
                  icon: Icon(model.showOnlyFavourites
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: () {
                    model.toogelMode();
                  },
                );
              },
            ),
          ],
        ),
        body: _buildProducts(),
      );
}
