import 'package:flutter/material.dart';
import 'package:mustang_app/components/game_map.dart';
import 'package:mustang_app/components/header.dart';
import 'package:mustang_app/components/map_analysis_shading.dart';
import 'package:mustang_app/components/map_shading_key.dart';
import 'package:mustang_app/components/zone_grid.dart';
import 'package:mustang_app/constants/constants.dart';
import '../components/analyzer.dart';
import '../utils/symbolplotter.dart';
import '../backend/team_data_analyzer.dart';
import '../components/map_scouter_key.dart';

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

  Color _getColor(int x, int y) {
    //debugPrint("zone: " + zoneNum.toString() + " ptsAtZone: " + myAnalyzer.calcPtsAtZoneMapDisplay(x, y).toString() + ", (" + x.toString() + ", " + y.toString()+ ")");
    double ptsAtZone =
        myAnalyzer.calcPtsAtZoneMapDisplay(x.toDouble(), y.toDouble());
    if (ptsAtZone == 0) {
      return Colors.transparent;
    }

    double multiple = 0;
    for (double i = ptsAtZone; i > 0; i -= Constants.shadingPointDifference) {
      multiple++;
    }

    double value = Constants.colorIncrement * multiple;
    if (value > 0) {
      debugPrint("value: " + value.toString());
    }
    return Colors.green[value.toInt()].withOpacity(0.75);
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
    //Widget buttonGrid = MapAnalysisShading(myAnalyzer);
    //Widget buttonGrid = MapAnalysisShading();

    /*
    var container = null;
    //return new GridView.count(
    GridView.count(
      crossAxisCount: Constants.zoneColumns,
      children:
          List.generate(Constants.zoneRows * Constants.zoneColumns, (index) {
        //var container = Container(
        //container = Container(
        container = Container(
          margin: const EdgeInsets.all(0.5),
          //color: _getColor(index, myAnalyzer),
          //color: _getColor(index),
          color: Colors.green[600],
          width: 48.0,
          height: 48.0,
          //'Item $index',
          //style: Theme.of(context).textTheme.headline2,
        );
        return Center(child: container);
      }),
    );
*/
    ZoneGrid grid = ZoneGrid(GlobalKey(), (int x, int y) {},
        (int x, int y, bool isSelected, double cellWidth, double cellHeight) {
      return Container(
        width: cellWidth,
        height: cellHeight,
        //decoration: BoxDecoration(color: Colors.green[600]),
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
              //shading,
              //buttonGrid,
              //container,
              myAnalyzer,
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
