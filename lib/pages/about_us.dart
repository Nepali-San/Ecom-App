import 'package:flutter/material.dart';
import 'package:practise_app1/Widgets/ui_elements/myDrawer.dart';

class Aboutus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(3),
      appBar: AppBar(
        title: Text("About Us"),        
      ),
      body: Center(
        child: Text("About us page"),
      ),
    );
  }
}
