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
  double _timeInGame = 0;
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
    _timeInGame = 0;
  }

  void init(Match match) {
    setState(() {
      _initialized = true;
      matchNum = match.matchNumber;
      matchActions = match.actions;
      currActions = match.actions;
      _timeInGame = Constants.matchEndMillis / 1000;
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
    if (curr == null) return [Colors.white, Colors.transparent];

    List<Color> gradientCombo = [];
    String actionType = curr.action.toString();

    for (List<Object> shade in actionRelatedColors)
      if (actionType.contains(shade[0])) gradientCombo.add(shade[1]);

    return gradientCombo;
  }

  // TODO: method for text (for shots or preventing of shtoof)
  String _getZoneText(GameAction action, int x, int y) {
    String type = action.action.toString();
    if (type.contains("INTAKE") || type.contains("SHOT")) return "+1";
  }

  List<Widget> getShadingKey(int start, int end) {
    List<Widget> shades = [];
    Widget colorKey;
    for (int i = start; i < end; i++) {
      List<Object> shade = actionRelatedColors[i];
      colorKey = Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.circle, color: shade[1]),
            Text(
              shade[0].toString(),
              style: TextStyle(
                color: Colors.grey[850],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            )
          ],
        ),
      );
      shades.add(colorKey);
    }
    return shades;
  }

  @override
  Widget build(BuildContext context) {
    List<Match> matches = Provider.of<List<Match>>(context);
    print('matches: $matches');
    if (!_initialized && matches.length > 0) {
      init(matches.first);
    }
    ZoneGrid scoringGrid = ZoneGrid(GlobalKey(), (int x, int y) {},
        (int x, int y, bool isSelected, double cellWidth, double cellHeight) {
      return Container(
        width: cellWidth,
        height: cellHeight,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: _getColorCombo(x, y),
            // [Colors.white, Colors.green],
          ),
        ),
        // TODO: add to game action the ability to merge actions together, ex. shotss
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
            matchActions = matches
                .where((element) => element.matchNumber == matchNum)
                .first
                .actions;
          });
        },
        items: matches
            .map((e) => e.matchNumber)
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
        margin: EdgeInsets.all(2),
        child: Column(children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: getShadingKey(0, 5)),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: getShadingKey(5, 10)),
        ]));

    Widget timeSlider = Container(
        height: 30,
        width: 650,
        child: Slider(
          divisions: (2 * 60) + 30, // number of seconds in a game
          label: _timeInGame.round().toString(),
          onChanged: (newVal) => setState(() {
            _timeInGame = newVal;
            setState(() {
              currActions = matchActions
                  .where((element) => element.timeStamp > newVal * 1000 - 5000)
                  .where((element) => element.timeStamp < newVal * 1000 + 5000)
                  .toList();
            });
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
