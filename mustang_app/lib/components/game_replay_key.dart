import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GameReplayKey extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _GameReplayKeyState();
  }
}

class _GameReplayKeyState extends State<GameReplayKey> {
  List<List<Object>> actionRelatedColors = [
    ["OTHER", Colors.orange],
    ["FOUL", Colors.yellow],
    ["PUSH", Colors.deepPurple],
    ["PREV", Colors.pink[200]],
    ["INTAKE", Colors.blue],
    ["MISS", Colors.red],
    ["SHOT", Colors.green],
    ["LOW", Colors.white],
    ["OUT", Colors.grey],
    ["IN", Colors.black],
  ];

  List<Widget> getShadingKey(int start, int end) {
    List<Widget> shades = [];
    Widget colorKey;
    for (int i = start; i < end; i++) {
      List<Object> shade = actionRelatedColors[i];
      colorKey = Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.circle, color: shade[1]),
            Container(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  shade[0].toString(),
                  style: TextStyle(
                    color: Colors.grey[850],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ))
          ],
        ),
      );
      shades.add(colorKey);
    }
    return shades;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: getShadingKey(0, 5),
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: getShadingKey(5, 10),
            ),
          ),
        ],
      ),
    );
  }
}
