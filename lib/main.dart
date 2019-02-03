import 'package:flutter/material.dart';
import 'package:practise_app1/pages/login_page.dart';
import 'package:practise_app1/pages/product_edit_tab.dart';
import 'package:practise_app1/pages/product_page.dart';
import 'package:practise_app1/pages/products_admin_page.dart';
import 'package:practise_app1/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:practise_app1/pages/products_page.dart';
import 'package:practise_app1/pages/unknown_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {

  MainModel mainModel = MainModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: mainModel,
      child: MaterialApp(
        // debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          accentColor: Colors.greenAccent,
        ),
        home: LoginPage(),
        routes: {
          '/products': (BuildContext context) => ProductsPage(mainModel),
          '/admin': (BuildContext context) => AdminPage(mainModel),
          '/editProduct': (BuildContext context) => EditProduct(),
            
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');

          if (pathElements[0] != '') return null;

          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];

            mainModel.selectProduct(productId);
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) {
                return ProductPage();
              }, 
            );
          }

          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) => UnknownPage(),
          );
        },
      ),
    );
  }
}
