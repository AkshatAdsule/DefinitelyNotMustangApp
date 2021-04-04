import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MapSwitchButton extends StatefulWidget {
  void Function() onToggle;
  bool showScoringMap = true;

  MapSwitchButton(this.onToggle, this.showScoringMap);

  @override
  State<StatefulWidget> createState() {
    return new _MapSwitchButtonState(onToggle, showScoringMap);
  }
}

class _MapSwitchButtonState extends State<MapSwitchButton> {
  void Function() onToggle;
  bool showScoringMap = true;

  _MapSwitchButtonState(this.onToggle, this.showScoringMap);

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
              child: ElevatedButton(
                onPressed: () {
                  onToggle();
                  showScoringMap = !showScoringMap;
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                      color: Colors.green[300],
                      borderRadius: BorderRadius.circular(80.0)),
                  child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        !widget.showScoringMap ? "Scoring Map" : "Accuracy Map",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )),
                ),
              ),
            ),
          ]),
    );
  }
}
