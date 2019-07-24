import 'package:flutter/material.dart';
import 'package:hotel_automation/Home.dart';
class QrRes  extends StatefulWidget {
  final List data;
  final String scan;
  final int index;
  QrRes({Key key, this.scan, this.data, this.index}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _QrRes();
  }
  
}

class _QrRes extends State<QrRes> {

  @override
  Widget build(BuildContext context) {
    if("${widget.scan}"=="true"){
     
    return Scaffold(appBar: AppBar(
      centerTitle:true,
      title: Text("INFO"),
    ), 
      body:  new Column(
      children: <Widget>[
        Padding(
          padding:EdgeInsets.all(8),
          child:Card(
            child:Text("qr response"),
          ),
        ),
      ],
    )      
    
    );
    }
    else{
       int indexed=int.parse("${widget.index}");
      return Scaffold(appBar: AppBar(
      centerTitle:true,
      title: Text("INFO"),
    ), 
      body:  new ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int i) {
              return new Text("${widget.data[indexed]["item_name"]}");
            })
    );

    }
      
    
  }
}