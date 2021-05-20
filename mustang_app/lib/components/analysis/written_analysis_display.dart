import 'package:flutter/material.dart';
import 'package:mustang_app/models/team.dart';
import 'package:mustang_app/models/match.dart';
import 'package:mustang_app/services/team_service.dart';
import './map_analysis_text.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:provider/provider.dart';
import 'package:mustang_app/services/analyzer.dart';

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

  WrittenAnalysisDisplayPage({Analyzer analyzer, String teamNumber}) {
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
            children: <Widget>[MapAnalysisText()],
          ),
        ),
      ),
    );
  }
}
