import 'package:flutter/material.dart';
import 'package:practise_app1/Widgets/ui_elements/custom_route.dart';
import 'package:practise_app1/Widgets/ui_elements/logout_listtile.dart';
import 'package:practise_app1/models/user.dart';
import 'package:practise_app1/pages/about_us.dart';
import 'package:practise_app1/pages/products_admin_page.dart';
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
    MainModel model;
    return Drawer(
      child: Column(
        children: <Widget>[
          ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
            model = model;
            return _buildDrawerHeader(model.user);
          }),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("All Products"),
            onTap: () {
              if (drawerNo == 1) {
                Navigator.pop(
                    context); //when you are already in that page, just close the drawer.
              } else {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Product"),
            onTap: () {
              if (drawerNo == 2) {
                Navigator.pop(
                    context); //when you are already in that page, just close the drawer.
              } else if (drawerNo == 1) {
                Navigator.pop(context);
                // Navigator.pushNamed(context, '/admin');
                Navigator.push(context,
                    CustomRoute(builder: (BuildContext context) {
                  return AdminPage(model);
                }));
              } else {
                //if any other page included...
                Navigator.pop(context);
                Navigator.pop(context);
                // Navigator.pushReplacementNamed(context, '/admin');
                Navigator.push(
                  context,
                  CustomRoute(builder: (BuildContext context) {
                    return AdminPage(model);
                  }),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text("About us"),
            onTap: () {
              if (drawerNo == 3) {
                Navigator.pop(
                    context); //when you are already in that page, just close the drawer.
              } else if (drawerNo == 1) {
                Navigator.pop(context);
                // Navigator.pushNamed(context, '/admin');
                Navigator.push(context,
                    CustomRoute(builder: (BuildContext context) {
                  return Aboutus();
                }));
              } else {
                //if any other page included...
                Navigator.pop(context);
                Navigator.pop(context);
                // Navigator.pushReplacementNamed(context, '/admin');
                Navigator.push(
                  context,
                  CustomRoute(builder: (BuildContext context) {
                    return Aboutus();
                  }),
                );
              }
            },
          ),
          Divider(),
          LogoutListTile(),
        ],
      ),
    );
  }
}
