import 'package:flutter/material.dart';
import 'package:mustang_app/models/team.dart';
import 'package:mustang_app/models/match.dart';
import 'package:mustang_app/services/keivna_analyzer.dart';
import 'package:mustang_app/services/team_service.dart';
import 'package:mustang_app/components/shared/screen.dart';
import 'package:mustang_app/components/analysis/data_display_text.dart';
import 'package:provider/provider.dart';
import '../../services/analyzer.dart';

// ignore: must_be_immutable
class AllDataDisplay extends StatelessWidget {
  static const String route = '/AllDataDisplay';
  String _teamNumber = '';

  AllDataDisplay({String teamNumber}) {
    print('teamnumber: $teamNumber');
    _teamNumber = teamNumber;
    // _teamNumber = "519";
  }
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Team>.value(
      initialData: null,
      value: TeamService.streamTeam(_teamNumber),
      child: StreamProvider<List<Match>>.value(
        value: TeamService.streamMatches(_teamNumber),
        initialData: [],
        child: AllDataDisplayPage(
          teamNumber: _teamNumber,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AllDataDisplayPage extends StatefulWidget {
  String _teamNumber = '';
  // List<Match> _matches;

  AllDataDisplayPage({String teamNumber}) {
    // AllDataDisplayPage({String teamNumber, List<Match> matches}) {
    _teamNumber = teamNumber;
    // _matches = matches;
  }

  @override
  State<StatefulWidget> createState() {
    // return new _AllDataDisplayState(_teamNumber, _matches);
    return new _AllDataDisplayState(_teamNumber);
  }
}

class _AllDataDisplayState extends State<AllDataDisplayPage> {
  // String _teamNumber = '';
  // List<Match> _THEmatches;
  _AllDataDisplayState(String teamNumber) {
    // _AllDataDisplayState(String teamNumber, THEmatches){
    // _teamNumber = teamNumber;
    // _THEmatches = THEmatches;
  }

  @override
  Widget build(BuildContext context) {
    Team team = Provider.of<Team>(context);
    // List<Match> matches = Provider.of<List<Match>>(context);
    List<Match> matches = Provider.of<List<Match>>(context);

    return Screen(
      title: 'All Data for team: ' + (team != null ? team.teamNumber : ""),
      includeBottomNav: false,
      child: Container(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
              // children: <Widget>[DataDisplayText()],
              children: [
                Text("total number of matches: " +
                    KeivnaAnalyzer.getTotalNumMatches(matches).toString())
                // KeivnaAnalyzer.getTotalNumMatches(_THEmatches).toString())
              ]),
        ),
      ),
    );
  }
}
