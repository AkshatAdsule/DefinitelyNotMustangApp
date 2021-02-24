import 'package:flutter/material.dart';

class MapSwitchButton extends StatefulWidget {
  void Function() onToggle;
  bool _showScoringMap;

  MapSwitchButton(this.onToggle, this._showScoringMap);

  @override
  State<StatefulWidget> createState() {
    return new _MapSwitchButtonState(onToggle, _showScoringMap);
  }
}

class _MapSwitchButtonState extends State<MapSwitchButton> {
  void Function() onToggle;
  bool _showScoringMap;

  _MapSwitchButtonState(this.onToggle, this._showScoringMap);
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
                  onToggle();
                  _showScoringMap = !_showScoringMap;
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
                        !_showScoringMap ? "Scoring Map" : "Accuracy Map",
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
