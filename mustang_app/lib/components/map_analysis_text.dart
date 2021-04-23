import 'package:flutter/material.dart';
import 'package:mustang_app/components/analyzer.dart';

// ignore: must_be_immutable
class MapAnalysisText extends StatefulWidget {
  Analyzer _analyzer;
  MapAnalysisText(Analyzer analyzer) {
    _analyzer = analyzer;
  }
  @override
  State<StatefulWidget> createState() {
    return new _MapAnalysisTextState(_analyzer);
  }
}

class _MapAnalysisTextState extends State<MapAnalysisText> {
  Analyzer myAnalyzer;

  _MapAnalysisTextState(Analyzer analyzer) {
    myAnalyzer = analyzer;
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(myAnalyzer.getReport(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          height: 4,

                          // background: Paint()
                          //   ..strokeWidth = 30.0
                          //   ..color = Colors.green[300]
                          //   ..style = PaintingStyle.stroke
                          //   //..strokeJoin = StrokeJoin.bevel,
                        ))
                  ],
                )),
          ]),
    );
  }
}
