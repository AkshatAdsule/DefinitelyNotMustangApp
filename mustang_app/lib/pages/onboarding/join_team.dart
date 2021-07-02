import 'package:flutter/material.dart';

class JoinTeam extends StatefulWidget {
  static const String route = '/jointeam';
  final String teamNumber;
  JoinTeam({Key key, this.teamNumber = ""}) : super(key: key);

  @override
  _JoinTeamState createState() => _JoinTeamState(teamNumber: teamNumber);
}

class _JoinTeamState extends State<JoinTeam> {
  String teamNumber;
  _JoinTeamState({this.teamNumber});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
