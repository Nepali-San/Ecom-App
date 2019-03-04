import 'package:flutter/material.dart';
import 'package:practise_app1/Widgets/ui_elements/logout_listtile.dart';
import 'package:practise_app1/models/user.dart';
import 'package:practise_app1/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class MyDrawer extends StatelessWidget {
  final int drawerNo;

  MyDrawer(this.drawerNo);

  Widget _buildDrawerHeader(User user) {
    return UserAccountsDrawerHeader(
      accountName: Text("${user.id}"),
      accountEmail: Text("${user.email}"),
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage('images/default_profile_pic.jpeg'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
            return _buildDrawerHeader(model.user);
          }),
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
