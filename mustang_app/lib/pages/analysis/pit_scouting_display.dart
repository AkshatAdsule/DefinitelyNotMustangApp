import 'package:flutter/material.dart';
import 'package:mustang_app/components/components.dart';
import 'package:mustang_app/models/team.dart';
import 'package:mustang_app/utils/get_statistics.dart';
import 'package:provider/provider.dart';

import 'package:mustang_app/models/match.dart';

import 'package:mustang_app/services/team_service.dart';
import 'package:mustang_app/components/shared/screen.dart';
import '../../services/team_service.dart';

class PitScoutingDisplay extends StatelessWidget {
  static const String route = '/PitScoutingDisplay';
  String _teamNumber = '';

  PitScoutingDisplay({String teamNumber}) {
    //print("ran the PitScoutingDisplay constructor");
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
    //print("PSDP initializing");
    _teamNumber = teamNumber;
  }

  @override
  _PitScoutingDisplayPageState createState() => _PitScoutingDisplayPageState(_teamNumber);
}

class _PitScoutingDisplayPageState extends State<PitScoutingDisplayPage> {
  String teamNumber;
  GetStatistics getStatistics = GetStatistics.getInstance();
  Team pitScoutTeam;
  bool gettingData = true;
  _PitScoutingDisplayPageState(this.teamNumber) {

  }
  
  void _onInit() async {
    //print("pit scout team: " + pitScoutTeam.toString());
    //print(teamNumber);
    try {
      pitScoutTeam = await getStatistics.getPitScoutingData(teamNumber);
    } catch (e) {
      
    }
    setState(() {
      gettingData = false;
    });
    print("pit scout team: " + pitScoutTeam.toString());
  }

  @override
  void initState() {
    super.initState();
    this._onInit();
  }
  
  List<String> getShootingCapability() {
    List<String> shootingCapability = [];
    if (pitScoutTeam.bottomPort != null && pitScoutTeam.bottomPort) {
      shootingCapability.add("bottom");
    }
    if (pitScoutTeam.innerPort != null && pitScoutTeam.innerPort) {
      shootingCapability.add("inner");
    }
    if (pitScoutTeam.outerPort != null && pitScoutTeam.outerPort) {
      shootingCapability.add("outer");
    }

    return shootingCapability;
  }

  List<String> getClimbCapability() {
    List<String> climbCapability = [];
    if (pitScoutTeam.hasClimber != null && pitScoutTeam.hasClimber) {
      climbCapability.add("climber");
    }
    if (pitScoutTeam.hasLeveller != null && pitScoutTeam.hasLeveller) {
      climbCapability.add("leveller");
    }
    return climbCapability;
  }

  @override
  Widget build(BuildContext context) {
    print("on pit scouting display page");
    if (!gettingData) {
      return Screen(
          title: "Pit Scouting Data",
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text("Drivebase: " + pitScoutTeam.drivebaseType.toString(), style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Text("Auton can start from: ", style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Text("Shooting capability: " + getShootingCapability().toString(), style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Text("# of balls that the robot can hold: ",
                    style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Text("Climb capability: " + getClimbCapability().toString(), style: TextStyle(fontSize: 20)),
                SizedBox(height: 10),
                Text("Additional comments: " + pitScoutTeam.notes, style: TextStyle(fontSize: 20))
              ]
            ),
          ));
    } else {
      return Screen(
        title: "Pit Scouting Data"
      );
    }
  }
}
