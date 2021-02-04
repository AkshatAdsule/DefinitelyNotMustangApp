import 'package:flutter/material.dart';
import 'package:mustang_app/components/header.dart';
import 'package:mustang_app/components/map_analysis_shading.dart';
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
  SymbolPlotter plotter;
  MapAnalysisShading shading;

  _MapAnalysisDisplayState(String teamNumber) {
    myAnalyzer = new Analyzer(teamNumber);
    _teamNumber = teamNumber;
    plotter = new SymbolPlotter(_getPoints());
    //shading = new MapAnalysisShading();
  }

   Color _getColor(int zoneNum){
    double y = zoneToY(zoneNum);
    double x = zoneToX(zoneNum);
    //debugPrint("zone: " + zoneNum.toString() + " ptsAtZone: " + myAnalyzer.calcPtsAtZoneMapDisplay(x, y).toString() + ", (" + x.toString() + ", " + y.toString()+ ")");

    double ptsAtZone = myAnalyzer.calcPtsAtZoneMapDisplay(x, y);
    double increment = 600/Constants.shadingPointDifference;

    double multiple = 0;
    for (double i = ptsAtZone; i > 0; i-= Constants.shadingPointDifference){
      multiple ++;
    }
    if (multiple > 0){
      debugPrint("multiple: " + multiple.toString() + " zone: " + zoneNum.toString() + " ptsAtZone: " + myAnalyzer.calcPtsAtZoneMapDisplay(x, y).toString() + ", (" + x.toString() + ", " + y.toString()+ ")");

    }
    /*
    if (ptsAtZone == 0){
      return Colors.transparent;
    }
    else if (ptsAtZone < 3){
      return Colors.green[300];
    }
    else{
      return Colors.green[600];
    }
*/
    double value = increment*multiple;
    if (value > 0){
    debugPrint("value: " + value.toString());

    }
    return Colors.green[value.toInt()];

    
  }
  //zones start at 0, see miro but climb up, no sense of columns or row so need to convert
  double zoneToX(int zone){
    return zone - (zoneToY(zone)*Constants.zoneColumns);
  }
  double zoneToY(int zone){
    double y = 0;
    while (zone >= Constants.zoneColumns){
      zone-=Constants.zoneColumns;
      y++;
    }
    return y;
  }

  List<PlotPoint> _getPoints() {
    List<PlotPoint> points = new List<PlotPoint>();
    if (TeamDataAnalyzer.teamAverages[_teamNumber] != null &&
        TeamDataAnalyzer.getTeamDoc(_teamNumber).data['hasAnalysis']) {
      TeamDataAnalyzer.teamAverages[_teamNumber].forEach((key, value) {
        String val = value.toString();
        val = val.substring(0, 3);
        double x = 0, y = 0, shift = 0, textSize = 15;
        Color fillColor = Colors.black;
        bool isPoint = true;
        if (key.contains("autoBalls")) {
          fillColor = MapScouterKey.autoBalls;
        } else if (key.contains("teleBalls")) {
          fillColor = MapScouterKey.teleBalls;
          shift = -0.0495;
        } else if (key.contains("startingLocation")) {
          return; // Feature to be implemented in coming versions
        } else if (key.contains("autoEndLocation")) {
          return; // Feature to be implemented in coming versions
        } else {
          return;
        }
        if (key.contains("Balls")) {
          String zone = key.substring(key.indexOf("s") + 1).trim();
          // width: 800, height: 500
          switch (zone) {
            case "Low":
              x = 0.95625;
              y = 0.6649;
              textSize = 10;
              val = "Lo:" + val;
              break;
            case "1":
              x = 0.93125;
              y = 366 / 376;
              break;
            case "23":
              x = 640 / 807;
              y = 325 / 376;
              break;
            case "4":
              x = 500 / 807;
              y = 410 / 376;
              break;
            case "5":
              x = 260 / 807;
              y = 410 / 376;
              break;
            case "6":
              x = 200 / 807;
              y = 175 / 376;
              break;
            default:
              isPoint = false;
              break;
          }
        }
        if (isPoint) {
          points.add(new PlotPoint((x) + shift, (y), fillColor, val, textSize));
        }
      });
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    //Widget buttonGrid = MapAnalysisShading(myAnalyzer);
    Widget buttonGrid = MapAnalysisShading();

    
   var container = null;
    return new GridView.count(
      
    //GridView.count(

          crossAxisCount: Constants.zoneColumns,
          children: List.generate(Constants.zoneRows*Constants.zoneColumns, (index) {
            //var container = Container(
            //container = Container(
             container = Container(

                margin: const EdgeInsets.all(0.5),
                //color: _getColor(index, myAnalyzer),
                color: _getColor(index),
                width: 48.0,
                height: 48.0,
                //'Item $index',
                //style: Theme.of(context).textTheme.headline2,
              );
            return Center(
              child: container
            );
          }),
        );  

/*
    return Scaffold(
      appBar: Header(context, 'Analysis'),
      body: Container(
        // height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Image.asset('assets/croppedmap.png', fit: BoxFit.contain),
                //shading,
                buttonGrid,
                //container,
                //myAnalyzer,
                //plotter,
               //MapScouterKey()
              ],
            ),
          ),
        ),
      ),
    );

     */
    
  }
}
