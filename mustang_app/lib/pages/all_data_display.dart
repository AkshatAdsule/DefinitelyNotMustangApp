import 'package:flutter/material.dart';
import 'package:mustang_app/backend/team.dart';
import 'package:mustang_app/backend/match.dart';
import 'package:mustang_app/backend/team_service.dart';
import 'package:mustang_app/components/screen.dart';
import 'package:mustang_app/components/data_display_text.dart';
import 'package:provider/provider.dart';
import '../components/analyzer.dart';

// ignore: must_be_immutable
class AllDataDisplay extends StatelessWidget {
  TeamService _teamService = TeamService();
  static const String route = '/AllDataDisplay';
  //remove team num
  String _teamNumber = '';
  Analyzer _analyzer;
  AllDataDisplay({Analyzer analyzer, String teamNumber}) {
    _analyzer = analyzer;
    _teamNumber = teamNumber;
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Team>.value(
      initialData: null,
      value: _teamService.streamTeam(_teamNumber),
      child: StreamProvider<List<Match>>.value(
        value: _teamService.streamMatches(_teamNumber),
        initialData: [],
        child: AllDataDisplayPage(
          analyzer: _analyzer,
          teamNumber: _teamNumber,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AllDataDisplayPage extends StatefulWidget {
  String _teamNumber = '';
  Analyzer _analyzer;

  AllDataDisplayPage({Analyzer analyzer, String teamNumber}) {
        _analyzer = analyzer;

    _teamNumber = teamNumber;
  }

  @override
  State<StatefulWidget> createState() {
    return new _AllDataDisplayState(_analyzer, _teamNumber);
  }
}

class _AllDataDisplayState extends State<AllDataDisplayPage> {
  Analyzer myAnalyzer;

  _AllDataDisplayState(Analyzer analyzer, String teamNumber) {
    //TODO: here is why everything is null!! fix this!!
    myAnalyzer = new Analyzer();
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

    return Screen(
      title: 'All Data for team: ' + myAnalyzer.teamNum.toString(),
      includeBottomNav: false,
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[DataDisplayText(myAnalyzer)],
          ),
        ),
      ),
    );
  }
}
