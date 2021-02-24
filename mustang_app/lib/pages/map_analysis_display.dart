import 'package:flutter/material.dart';
import 'package:mustang_app/components/game_map.dart';
import 'package:mustang_app/components/header.dart';
import 'package:mustang_app/components/map_analysis_text.dart';
import 'package:mustang_app/components/map_shading_accuracy_key.dart';
import 'package:mustang_app/components/map_shading_scoring_key.dart';
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

  //String _teamNumber;
  //MapAnalysisShading shading;

  _MapAnalysisDisplayState(String teamNumber) {
    myAnalyzer = new Analyzer(teamNumber);
    //_teamNumber = teamNumber;
    //shading = new MapAnalysisShading();
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
    return ((ptsAtZonePerGame / Constants.maxPtValuePerZonePerGame) * 600)
        .toInt();
  }

  int _getAccuracyColorValue(int x, int y) {
    double zoneAccuracyOutOf1 =
        myAnalyzer.calcShotAccuracyAtZone(x.toDouble(), y.toDouble());
    return (600 * zoneAccuracyOutOf1).toInt();
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

  GameMap _getGameMap(ZoneGrid scoringGrid, ZoneGrid accuracyGrid) {
    if (_showScoringMap == true) {
      return GameMap(
          imageChildren: [], sideWidget: null, zoneGrid: scoringGrid);
    } else {
      return GameMap(
          imageChildren: [], sideWidget: null, zoneGrid: accuracyGrid);
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
    debugPrint("test");
    GameMap gameMap;
    if (_showScoringMap == true) {
      gameMap =
          GameMap(imageChildren: [], sideWidget: null, zoneGrid: scoringGrid);
    } else {
      gameMap =
          GameMap(imageChildren: [], sideWidget: null, zoneGrid: accuracyGrid);
    }

    GameMap scoringGameMap =
        GameMap(imageChildren: [], sideWidget: null, zoneGrid: scoringGrid);
    GameMap accuracyGameMap =
        GameMap(imageChildren: [], sideWidget: null, zoneGrid: accuracyGrid);

    return Scaffold(
      appBar: Header(context, 'Analysis'),
      body: Container(
        // height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          // child: ConstrainedBox(
          //   constraints: BoxConstraints(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Image.asset('assets/croppedmap.png', fit: BoxFit.contain),
              MapAnalysisText(myAnalyzer),
              MapSwitchButton(this.toggle, _showScoringMap),

              //scoringGameMap,
              gameMap,
              //WHY IS THIS NOT WORKING FLKSDFK
              //!switchButton.displayAccuracyMap ? accuracyGameMap : scoringGameMap,
              //MapSwitchButton().displayAccuracyMap ? accuracyGameMap : scoringGameMap,
              // _getGameMap(scoringGrid, accuracyGrid),
              //plotter,
              MapShadingScoringKey(),
              MapShadingAccuracyKey(),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
