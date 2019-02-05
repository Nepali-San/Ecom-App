import 'package:flutter/material.dart';
import 'package:practise_app1/Widgets/ui_elements/logout_listtile.dart';
import 'package:practise_app1/pages/product_edit_tab.dart';
import 'package:practise_app1/pages/product_list_tab.dart';
import 'package:practise_app1/scoped-models/main.dart';

class AdminPage extends StatelessWidget {

  final MainModel model;
  AdminPage(this.model);

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text("Choose"),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("All Products"),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/products');
            },
          ),
          Divider(),
          LogoutListTile(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: _buildDrawer(context),
          appBar: AppBar(
            title: Text("Manage Products"),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.create),
                  text: "Create Product",
                ),
                Tab(
                  icon: Icon(Icons.list),
                  text: "List Products",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              EditProduct(),
              ListProduct(model),
            ],
          ),
        ),
      );
}
