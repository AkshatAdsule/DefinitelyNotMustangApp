import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mustang_app/models/pitscouting_data.dart';
import 'package:mustang_app/models/team.dart';
import 'package:mustang_app/models/match.dart';
import 'package:mustang_app/models/user.dart';
import 'package:mustang_app/services/data_service.dart';
import 'package:mustang_app/services/scouting_operations.dart';

class TeamService {
  static FirebaseFirestore _db = FirebaseFirestore.instance;
  static final String _year = DateTime.now().year.toString();
  String _teamNumber;
  DocumentReference _teamRef;
  static final CollectionReference _teamsRef =
      _db.collection(_year).doc('info').collection('teams');

  TeamService(this._teamNumber) {
    _teamRef = _teamsRef.doc(_teamNumber);
  }

  static Future<Team> getTeam(String teamNumber) async {
    return Team.fromSnapshot(await _db
        .collection(_year)
        .doc('info')
        .collection('teams')
        .doc(teamNumber)
        .get());
  }

  static Stream<List<Team>> streamTeams() {
    // TODO: CHANGE "2021" TO _year !!!
    CollectionReference ref =
        _db.collection("2022").doc('info').collection('teams');

    return ref
        .snapshots()
        .map((list) => list.docs.map((doc) => Team.fromSnapshot(doc)).toList());
  }

  static Future<List<Match>> getMatches(String teamNumber) async {
    QuerySnapshot matchData = await _db
        .collection(_year)
        .doc('info')
        .collection('teams')
        .doc(teamNumber)
        .collection('matches')
        .get();
    return matchData.docs.map((e) => Match.fromSnapshot(e)).toList();
  }

  static Stream<Team> streamTeam(String teamNumber) {
    return _db
        .collection(_year)
        .doc('info')
        .collection('teams')
        .doc(teamNumber)
        .snapshots()
        .map((snap) => Team.fromSnapshot(snap));
  }

  static Stream<List<Match>> streamMatches(String teamNumber) {
    CollectionReference ref = _db
        .collection(_year)
        .doc('info')
        .collection('teams')
        .doc(teamNumber)
        .collection('matches');

    return ref.snapshots().map(
        (list) => list.docs.map((doc) => Match.fromSnapshot(doc)).toList());
  }

  static Future<void> createTeam(PitScoutingData data) async {
    bool exists = await ScoutingOperations.doesTeamDataExist(data.teamNumber);
    if (!exists) {
      // await _teamsRef.doc(team.teamNumber).set(team.toJson());
      DataService.getInstance().tryUploadDoc(
          path: _teamsRef.path + team.teamNumber, data: team.toJson());
    } else {
      throw new Exception('A team with this number already exists');
    }
  }

  Future<void> addMember(UserModel user) async {
    _db.collection('users').doc(user.uid).update({
      'teamStatus': describeEnum(TeamStatus.JOINED),
      'teamNumber': _teamNumber,
    });
  }

  Stream<List<UserModel>> getJoinRequests() {
    return _db
        .collection('users')
        .where('teamNumber', isEqualTo: _teamNumber)
        .where('teamStatus',
            isEqualTo: describeEnum(TeamStatus.PENDINGAPPROVAL))
        .snapshots()
        .map((event) =>
            event.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }
}
