import 'package:flutter/material.dart';
import 'package:mustang_app/components/game_map.dart';
import 'package:mustang_app/components/header.dart';
import 'package:mustang_app/components/map_shading_key.dart';
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
  String _teamNumber;
  //MapAnalysisShading shading;

  _MapAnalysisDisplayState(String teamNumber) {
    myAnalyzer = new Analyzer(teamNumber);
    _teamNumber = teamNumber;
    //shading = new MapAnalysisShading();
  }

  @override
  void initState() {
    super.initState();
  }

  //returns number out of 600 for color, depending on ptsAtZone
  Color _getColor(int x, int y) {
    int colorValue = _getColorValue(x, y);
    if (colorValue == 0) {
      return Colors.transparent;
    } else {
      //green must be 50, 100, 200 etc... but no  number in between
      if (colorValue <= 50) {
        return Colors.green[50].withOpacity(0.75);
      }
      if (colorValue > 50 && colorValue <= 100) {
        return Colors.green[100].withOpacity(0.75);
      }
      if (colorValue > 100 && colorValue <= 200) {
        return Colors.green[200].withOpacity(0.75);
      }
      if (colorValue > 200 && colorValue <= 300) {
        return Colors.green[300].withOpacity(0.75);
      }
      if (colorValue > 300 && colorValue <= 400) {
        return Colors.green[400].withOpacity(0.75);
      }
      if (colorValue > 400 && colorValue <= 500) {
        return Colors.green[500].withOpacity(0.75);
      }
      if (colorValue > 500 && colorValue <= 600) {
        return Colors.green[600].withOpacity(0.75);
      }
    }
  }

  int _getColorValue(int x, int y) {
    double totalNumGames = myAnalyzer.totalNumGames().toDouble();
    double ptsAtZone =
        myAnalyzer.calcPtsAtZoneMapDisplay(x.toDouble(), y.toDouble()) /
            totalNumGames;
    return ((ptsAtZone / Constants.maxPtValuePerZone) * 600).toInt();
  }

  //zones start at 0, see miro but climb up, no sense of columns or row so need to convert
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

  @override
  Widget build(BuildContext context) {
    if (!myAnalyzer.initialized) {
      myAnalyzer.init().then((value) => setState(() {}));
    }

    String switchText = "Accuracy Map"; //other option is "Point Map"
    ZoneGrid grid = ZoneGrid(GlobalKey(), (int x, int y) {},
        (int x, int y, bool isSelected, double cellWidth, double cellHeight) {
      return Container(
        width: cellWidth,
        height: cellHeight,
        decoration: BoxDecoration(color: _getColor(x, y)),
      );
    });

    GameMap gameMap =
        GameMap(imageChildren: [], sideWidget: null, zoneGrid: grid);

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
              RaisedButton(
                onPressed: () {
                  debugPrint("ON PRESSED");
                  if (switchText == "Accuracy Map") {
                    switchText = "Point Map";
                    debugPrint(switchText);
                  }
                  if (switchText == "Point Map") {
                    switchText = "Accuracy Map";
                    debugPrint(switchText);
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green[50], Colors.green[600]],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(80.0)),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      switchText,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              gameMap,
              //plotter,
              //MapScouterKey(),
              MapShadingKey(),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
