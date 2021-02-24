import 'package:flutter/material.dart';
import 'package:mustang_app/constants/constants.dart';
import 'package:mustang_app/components/map_switch_button.dart';

class MapShadingKey extends StatefulWidget {
  //bool _showScoringMap;
  MapSwitchButton _switchButton;
  MapShadingKey(this._switchButton);
  
  @override
  State<StatefulWidget> createState() {
    return new _MapShadingKeyState(_switchButton);
  }
}

class _MapShadingKeyState extends State<MapShadingKey> {
  MapSwitchButton _switchButton;
  //bool _showScoringMap;
  String _scoringText = Constants.minPtValuePerZonePerGame.toString() + 
                      " total pts                                        " +
                      Constants.maxPtValuePerZonePerGame.toString() + " total pts";
  String _accuraracyText = "0%                                                            100%";

  _MapShadingKeyState(this._switchButton);

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
                      !(_switchButton.showScoringMap) ? _accuraracyText : _scoringText,
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
