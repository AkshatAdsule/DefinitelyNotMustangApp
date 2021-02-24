import 'package:flutter/material.dart';
import 'package:mustang_app/constants/constants.dart';

class MapShadingScoringKey extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MapShadingScoringKeyState();
  }
}

class _MapShadingScoringKeyState extends State<MapShadingScoringKey> {
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
                      Constants.minPtValuePerZonePerGame.toString() + 
                      " total pts                                        " +
                      Constants.maxPtValuePerZonePerGame.toString() + " total pts",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}
