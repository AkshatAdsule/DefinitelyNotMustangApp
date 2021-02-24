import 'package:flutter/material.dart';
import 'package:mustang_app/constants/constants.dart';
//import 'package:mustang_app/constants/constants.dart';

class MapShadingAccuracyKey extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MapShadingAccuracyKeyState();
  }
}

class _MapShadingAccuracyKeyState extends State<MapShadingAccuracyKey> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Container(
              height: 50.0,
              child: RaisedButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green[100], Colors.green[600]],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(80.0)),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "0%                                                            100%",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            /*
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Icon(Icons.crop_square, size: iconSize, color: incrementColor[0]),
                    //text[0]
                  ]),
            ),

            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.crop_square,
                        size: iconSize, color: incrementColor[1]),
                    //text[1]
                  ]),
            )
            */
          ]),
    );
  }
}
