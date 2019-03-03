import 'package:flutter/material.dart';
import 'package:practise_app1/Widgets/ui_elements/logout_listtile.dart';

class MyDrawer extends StatelessWidget {
  final int drawerNo;

  MyDrawer(this.drawerNo);

  @override
  Widget build(BuildContext context) {
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
              if (drawerNo == 1)
                Navigator.pop(context);
              else
                Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Product"),
            onTap: () {
              if (drawerNo == 2)
                Navigator.pop(context);
              else
                Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          Divider(),
          LogoutListTile(),
        ],
      ),
    );
  }
}
