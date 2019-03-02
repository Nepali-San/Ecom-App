import 'package:flutter/material.dart';
import 'package:practise_app1/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class FloatingButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FloatingButton();
  }
}

class _FloatingButton extends State<FloatingButton>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 70.0,
              width: 50.0,
              alignment: FractionalOffset.topCenter,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.0, 1.0, curve: Curves.easeOut),
                ),
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  heroTag: "contact",
                  onPressed: () async {
                    final url =
                        "mailto:${model.selectedProduct.userEmail}?subject= Buy ${model.selectedProduct.title}";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw "Couldn't launch url";
                    }
                  },
                  child: Icon(
                    Icons.mail,
                    color: Colors.red,
                  ),
                  elevation: 5.0,
                  mini: true,
                ),
              ),
            ),
            Container(
              height: 70.0,
              width: 50.0,
              alignment: FractionalOffset.topCenter,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.0, 0.5, curve: Curves.easeOut),
                ),
                child: FloatingActionButton(
                  heroTag: 'favourite',
                  onPressed: () {
                    model.toogleFavourite();
                  },
                  backgroundColor: Colors.white,
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
            ),
            FloatingActionButton(
              heroTag: "options",
              onPressed: () {
                if (_animationController.isDismissed) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              },
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (BuildContext context, Widget child) {
                  return Transform(
                    alignment: FractionalOffset.center,
                    transform: Matrix4.rotationZ(_animationController.value * 0.5 * math.pi),
                    child: Icon(_animationController.isDismissed ? Icons.more_vert : Icons.close),
                  );
                },
              ),
              elevation: 5.0,
            ),
          ],
        );
      },
    );
  }
}
