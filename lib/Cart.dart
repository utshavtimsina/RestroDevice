import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:badges/badges.dart';

class Cart extends StatefulWidget {
  final List data;
  final int v;
  final List jsn;
  final String ip;
  Cart({Key key, this.data, this.v,this.ip,this.jsn}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Cart();
  }
}

class _Cart extends State<Cart> {
  String img;
  int qty=0;
  List<int> selected = new List<int>();
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Cart")),
        body: new ListView.builder(
            itemCount: int.parse("${widget.v}"),
            itemBuilder: (BuildContext context, int index) {
              int ind = int.parse("${widget.data[index]}");
              
              img = "${widget.jsn[ind]["image"]}";
             // selected.add(0);
           //   print(selected[index].toString()+index.toString());
              return new Card(
                child: ListTile(
                  leading: Image.network("http://192.168.137.1:8080/Image?name=$img"),
                  title: Text("${widget.jsn[ind]["item_name"]}"),
                  trailing: Text(
                    "RS." + "${widget.jsn[ind]["price"]}",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          size: 18,
                        ),
                        onPressed: () {
                          
                          setState(() {
                          selected[index]=1;
                          changeQty(index);
                            
                          });
                          
                        },
                      ),
                      Badge(
                        badgeContent: Text(
                          qty.toString(),
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        badgeColor: Colors.white,
                        shape: BadgeShape.square,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.remove,
                          size: 18,
                        ),
                        onPressed: () {
                           
                          print(index);
                          setState(() {
                          selected[index]=2;
                          changeQty(index);
                          });
                          
                        },
                      ),
                    ],
                  ),
                ),
              );
            }));
  }

  int changeQty(int index){
    if(selected[index]==1){
      return qty++;
    }
    else{
      return qty--;
    }

  }
}
