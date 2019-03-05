import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practise_app1/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class LogoutListTile extends StatelessWidget {
  final int no;
  LogoutListTile(this.no);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Logout"),
          onTap: () {
            if ((no != 1)) {
              Navigator.pop(context); //close the drawer
            }
            model.resetMyProducts();
            model.logout();
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
