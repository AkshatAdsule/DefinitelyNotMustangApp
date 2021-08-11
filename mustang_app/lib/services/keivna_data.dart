import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustang_app/constants/game_constants.dart';
import 'package:mustang_app/constants/robot_constants.dart';
import 'package:mustang_app/models/game_action.dart';
import 'package:mustang_app/models/match.dart';
import 'package:mustang_app/models/robot.dart';
import 'package:mustang_app/models/team.dart';
import '../models/match.dart';

/*
1 level above Firebase (services stuff)
takes all data from firebase and organizes it in a legible fashion
is made up of 1 FirebaseFirestore field, 
and a bunch of organized, easy to understand getters that
 - call to get the most recent data from firestore
 - return that data
*/

class KeivnaData {
  FirebaseFirestore _db; //KTODO: initialize

  static List<Match> getAllMatchesForTeam(Team team) {
    // ignore: deprecated_member_use
    List<Match> matches = new List<Match>();
    List<GameAction> gameActions = new List<GameAction>();
    gameActions.add(new GameAction(
        actionType: ActionType.INTAKE, timeStamp: 3000, x: 1, y: 1));

    matches.add(new Match(
        matchNumber: "3",
        teamNumber: "519",
        allianceColor: "Red",
        offenseOnRightSide: true,
        matchResult: MatchResult.WIN,
        driverSkill: 5.0,
        actions: gameActions,
        matchType: MatchType.QM));

    return matches;
  }
}
