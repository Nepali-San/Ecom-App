import 'package:flutter/material.dart';

class Product {
  final String title, description, imagePath, id;
  final double price;
  final bool isFavorite;
  final String userEmail, userId, address, imageUrl;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imagePath,
      @required this.imageUrl,
      @required this.price,
      @required this.userEmail,
      @required this.userId,
      @required this.address,
      this.isFavorite = false});
}
