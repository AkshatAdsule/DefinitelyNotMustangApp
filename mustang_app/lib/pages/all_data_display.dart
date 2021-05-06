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
  String _teamNumber = '';

  AllDataDisplay({String teamNumber}) {
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
          teamNumber: _teamNumber,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AllDataDisplayPage extends StatefulWidget {
  String _teamNumber = '';

  AllDataDisplayPage({String teamNumber}) {
    _teamNumber = teamNumber;
  }

  @override
  State<StatefulWidget> createState() {
    return new _AllDataDisplayState(_teamNumber);
  }
}

class _AllDataDisplayState extends State<AllDataDisplayPage> {
  _AllDataDisplayState(String teamNumber);

  @override
  Widget build(BuildContext context) {
    Team team = Provider.of<Team>(context);

    return Screen(
      title: 'All Data for team: ' + (team != null ? team.teamNumber : ""),
      includeBottomNav: false,
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[DataDisplayText()],
          ),
        ),
      ),
    );
  }
}
