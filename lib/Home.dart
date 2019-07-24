import 'dart:io';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hotel_automation/Cart.dart';
import 'package:hotel_automation/QrRes.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class Menu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Menu();
  }
}

class _Menu extends State<Menu> {
  String _scan, _value = "", a = "qr", scan = "false";
  List items, name, jsn, res;
  List bytes = new List();
  List<Image> img = new List();
  int counter = 0, select = 0, tap = 1, d;
  //Data request to server
  //getData function
  Future<String> getData() async {
    if (scan == "false") {
      http.Response response =
          await http.get(Uri.encodeFull("http://192.168.137.1:8080/welcome"));

      this.setState(() {
        jsn = json.decode(response.body);
        print("len:");
        print(jsn.length);
        for(int i =0;i<jsn.length;i++){
           bytes.add(base64.decode(jsn[i]["image"]));
           img.add(Image.memory(bytes[i]));
          
        }
      });
      print(jsn);
    } else {
      http.Response response = await http
          .get(Uri.encodeFull("http://192.168.100.6:8080/orders?table_no=2"));

      this.setState(() {
        res = json.decode(response.body);
      });
      scan = "false";
      print("values:");
      print(res);
    }
  }

  @override
  void initState() {
    this.getData();
  }

  //Qr Scan
  Future _qr() async {
    scan = "true";
    _scan = await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true);
    setState(() {
      _value = _scan;
      items = _value.split("/");
      if (items.contains("KCC")) {
        getData();
        a = items[1];
        print(_value);
        //index = data[7]["price"];
      } else {
        a = "Unauthorized QrCode";
        print(a);
      }
    });
  }

//App UI starts here...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("KCC Restaurant")),

      body: ListView.builder(
          itemCount: jsn == null ? 0 : jsn.length,
          itemBuilder: (BuildContext context, int index) {
            name = jsn[index]["item_name"].split(":");
              //var img = jsn[index]["image"];           
            
            return GestureDetector(
                //onTap:(){print(index.toString());},
                child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        d = index;
                        print("card");
                        var route = MaterialPageRoute(
                          builder: (BuildContext context) =>
                              QrRes(scan: scan, data: jsn, index: d),
                        );
                        Navigator.of(context).push(route);
                      },
                      splashColor: Colors.green.withAlpha(100),
                      child: Column(
                        children: <Widget>[
                          Image.network();
                          Padding(
                            padding: EdgeInsets.only(top: 4, bottom: 8),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Rs. " + jsn[index]["price"].toString(),
                                ),

                                //Card's cart icon
                                Text(name[0]),

                                InkWell(
                                  child: Badge(
                                    badgeContent:
                                        Icon(Icons.add_shopping_cart, size: 20),
                                    badgeColor: getColor(),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      
                                      tap++;
                                      if (tap == 3) {
                                        select = 0;
                                        tap = 1;
                                        counter--;
                                      } else {
                                        select = 1;
                                        counter++;
                                      }
                                    });
                                  },
                                ),

                                /*Icon(Icons.add_shopping_cart,
                                          size: 20,color:Colors.red),*/
                              ],
                            ),
                          ),

                          /*Text(name[1],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300)),*/
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ));
          }),
      //Buttons
      floatingActionButton: Stack(
        children: <Widget>[
          //Cart Button
          Padding(
            padding: EdgeInsets.only(right: 0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: "btn1",
                onPressed: () {
                  var route = MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Cart(data: jsn, v: counter),
                  );
                  Navigator.of(context).push(route);
                  /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Cart(order);
                  }));*/
                },
                child: Badge(
                  padding: EdgeInsets.all(4),
                  badgeColor: Colors.white,
                  shape: BadgeShape.square,
                  borderRadius: 15,
                  badgeContent: Text(
                    counter.toString(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  child: Icon(
                    Icons.add_shopping_cart,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            //QrScan Button
            padding: EdgeInsets.only(left: 30),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                heroTag: "btn2",
                onPressed: () {
                  _qr();
                  var route = MaterialPageRoute(
                    builder: (BuildContext context) =>
                        QrRes(scan: scan, data: jsn, index: d),
                  );
                  Navigator.of(context).push(route);
                },
                child: Icon(
                  Icons.camera_enhance,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color getColor() {
    if (select == 0) {
      return Colors.grey;
    } else
      return Colors.red;
  }

  ListView listView() {}
}
