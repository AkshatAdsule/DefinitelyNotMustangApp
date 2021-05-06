import 'package:flutter/material.dart';
import 'package:mustang_app/backend/match.dart';
import 'package:mustang_app/components/all_data_display_per_match.dart';
import 'package:mustang_app/components/analyzer.dart';
import 'package:provider/provider.dart';

class DataDisplayText extends StatefulWidget {
  Analyzer _analyzer;
  DataDisplayText(Analyzer analyzer) {
    _analyzer = analyzer;
  }
  @override
  State<StatefulWidget> createState() {
    return new _DataDisplayTextState(_analyzer);
  }
}

class _DataDisplayTextState extends State<DataDisplayText> {
  Analyzer myAnalyzer;
  bool _initialized = false;

  _DataDisplayTextState(Analyzer analyzer) {
    myAnalyzer = analyzer;
  }

  void init(Match match) {
    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Match> matches = Provider.of<List<Match>>(context);
    if (!_initialized && matches.length > 0) {
      init(matches.first);
    }

    Widget getRow(int i) {
      String matchNum = matches[i].matchNumber;

      return GestureDetector(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            color: Colors.green[i * 100],
            elevation: 10,
            child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.all(10.0),
                title: Text(
                  matchNum,
                  style: TextStyle(letterSpacing: 3.0),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: 40,
                  color: Colors.green[900],
                ),
              ),
            ]),
          ),

          onTap: () {
            Navigator.pushNamed(context, AllDataDisplayPerMatch.route,
                arguments: {
                  'teamNumber': myAnalyzer.teamNum,
                  'matchNum' : matchNum,
                });
          });
    }

    return new Container(
      height: 500,
      child: new ListView.builder(
          itemCount: matches.length,
          itemBuilder: (BuildContext context, int position) {
            return getRow(position);
          }),
    );

    //List<String> matches = myAnalyzer.getMatches();
    // return new Container(
    //   height: 500,
    //     child: new ListView(

    //     children: <Widget>[
    //         ListTile(
    //         // leading: CircleAvatar(
    //         //   backgroundImage: NetworkImage(horseUrl),
    //         // ),
    //         title: Text('Match length' + matches.length.toString()),
    //         //subtitle: Text('hi'),
    //         trailing: Icon(Icons.keyboard_arrow_right),
    //         onTap: () {
    //           //print('match 1');
    //         },
    //         //selected: true,
    //       ),

    //     ],
    // ),
    //   );
  }
}
