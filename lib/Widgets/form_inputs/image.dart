import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practise_app1/models/product.dart';

class ImageInput extends StatefulWidget {
  final Function setImage;
  final Product product;

  ImageInput(this.setImage, [this.product]);

  @override
  State<StatefulWidget> createState() {
    return _ImageInput();
  }
}

class _ImageInput extends State<ImageInput> {
  File _imageFile;

  void _getImage(BuildContext context, ImageSource src) {
    ImagePicker.pickImage(source: src, maxWidth: 400.0).then((File image) {
      setState(() {
        _imageFile = image;
      });
      widget.setImage(image);
      Navigator.pop(context);
    });
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150.0,
          child: Column(
            children: <Widget>[
              Text("Pick an Image",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 5.0),
              FlatButton(
                child: Text(
                  "Use Camera",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () {
                  _getImage(context, ImageSource.camera);
                },
              ),
              FlatButton(
                child: Text("Use Gallery",
                    style: TextStyle(color: Theme.of(context).primaryColor)),
                onPressed: () {
                  _getImage(context, ImageSource.gallery);
                },
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color buttonColor = Theme.of(context).primaryColor;

    Widget imagePreview = Text("Please select an image");
    if (_imageFile != null) {
      imagePreview = Image.file(
        _imageFile,
        fit: BoxFit.fill,
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topCenter,
      );
    } else if (widget.product != null) {
      imagePreview = Image.network(
        widget.product.imageUrl,
        fit: BoxFit.fill,
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.topCenter,
      );
    }

    return Column(
      children: <Widget>[
        OutlineButton(
          borderSide: BorderSide(
            color: buttonColor,
            width: 1.0,
          ),
          onPressed: () {
            _openImagePicker(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.camera_alt,
                color: buttonColor,
              ),
              SizedBox(width: 5.0),
              Text(
                widget.product == null ? "Add/Change Image" : "Change Image",
                style: TextStyle(color: buttonColor),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        imagePreview,
      ],
    );
  }
}
