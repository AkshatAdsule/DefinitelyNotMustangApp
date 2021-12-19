import 'package:flutter/material.dart';
import 'package:mustang_app/components/components.dart';
import 'package:mustang_app/models/team.dart';
import 'package:provider/provider.dart';

import 'package:mustang_app/models/match.dart';

import 'package:mustang_app/services/team_service.dart';
import 'package:mustang_app/components/shared/screen.dart';
import '../../services/team_service.dart';

class PitScoutingDisplay extends StatelessWidget {
  static const String route = '/PitScoutingDisplay';
  String _teamNumber = '';

  PitScoutingDisplay({String teamNumber}) {
    print("ran the PitScoutingDisplay constructor");
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
        child: PitScoutingDisplayPage(
          teamNumber: _teamNumber,
        ),
      ),
    );
  }
}

class PitScoutingDisplayPage extends StatefulWidget {
  String _teamNumber;

  PitScoutingDisplayPage({String teamNumber}) {
    print("PSDP initializing");
    _teamNumber = teamNumber;
  }

  @override
  _PitScoutingDisplayPageState createState() => _PitScoutingDisplayPageState();
}

class _PitScoutingDisplayPageState extends State<PitScoutingDisplayPage> {
  @override
  Widget build(BuildContext context) {
    print("on pit scouting display page");
    return Screen(
        title: "Pit Scouting Data",
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Drivebase: ", style: TextStyle(fontSize: 20)),
          Text("Auton can start from: ", style: TextStyle(fontSize: 20)),
          Text("Shooting capability: ", style: TextStyle(fontSize: 20)),
          Text("# of balls that the robot can hold: ",
              style: TextStyle(fontSize: 20)),
          Text("Climb capability: ", style: TextStyle(fontSize: 20)),
          Text("Additional comments: ", style: TextStyle(fontSize: 20))
        ]));
  }
}
