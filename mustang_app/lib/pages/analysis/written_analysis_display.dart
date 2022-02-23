import 'package:flutter/material.dart';
import 'package:mustang_app/models/team.dart';
import 'package:mustang_app/models/match.dart';
import 'package:mustang_app/services/keivna_data_analyzer.dart';
import 'package:mustang_app/services/team_service.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class WrittenAnalysisDisplay extends StatelessWidget {
  static const String route = '/WrittenAnalysisDisplay';
  //remove team num
  String _teamNumber = '';
  WrittenAnalysisDisplay({String teamNumber}) {
    _teamNumber = teamNumber;
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Team>.value(
      initialData: null,
      value: TeamService.streamTeam(_teamNumber),
      child: StreamProvider<List<Match>>.value(
        value: TeamService.streamMatches(_teamNumber),
        initialData: [],
        child: WrittenAnalysisDisplayPage(
          teamNumber: _teamNumber,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class WrittenAnalysisDisplayPage extends StatefulWidget {
  String _teamNumber = '';
  WrittenAnalysisDisplayPage({String teamNumber}) {
    _teamNumber = teamNumber;
  }

  @override
  State<StatefulWidget> createState() {
    return new _WrittenAnalysisDisplayState(_teamNumber);
  }
}

class _WrittenAnalysisDisplayState extends State<WrittenAnalysisDisplayPage> {
  _WrittenAnalysisDisplayState(String teamNumber) {}

  @override
  Widget build(BuildContext context) {
    Team team = Provider.of<Team>(context);
    List<Match> matches = Provider.of<List<Match>>(context);

    return Screen(
      title:
          'Written Analysis for Team ' + (team != null ? team.teamNumber : ""),
      includeBottomNav: false,
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  child: Text(KeivnaDataAnalyzer.getWrittenAnalysis(matches),
                      style: TextStyle(fontSize: 20, height: 1.5)),
                  padding: EdgeInsets.all(15))
            ],
          ),
        ),
      ),
    );
  }
}
