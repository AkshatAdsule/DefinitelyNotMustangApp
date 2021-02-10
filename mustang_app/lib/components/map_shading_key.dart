import 'package:flutter/material.dart';
import 'package:mustang_app/constants/constants.dart';

class MapShadingKey extends StatefulWidget {
  //static const Color autoBalls = Colors.green;
  //static const Color teleBalls = Colors.yellow;
  //static const Color startPos = Colors.redAccent;
  //static const Color autoStopPos = Colors.blueAccent;

  @override
  State<StatefulWidget> createState() {
    return new _MapShadingKeyState();
  }
}

class _MapShadingKeyState extends State<MapShadingKey> {
  double iconSize = 65;
  //Color autoBalls = Colors.green;
  //Color teleBalls = Colors.yellow;
  //Color startPos = Colors.redAccent;
  //Color autoStopPos = Colors.blueAccent;
  List<Color> incrementColor = new List();
 
  //Color incrementOne = Colors.green[Constants.colorIncrement.toInt()];
  //Color incrementTwo = Colors.green[Constants.colorIncrement.toInt()*2];

  void _setColorList(){
    for (int i = 1; Constants.colorIncrement.toInt()*i <= 600; i++){
      incrementColor.add(Colors.green[Constants.colorIncrement.toInt()*i]);
    }
  }

  List _getTextList(){
    List<Text> result = new List();
    for (int i = 0; i < 5; i+=Constants.shadingPointDifference){
      String text = i.toString() + "-" + (i+Constants.shadingPointDifference - 1).toString() + " points";
      result.add(Text(text,
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 14)));
    }
    return result;
  }
  @override
  Widget build(BuildContext context) {
    _setColorList();
    List<Text> text = _getTextList();
    int i = 0;
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.crop_square, size: iconSize, color: incrementColor[0]),
                    text[0]
                  ]),
              
            ),
            
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    Icon(Icons.crop_square, size: iconSize, color: incrementColor[1]),
                    text[1]
                  ]),
            )
            
          ]),
          
    );
  }
}