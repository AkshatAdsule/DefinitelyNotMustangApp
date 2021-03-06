import 'package:flutter/material.dart';
import 'package:mustang_app/backend/game_action.dart';
import 'package:mustang_app/components/game_map.dart';
import 'package:mustang_app/components/header.dart';
import 'package:mustang_app/components/map_analysis_dropdown.dart';
import 'package:mustang_app/components/map_analysis_text.dart';
import 'package:mustang_app/components/map_switch_button.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'package:mustang_app/constants/constants.dart';
import '../components/analyzer.dart';

// ignore: must_be_immutable
class GameReplay extends StatefulWidget {
  // static const String route = '/MapAnalysisDisplay';
  Analyzer _analyzer;
  GameReplay({Analyzer analyzer}) {
    _analyzer = analyzer;
  }
  @override
  State<StatefulWidget> createState() {
    return new _GameReplayState(_analyzer);
  }
}

class _GameReplayState extends State<GameReplay> {
  double _timeInGame;

  ZoneGrid scoringGrid;
  String matchNum = "-";
  List<GameAction> matchActions;
  Analyzer _analyzer;

  _GameReplayState(Analyzer analyzer) {
    _analyzer = analyzer;
  }

  @override
  void initState() {
    super.initState();
    _timeInGame = 0;
  }

  void displayActions(double timeInGame) {
    //variable for selected locations
    //getActionsAtTime()

    // for (int i = 0; i < timeInGame; i++) {
    //   GameAction curAction = totalActions[i];
    //   RadialGradient(colors: _getColorCombo(curAction));
    // }

    ZoneGrid scoringGrid = ZoneGrid(GlobalKey(), (int x, int y) {},
        (int x, int y, bool isSelected, double cellWidth, double cellHeight) {
      return Container(
          width: cellWidth,
          height: cellHeight,
          decoration: BoxDecoration(color: Colors.green)
          //_getColorCombo(x, y)]),
          );
    });
    //
  }

  //method for text (for shots or preventing of shtoof)

  List<Color> _getColorCombo(GameAction currentAction) {
    List<Color> gradientCombo = new List<Color>();
    String actionType = currentAction.action.toString();
    if (actionType.contains("OTHER"))
      gradientCombo.add(Colors.orange);
    else if (actionType.contains("FOUL"))
      gradientCombo.add(Colors.yellow);
    else if (actionType.contains("PUSH")) gradientCombo.add(Colors.purple[900]);

    if (actionType.contains("PREV"))
      gradientCombo.add(Colors.purple);
    else if (actionType.contains("MISSED")) gradientCombo.add(Colors.red);

    if (actionType.contains("INTAKE"))
      gradientCombo.add(Colors.blue);
    else if (actionType.contains("SHOT")) gradientCombo.add(Colors.green);

    if (actionType.contains("LOw"))
      gradientCombo.add(Colors.white);
    else if (actionType.contains("OUTER"))
      gradientCombo.add(Colors.white30);
    else if (actionType.contains("INNER")) gradientCombo.add(Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    GameMap gameMap =
        GameMap(imageChildren: [], sideWidget: null, zoneGrid: scoringGrid);

    return Scaffold(
      appBar: Header(context, 'Analysis'),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
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
                  items: _analyzer
                      .getMatches()
                      .map<DropdownMenuItem<String>>((String match) {
                    return DropdownMenuItem<String>(
                        value: matchNum,
                        child: Center(
                          child: Text(matchNum),
                        ));
                  }).toList(),
                ),
              ),
              //Image.asset('assets/croppedmap.png', fit: BoxFit.contain),
              // scoringGrid,
              //slider
              // Container(
              //     height: 30,
              //     width: 400,
              //     child: Slider(
              //       divisions: (2 * 60) + 30, // number of seconds in a game
              //       label: _timeInGame.round().toString(),
              //       onChanged: (newVal) => setState(() {
              //         _timeInGame = newVal;
              //         displayActions(_timeInGame);
              //       }),
              //       min: 0,
              //       max: 150,
              //       value: _timeInGame,
              //     )),
              // //key
              // Row(
              //   children: [
              //     FlatButton(
              //         onPressed: null,
              //         child: Container(
              //             height: 50.0,
              //             child: RaisedButton(
              //               onPressed: () {},
              //               shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(80.0)),
              //               padding: EdgeInsets.all(0.0),
              //               child: Ink(
              //                 decoration: BoxDecoration(
              //                     // gradient:, colors that matter],
              //                     borderRadius: BorderRadius.horizontal()),
              //                 child: Container(
              //                   constraints: BoxConstraints(
              //                       maxWidth: MediaQuery.of(context).size.width,
              //                       minHeight: 60.0),
              //                   alignment: Alignment.center,
              //                   child: Text(
              //                     "Game Replay",
              //                     textAlign: TextAlign.center,
              //                     style: TextStyle(
              //                         color: Colors.grey[800],
              //                         fontWeight: FontWeight.bold,
              //                         fontSize: 16,
              //                         height: 1),
              //                   ),
              //                 ),
              //               ),
              //             )))
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
