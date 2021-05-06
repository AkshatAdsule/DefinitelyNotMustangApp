import 'package:flutter/material.dart';
import 'package:mustang_app/backend/team.dart';
import 'package:mustang_app/backend/match.dart';
import 'package:mustang_app/backend/team_service.dart';
import 'package:mustang_app/components/map_analysis_text.dart';
import 'package:mustang_app/components/screen.dart';
import 'package:provider/provider.dart';
import '../components/analyzer.dart';

// ignore: must_be_immutable
class WrittenAnalysisDisplay extends StatelessWidget {
  TeamService _teamService = TeamService();
  static const String route = '/WrittenAnalysisDisplay';
  //remove team num
  String _teamNumber = '';
  Analyzer _analyzer;
  WrittenAnalysisDisplay({Analyzer analyzer, String teamNumber}) {
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
        child: WrittenAnalysisDisplayPage(
          analyzer: _analyzer,
          teamNumber: _teamNumber,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class WrittenAnalysisDisplayPage extends StatefulWidget {
  String _teamNumber = '';
    Analyzer _analyzer;

  WrittenAnalysisDisplayPage({  Analyzer analyzer, String teamNumber}) {
    _analyzer = analyzer;
    _teamNumber = teamNumber;
  }

  @override
  State<StatefulWidget> createState() {
    return new _WrittenAnalysisDisplayState(_analyzer, _teamNumber);
  }
}

class _WrittenAnalysisDisplayState extends State<WrittenAnalysisDisplayPage> {
  Analyzer _analyzer;

  _WrittenAnalysisDisplayState(Analyzer analyzer, String teamNumber) {
    _analyzer = analyzer;
  }
  
  @override
  Widget build(BuildContext context) {
    if (!_analyzer.initialized) {
      //myAnalyzer.init().then((value) => setState(() {}));
    }

    return Screen(
      title: 'Written Analysis for Team ' + _analyzer.teamNum,
      includeBottomNav: false,
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[MapAnalysisText(_analyzer)],
          ),
        ),
      ),
    );
  }
}
