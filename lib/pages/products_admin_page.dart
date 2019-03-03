import 'package:flutter/material.dart';
import 'package:practise_app1/Widgets/ui_elements/myDrawer.dart';
import 'package:practise_app1/pages/product_add_tab.dart';
import 'package:practise_app1/pages/product_list_tab.dart';
import 'package:practise_app1/scoped-models/main.dart';

class AdminPage extends StatelessWidget {

  final MainModel model;
  AdminPage(this.model);

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: MyDrawer(2),
          appBar: AppBar(
            title: Text("Manage Products"),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.add),
                  text: "Add Product",
                ),
                Tab(
                  icon: Icon(Icons.list),
                  text: "My Products",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              AddProduct(),
              ListProduct(model),
            ],
          ),
        ),
      );
}
