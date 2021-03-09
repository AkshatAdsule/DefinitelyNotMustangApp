import 'package:flutter/material.dart';
import 'package:mustang_app/backend/game_action.dart';
import 'package:mustang_app/components/game_map.dart';
import 'package:mustang_app/components/game_replay.dart';
import 'package:mustang_app/components/header.dart';
import 'package:mustang_app/components/map_analysis_text.dart';
import 'package:mustang_app/components/map_switch_button.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'package:mustang_app/constants/constants.dart';
import '../components/analyzer.dart';

// ignore: must_be_immutable
class GameReplay extends StatefulWidget {
  Analyzer _analyzer;
  GameReplay(Analyzer analyzer) {
    _analyzer = analyzer;
  }
  @override
  State<StatefulWidget> createState() {
    return new _GameReplayState(_analyzer);
  }
}

class _GameReplayState extends State<GameReplay> {
  double _timeInGame;

  // ZoneGrid scoringGrid;
  List<GameAction> matchActions;
  List<GameAction> currActions;

  Analyzer _analyzer;

  GameMap gameMap;
  ActionType currentActionType;
  String matchNum = "";

  _GameReplayState(Analyzer analyzer) {
    _analyzer = analyzer;
  }

  @override
  void initState() {
    super.initState();
    _timeInGame = 0;
  }

  void displayActions(int timeInGame) {
    // variable for selected locations
    currActions = _analyzer.getActionsAtTime(matchActions, (timeInGame * 1000));
  }

  // List<Color> _getColorCombo(int x, int y) {
  //   GameAction curr;
  //   for (GameAction currentAction in currActions) {
  //     if (currentAction.x == x && currentAction.y == y) {
  //       curr = currentAction;
  //       break;
  //     }
  //   }
  //   if (curr == null) {
  //     return [Colors.white];
  //   }
  //   List<Color> gradientCombo = new List<Color>();
  //   String actionType = curr.action.toString();
  //   if (actionType.contains("OTHER"))
  //     gradientCombo.add(Colors.orange);
  //   else if (actionType.contains("FOUL"))
  //     gradientCombo.add(Colors.yellow);
  //   else if (actionType.contains("PUSH")) gradientCombo.add(Colors.purple[900]);

  //   if (actionType.contains("PREV"))
  //     gradientCombo.add(Colors.pink[200]);
  //   else if (actionType.contains("MISSED")) gradientCombo.add(Colors.red);

  //   if (actionType.contains("INTAKE"))
  //     gradientCombo.add(Colors.blue);
  //   else if (actionType.contains("SHOT")) gradientCombo.add(Colors.green);

  //   if (actionType.contains("LOw"))
  //     gradientCombo.add(Colors.white);
  //   else if (actionType.contains("OUTER"))
  //     gradientCombo.add(Colors.white30);
  //   else if (actionType.contains("INNER")) gradientCombo.add(Colors.black);

  //   return gradientCombo;
  // }

  // TODO: method for text (for shots or preventing of shtoof)
  // String _getZoneText(int x, int y) {
  //   // if (actionType.contains("INTAKE"))
  //   //   gradientCombo.add(Colors.blue);
  //   // else if (actionType.contains("SHOT")) gradientCombo.add(Colors.green);

  //   // if (actionType.contains("LOw"))
  //   //   gradientCombo.add(Colors.white);
  //   // else if (actionType.contains("OUTER"))
  //   //   gradientCombo.add(Colors.white30);
  //   // else if (actionType.contains("INNER")) gradientCombo.add(Colors.black);
  // }

  @override
  Widget build(BuildContext context) {
    debugPrint("current action type: " + currentActionType.toString());

    ZoneGrid scoringGrid = ZoneGrid(GlobalKey(), (int x, int y) {},
        (int x, int y, bool isSelected, double cellWidth, double cellHeight) {
      return Container(
        width: cellWidth,
        height: cellHeight,
        // decoration: BoxDecoration(
        //   gradient: RadialGradient(colors:
        // _getColorCombo(x, y),
        //       ),
        // )
        // child: Text(_getZoneText(x, y))
      );
    });

    GameMap scoringMap =
        GameMap(imageChildren: [], sideWidget: null, zoneGrid: scoringGrid);

    Widget dropDownList = ListTile(
      title: Text(
        'Match Number',
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
      trailing: DropdownButton<String>(
        value: matchNum,
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(
            fontSize: 14,
            color: Colors.green[300],
            fontWeight: FontWeight.bold),
        underline: Container(
          height: 2,
          color: Colors.grey[50],
        ),
        onChanged: (String match) {
          setState(() {
            matchNum = match;
          });
        },
        items: (_analyzer.getMatches())
            .map<DropdownMenuItem<String>>((String match) {
          return DropdownMenuItem<String>(
              value: match,
              child: Center(
                child: Text(match),
              ));
        }).toList(),
      ),
    );

    Widget shadingKey = Container(
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
                    Icon(Icons.circle, color: Colors.green),
                    Text('Shot',
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 14))
                  ],
                )),
          ]),
    );

    Widget timeSlider = Container(
        height: 30,
        width: 650,
        child: Slider(
          divisions: (2 * 60) + 30, // number of seconds in a game
          label: _timeInGame.round().toString(),
          onChanged: (newVal) => setState(() {
            _timeInGame = newVal;
            // displayActions(_timeInGame.round());
          }),
          min: 0,
          max: 150,
          value: _timeInGame,
        ));

    return Container(
        child: SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[dropDownList, shadingKey, scoringMap, timeSlider]),
    ));
  }
}
