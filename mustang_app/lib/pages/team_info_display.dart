import 'package:flutter/material.dart';
import 'package:mustang_app/backend/match.dart';
import 'package:mustang_app/backend/team.dart';
import 'package:mustang_app/backend/team_service.dart';
import 'package:mustang_app/components/bottom_nav_bar.dart';
import '../components/header.dart';

//TODO: IMPLEMENT THIS CLASS WITH PROVIDER
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
  TeamService _teamService;

  _TeamInfoDisplayState(String teamNumber) {
    _teamNumber = teamNumber;
    _teamService = TeamService();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: Header(context, _teamNumber),
      body: Column(children: [
        StreamBuilder<Team>(
          stream: _teamService.streamTeam(_teamNumber),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container();
            }
            return Container();
          },
        ),
        StreamBuilder<List<Match>>(
            stream: _teamService.streamMatches(_teamNumber),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container();
              }
              return Container();
            })
      ]),
      bottomNavigationBar: BottomNavBar(context),
    );
  }
}
