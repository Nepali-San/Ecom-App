import 'package:flutter/material.dart';

class Product {
  final String title, description, image, id;
  final double price;
  final bool isFavorite;
  final String userEmail, userId,address;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.image,
      @required this.price,
      @required this.userEmail,
      @required this.userId,
      @required this.address,
      this.isFavorite = false});
}
