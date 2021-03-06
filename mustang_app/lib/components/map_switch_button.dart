import 'package:flutter/material.dart';

class MapSwitchButton extends StatefulWidget {
  get displayAccuracyMap => displayAccuracyMap();

  @override
  State<StatefulWidget> createState() {
    return new _MapSwitchButtonState();
  }
}

class _MapSwitchButtonState extends State<MapSwitchButton> {
  //String switchText = "Accuracy Map"; //other option is "Scoring Map"
  bool _accuracyMapText = true;

  //should display show accuracy map or not (scoring)
  bool displayAccuracyMap() {
    return !_accuracyMapText;
  }

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
                onPressed: () {
                  if (_accuracyMapText) {
                    setState(() {
                      _accuracyMapText = false;
                    });
                  } else {
                    setState(() {
                      _accuracyMapText = true;
                    });
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green[50], Colors.green[600]],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(80.0)),
                  child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        !_accuracyMapText ? "Scoring Map" : "Accuracy Map",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ),
            ),
          ]),
    );
  }
}
