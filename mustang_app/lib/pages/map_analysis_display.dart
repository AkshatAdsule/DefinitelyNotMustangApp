import 'package:flutter/material.dart';
import 'package:mustang_app/backend/game_action.dart';
import 'package:mustang_app/components/game_map.dart';
import 'package:mustang_app/components/header.dart';
import 'package:mustang_app/components/map_analysis_text.dart';
import 'package:mustang_app/components/map_switch_button.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'package:mustang_app/constants/constants.dart';
import 'package:mustang_app/pages/game_replay.dart';
import '../components/analyzer.dart';

// ignore: must_be_immutable
class MapAnalysisDisplay extends StatefulWidget {
  static const String route = '/MapAnalysisDisplay';
  String _teamNumber = '';
  MapAnalysisDisplay({String teamNumber}) {
    _teamNumber = teamNumber;
  }
  @override
  State<StatefulWidget> createState() {
    return new _MapAnalysisDisplayState(_teamNumber);
  }
}

class _MapAnalysisDisplayState extends State<MapAnalysisDisplay> {
  Analyzer myAnalyzer;
  bool _showScoringMap = true;
  bool _accuracyMap = true;
  String _teamNumber;

  GameMap gameMap;
  MapSwitchButton switchButton;
  ActionType currentActionType = ActionType.SHOT_LOW;

  String _scoringText = Constants.minPtValuePerZonePerGame.toString() +
      " total pts                                                                     " +
      Constants.maxPtValuePerZonePerGame.toString() +
      " total pts";
  String _accuracyText =
      "0%                                                                  100%";

  _MapAnalysisDisplayState(String teamNumber) {
    myAnalyzer = new Analyzer(teamNumber);
    _teamNumber = teamNumber;
  }

  @override
  void initState() {
    super.initState();
  }

  void toggle() {
    setState(() {
      _showScoringMap = !_showScoringMap;
    });
  }

  void _toggleScreen() {
    setState(() {
      _accuracyMap = !_accuracyMap;
    });
  }

  int _getScoringColorValue(int x, int y) {
    double totalNumGames = myAnalyzer.totalNumGames().toDouble();
    double ptsAtZone =
        myAnalyzer.calcPtsAtZone(x.toDouble(), y.toDouble()) / totalNumGames;
    double ptsAtZonePerGame = ptsAtZone / totalNumGames;
    double colorValue =
        ((ptsAtZonePerGame / Constants.maxPtValuePerZonePerGame) * 900);
    int a = ((colorValue / 100).toInt()) * 100; //lower bound of 100
    int b = ((colorValue / 100).toInt() + 1) * 100; //upper bound
    int returnVal = (colorValue - a > b - colorValue) ? b : a;
    if (returnVal > 0) {
      //debugPrint("zone: (" + x.toString() + ", " + y.toString() + ")  points at zone per game: " + ptsAtZonePerGame.toString() + " color value: " + returnVal.toString());
    }
    if (returnVal > 900) {
      return 900;
    }
    return returnVal;
  }

  int _getAccuracyColorValue(int x, int y) {
    double zoneAccuracyOutOf1 =
        myAnalyzer.calcShotAccuracyAtZone(x.toDouble(), y.toDouble());
    double zoneAccuracyOutOf900 = zoneAccuracyOutOf1 * 900;
    if (!zoneAccuracyOutOf900.isInfinite && !zoneAccuracyOutOf900.isNaN) {
      int a = ((zoneAccuracyOutOf900 / 100).toInt()) * 100; //lower bound of 100
      int b = ((zoneAccuracyOutOf900 / 100).toInt() + 1) * 100; //upper bound
      int returnVal =
          (zoneAccuracyOutOf900 - a > b - zoneAccuracyOutOf900) ? b : a;
      return returnVal;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!myAnalyzer.initialized) {
      myAnalyzer.init().then((value) => setState(() {}));
    }

    ZoneGrid scoringGrid = ZoneGrid(GlobalKey(), (int x, int y) {},
        (int x, int y, bool isSelected, double cellWidth, double cellHeight) {
      return Container(
        width: cellWidth,
        height: cellHeight,
        decoration:
            BoxDecoration(color: Colors.green[_getScoringColorValue(x, y)]),
      );
    });

    ZoneGrid accuracyGrid = ZoneGrid(GlobalKey(), (int x, int y) {},
        (int x, int y, bool isSelected, double cellWidth, double cellHeight) {
      return Container(
        width: cellWidth,
        height: cellHeight,
        decoration:
            BoxDecoration(color: Colors.green[_getAccuracyColorValue(x, y)]),
      );
    });

    if (_showScoringMap == true) {
      gameMap =
          GameMap(imageChildren: [], sideWidget: null, zoneGrid: scoringGrid);
    } else {
      gameMap =
          GameMap(imageChildren: [], sideWidget: null, zoneGrid: accuracyGrid);
    }

    GameMap scoringMap =
        GameMap(imageChildren: [], sideWidget: null, zoneGrid: scoringGrid);
    GameMap accuracyMap =
        GameMap(imageChildren: [], sideWidget: null, zoneGrid: accuracyGrid);

    switchButton = new MapSwitchButton(this.toggle, _showScoringMap);
    var children2 = <Widget>[
      MapAnalysisText(myAnalyzer),
      switchButton,
      
      //dropdown
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
              fontWeight: FontWeight.bold),
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

      //shading key
      Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[50], Colors.green[900]],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.horizontal()),
        child: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width, minHeight: 60.0),
          alignment: Alignment.center,
          child: Text(
            !(switchButton.showScoringMap)
                ? "Accuracy Map\n" + _accuracyText
                : "Scoring Map\n" + _scoringText,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 16,
                height: 1),
          ),
        ),
      ),
      !(switchButton.showScoringMap) ? accuracyMap : scoringMap,
    ];

    Container gameReplay = Container(
        alignment: Alignment.center,
        child: RaisedButton(
          color: Colors.green[900],
          onPressed: () {
            _toggleScreen();
          },
          child: Text(
            _accuracyMap ? "Game Replay" : "Accuracy Map",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16, height: 1),
          ),
        ));

    return Scaffold(
      appBar: Header(context, 'Analysis' + " for Team: " + _teamNumber,
          buttons: [gameReplay]),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _accuracyMap
                ? children2
                : <Widget>[
                    GameReplay(
                      analyzer: myAnalyzer,
                    )
                  ],
          ),
        ),
      ),
    );
  }
}
