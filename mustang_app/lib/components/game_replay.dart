import 'package:flutter/material.dart';
import 'package:mustang_app/backend/game_action.dart';
import 'package:mustang_app/backend/match.dart';
import 'package:mustang_app/components/game_map.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'package:mustang_app/constants/constants.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class GameReplay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _GameReplayState();
  }
}

class _GameReplayState extends State<GameReplay> {
  double timeInGame;
  bool _initialized = false;
  List<GameAction> matchActions = [];
  List<GameAction> currActions = [];
  List<List<Object>> actionRelatedColors = [
    ["OTHER", Colors.orange],
    ["FOUL", Colors.yellow],
    ["PUSH", Colors.deepPurple],
    ["PREV", Colors.pink[200]],
    ["MISSED", Colors.red],
    ["INTAKE", Colors.blue],
    ["SHOT", Colors.green],
    ["LOW", Colors.white],
    ["OUTER", Colors.grey],
    ["INNER", Colors.black],
  ];

  GameMap gameMap;
  String matchNum = "";

  @override
  void initState() {
    super.initState();
    timeInGame = 10;
  }

  void init(Match match) {
    setState(() {
      _initialized = true;
      matchNum = match.matchNumber;
      matchActions = match.actions;
      currActions = match.actions;
      timeInGame = Constants.matchEndMillis / 1000;
    });
  }

  List<Color> _getColorCombo(int x, int y) {
    GameAction curr;
    for (GameAction currentAction in currActions) {
      if (currentAction.x == x && currentAction.y == y) {
        curr = currentAction;
        break;
      }
    }
    if (curr == null) return [Colors.green[0], Colors.transparent];

    List<Color> gradientCombo = [];
    String actionType = curr.action.toString();

    for (List<Object> shade in actionRelatedColors)
      if (actionType.contains(shade[0])) gradientCombo.add(shade[1]);

    if (gradientCombo.length < 2) {
      if (actionType.contains("FOUL")) {
        gradientCombo.add(Colors.yellow[600]);
      } else if (actionType.contains("OTHER")) {
        gradientCombo.add(Colors.orange[600]);
      }
    }

    return gradientCombo;
  }

  // TODO: method for text (for shots or preventing of shtoof)
  // String _getZoneText(GameAction action, int x, int y) {
  //   String type = action.action.toString();
  //   if (type.contains("INTAKE") || type.contains("SHOT")) return "+1";
  // }

  @override
  Widget build(BuildContext context) {
    List<Match> matches = Provider.of<List<Match>>(context);
    if (!_initialized && matches.length > 0) {
      init(matches.first);
    }

    Widget scoringMap = Container(
        padding: EdgeInsets.all(20),
        child: GameMap(
            imageChildren: [],
            sideWidget: null,
            zoneGrid: ZoneGrid(GlobalKey(), (int x, int y) {}, (int x, int y,
                bool isSelected, double cellWidth, double cellHeight) {
              return Container(
                width: cellWidth,
                height: cellHeight,
                decoration: (x != 0 && y != 0)
                    ? BoxDecoration(
                        gradient: RadialGradient(
                          colors: _getColorCombo(x, y),
                        ),
                      )
                    : BoxDecoration(color: Colors.transparent),
              );
            })));

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
            matchActions = matches
                .where((element) => element.matchNumber == matchNum)
                .first
                .actions;
          });
        },
        items: matches
            .map((e) => e.matchNumber)
            .map<DropdownMenuItem<String>>((String match) {
          var dropdownMenuItem = DropdownMenuItem<String>(
              value: match,
              child: Center(
                child: Text(match),
              ));
          return dropdownMenuItem;
        }).toList(),
      ),
    );

    Widget timeSlider = Container(
        height: 30,
        width: 650,
        child: Slider(
          divisions: (2 * 60) + 30, // number of seconds in a game
          label: timeInGame.round().toString(),
          onChanged: (newVal) => setState(() {
            timeInGame = newVal;
            setState(() {
              currActions = matchActions
                  .where((element) => element.timeStamp > newVal * 1000 - 5000)
                  .where((element) => element.timeStamp < newVal * 1000 + 5000)
                  .toList();
            });
          }),
          min: 0,
          max: 150, // number of seconds in a game
          value: timeInGame,
        ));

   /* return Container(
      child:
          //   SingleChildScrollView(
          // child:
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            dropDownList,
            normalizedToRightSideText,
            Row(children: [
              Flexible(flex: 2, child: scoringMap),
              Flexible(flex: 1, child: shadingKey),
            ]),
            timeSlider
          ]),
      // )
    );
    */
  }
}
