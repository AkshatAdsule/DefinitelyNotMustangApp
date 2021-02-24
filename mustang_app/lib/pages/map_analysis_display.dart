import 'package:flutter/material.dart';
import 'package:mustang_app/components/game_map.dart';
import 'package:mustang_app/components/header.dart';
import 'package:mustang_app/components/map_analysis_text.dart';
import 'package:mustang_app/components/map_switch_button.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'package:mustang_app/constants/constants.dart';
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
  GameMap gameMap;
  MapSwitchButton switchButton;

  String _scoringText = Constants.minPtValuePerZonePerGame.toString() +
      " total pts                                                                     " +
      Constants.maxPtValuePerZonePerGame.toString() +
      " total pts";
  String _accuracyText =
      "0%                                                                  100%";

  _MapAnalysisDisplayState(String teamNumber) {
    myAnalyzer = new Analyzer(teamNumber);
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

  int _getScoringColorValue(int x, int y) {
    double totalNumGames = myAnalyzer.totalNumGames().toDouble();
    double ptsAtZone =
        myAnalyzer.calcPtsAtZone(x.toDouble(), y.toDouble()) / totalNumGames;
    double ptsAtZonePerGame = ptsAtZone / totalNumGames;
    return ((ptsAtZonePerGame / Constants.maxPtValuePerZonePerGame) * 900)
        .toInt();
  }

  int _getAccuracyColorValue(int x, int y) {
    double zoneAccuracyOutOf1 =
        myAnalyzer.calcShotAccuracyAtZone(x.toDouble(), y.toDouble());
    double zoneAccuracyOutOf900 = zoneAccuracyOutOf1 * 900;
    if (!zoneAccuracyOutOf900.isInfinite && !zoneAccuracyOutOf900.isNaN) {
      return (zoneAccuracyOutOf900).toInt();
    } else {
      return 0;
    }
  }

  //zones start at 0, see miro but climb up, no sense of columns or row so need to convert
  /*
  double zoneToX(int zone) {
    return zone - (zoneToY(zone) * Constants.zoneColumns);
  }

  double zoneToY(int zone) {
    double y = 0;
    while (zone >= Constants.zoneColumns) {
      zone -= Constants.zoneColumns;
      y++;
    }
    return y;
  }
  */

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

    switchButton = new MapSwitchButton(this.toggle, _showScoringMap);

    return Scaffold(
      appBar: Header(context, 'Analysis'),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Image.asset('assets/croppedmap.png', fit: BoxFit.contain),
              MapAnalysisText(myAnalyzer),
              switchButton,

              //i need to have it here bc otherwise it won't update showScoringMap
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
                      maxWidth: MediaQuery.of(context).size.width,
                      minHeight: 60.0),
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
              gameMap,

              //MapShadingKey(switchButton),
              //MapShadingScoringKey(),
              //MapShadingAccuracyKey(),
            ],
          ),
        ),
      ),
    );
  }
}
