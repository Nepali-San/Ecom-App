import 'package:flutter/material.dart';

class ProductTitle extends StatelessWidget {
  final String producttitle;
  ProductTitle(this.producttitle);

  @override
  Widget build(BuildContext context) {
    return Text(
      producttitle,
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Oswald'),
    );
  }
}
