import 'package:flutter/material.dart';
import 'package:mustang_app/components/analyzer.dart';
import 'package:mustang_app/constants/constants.dart';

// ignore: must_be_immutable
class MapAnalysisShading extends StatefulWidget {
  static const String route = './MapAnalysisShading';
  Analyzer _myAnalyzer;
  MapAnalysisShading({Analyzer myAnalyzer
  }){
    _myAnalyzer = myAnalyzer;
  }

  @override
  _MapAnalysisShadingState createState() => _MapAnalysisShadingState(
      myAnalyzer: _myAnalyzer);
}
/*
  @override
  State<StatefulWidget> createState() {
    return new _MapAnalysisShadingState();
  }
  */


class _MapAnalysisShadingState extends State<MapAnalysisShading> {
  Analyzer _myAnalyzer;
_MapAnalysisShadingState({Analyzer myAnalyzer}){
    _myAnalyzer = myAnalyzer;
}

Color _getColor(int zoneNum){
  debugPrint("GET COLOR WAS CALLED");
  debugPrint("index: " + zoneNum.toString());
    if (zoneNum == 2){
      return Colors.transparent;
    }
    return Colors.blue[600];
  }

  @override
  Widget build(BuildContext context) {
    //final title = 'Analysis';

    //return MaterialApp(
      //title: title,
      //home: Scaffold(
        //appBar: AppBar(
          //title: Text(title),
        //),
         return new GridView.count(
          crossAxisCount: Constants.zoneColumns,
          //children: List.generate(Constants.zoneRows*Constants.zoneColumns, (index) {
           children: List.generate(128, (index) {

            var container = Container(
                margin: const EdgeInsets.all(0.5),
                color: _getColor(index),
                width: 48.0,
                height: 48.0,
                //'Item $index',
                //style: Theme.of(context).textTheme.headline2,
              );
            return Center(
              child: container,
            );
          }),
        );  
      //);
    //);
  } 
}