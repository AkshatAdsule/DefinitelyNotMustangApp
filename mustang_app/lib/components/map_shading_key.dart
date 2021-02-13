import 'package:flutter/material.dart';
import 'package:mustang_app/constants/constants.dart';
//import 'package:mustang_app/constants/constants.dart';

class MapShadingKey extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MapShadingKeyState();
  }
}

class _MapShadingKeyState extends State<MapShadingKey> {
  double iconSize = 65;
  //List<Color> incrementColor = new List();
  /*
  void _setColorList() {
    for (int i = 1; Constants.colorIncrement.toInt() * i <= 600; i++) {
      incrementColor.add(Colors.green[Constants.colorIncrement.toInt() * i]);
    }
  }
  */
  /*
  List _getTextList() {
    List<Text> result = new List();
    for (int i = 0; i < 5; i += Constants.shadingPointDifference) {
      String text = i.toString() +
          "-" +
          (i + Constants.shadingPointDifference - 1).toString() +
          " points";
      result.add(Text(text,
          style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
              fontSize: 14)));
    }
    return result;
  }
  */

  @override
  Widget build(BuildContext context) {
    //_setColorList();
    //List<Text> text = _getTextList();
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
                      Constants.minPtValuePerZone.toString() + 
                      " total pts                                            " +
                      Constants.maxPtValuePerZone.toString() + " total pts",
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
