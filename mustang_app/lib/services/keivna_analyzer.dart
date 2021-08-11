import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustang_app/constants/game_constants.dart';
import 'package:mustang_app/constants/robot_constants.dart';
import 'package:mustang_app/models/game_action.dart';
import 'package:mustang_app/models/match.dart';
import 'package:mustang_app/models/robot.dart';
import 'package:mustang_app/models/team.dart';
import 'package:mustang_app/services/team_service.dart';
import '../models/match.dart';
import 'keivna_data.dart';

/*
1 level above keivna_data.dart (services stuff)
takes data from keivna_data.dart and analyzes it to return analyzed values (ex: pts prevented for match x for team y)
is made up static methods that call keivna_data.dart's static methods
*/

class KeivnaAnalyzer {
//normally the analysis would be more intense, such as "getMatchWithHighestScore"
//SHOULDN'T RETURE FUTURE<INT> J INT!!!!!!!
  static Future<int> getTotalNumMatches(Team team) async {
    Future<List<Match>> matches = TeamService.getMatches(team.teamNumber);
    List<Match> matchesList = await TeamService.getMatches(team.teamNumber);

    return matchesList.length;
    // return KeivnaData.getAllMatchesForTeam(team).length;
  }

  // Future<List<Match>> toList() {
  //   List<Match> result = <Match>[];
  //   _Future<List<Match>> future = new _Future<List<Match>>();
  //   this.listen(
  //       (Matchdata) {
  //         result.add(data);
  //       },
  //       onError: future._completeError,
  //       onDone: () {
  //         future._complete(result);
  //       },
  //       cancelOnError: true);
  //   return future;
  // }
}
