import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustang_app/backend/match.dart';
import 'package:mustang_app/backend/team.dart';

class ScoutingOperations {
  static Firestore _db = Firestore.instance;
  static final String _year = DateTime.now().year.toString();
  static final CollectionReference _teamsRef =
      _db.collection(_year).document('info').collection('teams');
  static Future<void> setTeamData(Team team) async {
    await _teamsRef.document(team.teamNumber).setData(team.toJson());
  }

  static Future<void> setMatchData(Match match) async {
    await _teamsRef
        .document(match.teamNumber)
        .collection('matches')
        .document(match.matchNumber)
        .setData(match.toJson());
  }

  static Future<bool> doesTeamDataExist(String teamNumber) async {
    DocumentSnapshot snap = await _teamsRef.document(teamNumber).get();
    if (snap == null || snap.data == null) {
      return false;
    }
    Team team = Team.fromSnapshot(snap);

    if (team == null) {
      return false;
    } else if (team.teamNumber == "") {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> doesMatchDataExist(
      String teamNumber, String matchNumber) async {
    DocumentSnapshot snap = await _teamsRef
        .document(teamNumber)
        .collection('matches')
        .document(matchNumber)
        .get();
    if (snap == null || snap.data == null) {
      return false;
    }
    Match match = Match.fromSnapshot(snap);
    if (match == null) {
      return false;
    } else if (match.matchNumber == "") {
      return false;
    } else {
      return true;
    }
  }
}
