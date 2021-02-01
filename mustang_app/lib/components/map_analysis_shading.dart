import 'package:flutter/material.dart';
import 'package:mustang_app/constants/constants.dart';

class MapAnalysisShading extends StatefulWidget {
  static const String route = './MapAnalysisShading';

  @override
  State<StatefulWidget> createState() {
    return new _MapAnalysisShadingState();
  }
}

class _MapAnalysisShadingState extends State<MapAnalysisShading> {

  Color _getColor(int zoneNum){
    if (zoneNum == 2){
      return Colors.pink[600];
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
          children: List.generate(Constants.zoneRows*Constants.zoneColumns, (index) {
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
