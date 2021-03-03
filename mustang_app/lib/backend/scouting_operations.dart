import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mustang_app/backend/match.dart';
import 'package:mustang_app/backend/team.dart';

class ScoutingOperations {
  static FirebaseFirestore _db = FirebaseFirestore.instance;
  static final String _year = DateTime.now().year.toString();
  static final CollectionReference _teamsRef =
      _db.collection(_year).doc('info').collection('teams');
  static Future<void> setTeamData(Team team) async {
    await _teamsRef.doc(team.teamNumber).set(team.toJson());
  }

  static Future<void> setMatchData(Match match) async {
    await _teamsRef
        .doc(match.teamNumber)
        .collection('matches')
        .doc(match.matchNumber)
        .set(match.toJson());
  }

  static Future<bool> doesTeamDataExist(String teamNumber) async {
    DocumentSnapshot snap = await _teamsRef.doc(teamNumber).get();
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
        .doc(teamNumber)
        .collection('matches')
        .doc(matchNumber)
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
