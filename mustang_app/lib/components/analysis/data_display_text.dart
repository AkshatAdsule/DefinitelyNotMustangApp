import 'package:flutter/material.dart';
import 'package:mustang_app/models/match.dart';
import 'package:mustang_app/models/team.dart';
import 'package:mustang_app/pages/analysis/all_data_display_per_match.dart';
import 'package:mustang_app/services/analyzer.dart';
import 'package:provider/provider.dart';

class DataDisplayText extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _DataDisplayTextState();
  }
}

class _DataDisplayTextState extends State<DataDisplayText> {
  Analyzer myAnalyzer;
  bool _initialized = false;

  _DataDisplayTextState() {
    myAnalyzer = new Analyzer();
  }

  void init(Match match) {
    setState(() {
      _initialized = true;
    });
  }

  Widget getRow(List<Match> matches, int i, BuildContext context) {
    String matchNum = matches[i].matchNumber;

    return GestureDetector(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: Colors.green[i * 100],
          elevation: 10,
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.all(10.0),
              title: Text(
                matchNum,
                style: TextStyle(
                  letterSpacing: 3.0,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
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
                'teamNumber':
                    Provider.of<Team>(context, listen: false).teamNumber,
                'matchNum': matchNum,
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    if (!myAnalyzer.initialized) {
      myAnalyzer.init(
        Provider.of<Team>(context),
        Provider.of<List<Match>>(context),
      );
      setState(() {});
    }

    List<Match> matches = Provider.of<List<Match>>(context);
    if (!_initialized && matches.length > 0) {
      init(matches.first);
    }

    return new Container(
      height: 500,
      child: new ListView.builder(
          itemCount: matches.length,
          itemBuilder: (BuildContext context, int position) {
            return getRow(matches, position, context);
          }),
    );
  }
}
