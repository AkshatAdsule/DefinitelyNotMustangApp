import 'package:flutter/material.dart';
import 'package:mustang_app/backend/team.dart';
import 'package:mustang_app/backend/match.dart';
import 'package:mustang_app/backend/team_service.dart';
import 'package:mustang_app/components/screen.dart';
import 'package:provider/provider.dart';
import '../components/analyzer.dart';

// ignore: must_be_immutable
class AllDataDisplayPerMatch extends StatelessWidget {
  TeamService _teamService = TeamService();
  static const String route = '/AllDataDisplayPerMatch';
  String _teamNumber = '';
  String _matchNum = '';

  AllDataDisplayPerMatch({String teamNumber, String matchNum}) {
    _teamNumber = teamNumber;
    _matchNum = matchNum;
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Team>.value(
      initialData: null,
      value: _teamService.streamTeam(_teamNumber),
      child: StreamProvider<List<Match>>.value(
        value: _teamService.streamMatches(_teamNumber),
        initialData: [],
        child: AllDataDisplayPerMatchPage(
          teamNumber: _teamNumber,
          matchNum: _matchNum,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AllDataDisplayPerMatchPage extends StatefulWidget {
  String _teamNumber = '', _matchNum = '';
  AllDataDisplayPerMatchPage({String teamNumber, String matchNum}) {
    _teamNumber = teamNumber;
    _matchNum = matchNum;
  }

  @override
  State<StatefulWidget> createState() {
    return new _AllDataDisplayPerMatchState(_teamNumber, _matchNum);
  }
}

class _AllDataDisplayPerMatchState extends State<AllDataDisplayPerMatchPage> {
  Analyzer myAnalyzer;
  String _matchNum = '';

  _AllDataDisplayPerMatchState(String teamNumber, String matchNum) {
    myAnalyzer = new Analyzer(teamNumber);
    _matchNum = matchNum;
  }
  
  @override
  Widget build(BuildContext context) {
    if (!myAnalyzer.initialized) {
      myAnalyzer.init().then((value) => setState(() {}));
    }

    Widget dataForMatch = Container(
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
                    Text(
                      "hey",
                      //myAnalyzer.getReport(),
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

    return Screen(
      title: 'All Data for Team: ' + myAnalyzer.teamNum + " - Match: " + _matchNum,
      includeBottomNav: false,
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //MapAnalysisText(myAnalyzer)
              dataForMatch
              ],
          ),
        ),
      ),
    );
  }
}
