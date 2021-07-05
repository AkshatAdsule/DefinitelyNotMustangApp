import 'package:flutter/material.dart';
import 'package:mustang_app/models/team.dart';
import 'package:mustang_app/models/match.dart';
import 'package:mustang_app/services/team_service.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:provider/provider.dart';
import '../../services/analyzer.dart';

class AllDataDisplayPerMatch extends StatelessWidget {
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
      value: TeamService.streamTeam(_teamNumber),
      child: StreamProvider<List<Match>>.value(
        value: TeamService.streamMatches(_teamNumber),
        initialData: [],
        child: AllDataDisplayPerMatchPage(
          teamNumber: _teamNumber,
          matchNum: _matchNum,
        ),
      ),
    );
  }
}

class AllDataDisplayPerMatchPage extends StatefulWidget {
  String _teamNumber = '', _matchNum = '';
  //Analyzer _analyzer;
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
    //TODO: FIX THIS!!!!
    myAnalyzer = new Analyzer();
    _matchNum = matchNum;
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

    Team team = Provider.of<Team>(context);
    Widget dataText = Container(
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
                    Text(myAnalyzer.getDataDisplayForMatch(_matchNum),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          height: 2,
                        ))
                  ],
                )),
          ]),
    );

    return Screen(
      title: 'Team: ' +
          (team != null ? team.teamNumber : "") +
          " - Match: " +
          _matchNum,
      includeBottomNav: false,
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[dataText],
          ),
        ),
      ),
    );
  }
}
