import 'package:flutter/material.dart';
import 'package:practise_app1/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class FloatingButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FloatingButton();
  }
}

class _FloatingButton extends State<FloatingButton> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 76.0,
              width: 50.0,
              alignment: FractionalOffset.topCenter,
              child: FloatingActionButton(
                heroTag: "contact",
                onPressed: () {},
                child: Icon(
                  Icons.mail,
                  color: Colors.white,
                ),
                elevation: 5.0,
                mini: true,
              ),
            ),
            Container(
              height: 76.0,
              width: 50.0,
              alignment: FractionalOffset.topCenter,
              child: FloatingActionButton(
                heroTag: 'favourite',
                onPressed: () {
                  model.toogleFavourite();
                },
                child: Icon(
                  (model.selectedProduct.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: Colors.red,
                ),
                elevation: 5.0,
                mini: true,
              ),
            ),
            FloatingActionButton(
              heroTag: "options",
              onPressed: () {},
              child: Icon(Icons.more_vert),
              elevation: 5.0,
            ),
          ],
        );
      },
    );
  }
}
