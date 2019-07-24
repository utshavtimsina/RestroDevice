import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  final List data;
  final int v;
  Cart({Key key, this.data, this.v}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Cart();
  }
}

class _Cart extends State<Cart> {
  Widget build(BuildContext context) {
    // TODO: implement build
    
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Cart")),
        body: new ListView.builder(
            itemCount: int.parse("${widget.v}"),
            itemBuilder: (BuildContext context, int index) {
              return new Text("${widget.data[index]["item_name"]}");
            }));
  }
}
