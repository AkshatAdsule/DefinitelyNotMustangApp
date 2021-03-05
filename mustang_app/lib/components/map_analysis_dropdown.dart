import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mustang_app/backend/game_action.dart';
import 'package:mustang_app/exports/pages.dart';

class MapAnalysisDropdown extends StatefulWidget {
  //ActionType currentActionType = ActionType.SHOT_LOW;
  //ActionType get currentAction => MapAnalysisDropdownState.currentActionType;
  const MapAnalysisDropdown ({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MapAnalysisDropdownState();
}

class MapAnalysisDropdownState extends State<MapAnalysisDropdown> {
  ActionType currentActionType = ActionType.SHOT_LOW;

  //ActionType get currentActionType => _currentActionType;

  Widget build(BuildContext context) {
    //debugPrint("current action type: " + _currentActionType.toString());
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'Action Type',
              textAlign: TextAlign.right,
              style: new TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                background: Paint()
                            ..strokeWidth = 30.0
                            ..color = Colors.green[300]
                            ..style = PaintingStyle.stroke
                            ..strokeJoin = StrokeJoin.bevel,
              ),
            ),
            trailing: DropdownButton<ActionType>(
              value: currentActionType,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(
                fontSize: 14,
                color: Colors.green[300],
                fontWeight: FontWeight.bold
                ),
                
              underline: Container(
                height: 2,
                color: Colors.grey[50],
              ),
              
              onChanged: (ActionType actionType) {
                setState(() {
                  currentActionType = actionType;
                });
              },
              items: <ActionType>[
                ActionType.SHOT_LOW,
                ActionType.SHOT_OUTER,
                ActionType.SHOT_INNER
              ].map<DropdownMenuItem<ActionType>>((ActionType actionType) {
                return DropdownMenuItem<ActionType>(
                  value: actionType,
                  child: Center(
                      child: Text(actionType
                          .toString()
                          .substring(actionType.toString().indexOf('.') + 1))),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
