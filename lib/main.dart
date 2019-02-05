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
  MainModel _model = MainModel();

  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuth();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          accentColor: Colors.greenAccent,
        ),
        routes: {
          '/': (BuildContext context) =>
              !_isAuthenticated ? LoginPage() : ProductsPage(_model),
          '/admin': (BuildContext context) =>
              !_isAuthenticated ? LoginPage() : AdminPage(_model),
          '/editProduct': (BuildContext context) =>
              !_isAuthenticated ? LoginPage() : EditProduct(),
        },
        onGenerateRoute: (RouteSettings settings) {
          if (!_isAuthenticated) {
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => LoginPage(),
            );
          }
          final List<String> pathElements = settings.name.split('/');

          if (pathElements[0] != '') return null;

          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];

            _model.selectProduct(productId);
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) {
                return !_isAuthenticated ? LoginPage() : ProductPage();
              },
            );
          }

          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) =>
                !_isAuthenticated ? LoginPage() : UnknownPage(),
          );
        },
      ),
    );
  }
}
