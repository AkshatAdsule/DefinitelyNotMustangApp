import 'package:flutter/material.dart';
import 'package:mustang_app/backend/database_operations.dart';
import 'package:mustang_app/backend/match.dart';
import 'package:mustang_app/backend/team.dart';
import 'package:mustang_app/components/bottom_nav_bar.dart';
import '../components/header.dart';

// ignore: must_be_immutable
class TeamInfoDisplay extends StatefulWidget {
  String _teamNumber;
  static const String route = '/TeamInfoDisplay';
  TeamInfoDisplay({String teamNumber}) {
    _teamNumber = teamNumber;
  }

  @override
  State<StatefulWidget> createState() {
    return _TeamInfoDisplayState(_teamNumber);
  }
}

class _TeamInfoDisplayState extends State<TeamInfoDisplay> {
  String _teamNumber;
  List<String> _matches = [];
  Team _team;
  List<Match> _matchData = [];

  _TeamInfoDisplayState(String team) {
    _teamNumber = team;
  }

  @override
  void initState() {
    super.initState();
    _matchData = DatabaseOperations.getMatches(_teamNumber);
    _team = DatabaseOperations.getTeam(_teamNumber);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: Header(context, _teamNumber),
      body: Container(),
      bottomNavigationBar: BottomNavBar(context),
    );
  }
}
