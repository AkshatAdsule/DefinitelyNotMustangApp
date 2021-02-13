import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustang_app/backend/game_action.dart';
import 'package:mustang_app/backend/match.dart';
import 'package:mustang_app/backend/team.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseOperations {
  static bool _initialized = false;
  static List<String> _teamNumbers = [];
  static String _year;
  static List<Team> _teams = [];
  static List<Match> _matches = [];
  static Firestore _db = Firestore.instance;
  static StreamSubscription<QuerySnapshot> _teamListener, _matchListener;

  static Future<void> init() async {
    _year = DateTime.now().year.toString();
    List<DocumentSnapshot> teamDocs =
        (await _db.collection('teams-$_year').getDocuments()).documents;
    List<DocumentSnapshot> matchDocs = (await _db
            .collectionGroup('matches')
            .where('year', isEqualTo: _year)
            .getDocuments())
        .documents;

    _teams = _convertTeamsFromSnapshot(teamDocs);
    _matches = _convertMatchesFromSnapshot(matchDocs);
    _updateTeamNumbers();
    _initialized = true;

    _teamListener = _db.collection('teams-$_year').snapshots().listen((event) {
      _teams = _convertTeamsFromSnapshot(event.documents);
      _updateTeamNumbers();
    });
    _matchListener = _db
        .collectionGroup('matches')
        .where('year', isEqualTo: _year)
        .snapshots()
        .listen((event) {
      _matches = _convertMatchesFromSnapshot(event.documents);
      _updateTeamNumbers();
    });
  }

  static Future<void> tempInit() async {
    _year = DateTime.now().year.toString();
    WriteBatch batch = _db.batch();
    List<DocumentSnapshot> matchDocs =
        (await _db.collectionGroup('matches').getDocuments()).documents;
    matchDocs.forEach((element) {
      batch.updateData(element.reference, {'year': _year});
    });
    await batch.commit();
  }

  static void stopListening() {
    _teamListener.cancel();
    _matchListener.cancel();
  }

  static Future<void> refresh() async {
    _initialized = false;
    _teams = _convertTeamsFromSnapshot(
        (await _db.collection('teams-$_year').getDocuments()).documents);
    _matches = _convertMatchesFromSnapshot((await _db
            .collectionGroup('matches')
            .where('year', isEqualTo: _year)
            .getDocuments())
        .documents);
    _updateTeamNumbers();
    _initialized = true;
  }

  static bool get initialized {
    return _initialized;
  }

  static List<String> get teams {
    return _teamNumbers;
  }

  static List<String> get teamNumbers {
    return _teamNumbers;
  }

  static List<Team> get teamDocs {
    return _teams;
  }

  static List<Match> get matchDocs {
    return _matches;
  }

  static Team getTeam(String teamNumber) {
    return _teams
        .where((element) => element.teamNumber == teamNumber)
        .toList()
        .first;
  }

  static List<Match> getMatches(String teamNumber) {
    return _matches
        .where((element) => element.teamNumber == teamNumber)
        .toList();
  }

  static Match getMatch(String teamNumber, String matchNumber) {
    return _matches
        .where((element) =>
            element.teamNumber == teamNumber &&
            element.matchNumber == matchNumber)
        .toList()
        .first;
  }

  static List<GameAction> getMatchActions(
      String teamNumber, String matchNumber) {
    return _matches
        .where((match) =>
            match.teamNumber == teamNumber && match.matchNumber == matchNumber)
        .first
        .actions;
  }

  static Map<String, List<GameAction>> getAllMatchActions(String teamNumber) {
    List<Match> matches =
        _matches.where((element) => element.teamNumber == teamNumber);
    Map<String, List<GameAction>> mapActions = {};
    matches.forEach((match) {
      mapActions[match.matchNumber] = match.actions;
    });
    return mapActions;
  }

  static void _updateTeamNumbers() {
    List<String> numbers = [];
    _teams.forEach((team) {
      numbers.add(team.teamNumber);
    });
    _teamNumbers = numbers;
  }

  static Future<void> setTeamData(Team team) async {
    await _db
        .collection('teams-$_year')
        .document(team.teamNumber)
        .updateData(team.toJson());
  }

  static List<Team> _convertTeamsFromSnapshot(List<DocumentSnapshot> snaps) {
    return snaps.map((e) => Team.fromSnapshot(e)).toList();
  }

  static List<Match> _convertMatchesFromSnapshot(List<DocumentSnapshot> snaps) {
    return snaps.map((e) => Match.fromSnapshot(e)).toList();
  }

  static Future<void> setMatchData(Match match) async {
    await _db
        .collection('teams-$_year')
        .document(match.teamNumber)
        .collection('matches')
        .document(match.matchNumber)
        .setData(match.toJson());
  }

  static bool doesTeamDataExist(String teamNumber) {
    Team team = _teams.where((team) => team.teamNumber == teamNumber).first;

    if (team == null) {
      return false;
    } else if (team.teamNumber == "") {
      return false;
    } else {
      return true;
    }
  }

  static bool doesMatchDataExist(String teamNumber, String matchNumber) {
    Match match = _matches
        .where((match) =>
            match.teamNumber == teamNumber && match.matchNumber == matchNumber)
        .first;
    if (match == null) {
      return false;
    } else if (match.matchNumber == "") {
      return false;
    } else {
      return true;
    }
  }

  static Future<StorageTaskSnapshot> exportDB() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/_db.json');

    Map<String, Map<String, dynamic>> data = {};
    final Firestore _db = Firestore.instance;
    StorageReference ref = FirebaseStorage.instance.ref().child('_db.json');
    QuerySnapshot teams = await _db.collection('teams-$_year').getDocuments();
    teams.documents.forEach((doc) async {
      data[doc.documentID] = {};
      data[doc.documentID]['Match Scouting'] =
          new Map<String, Map<String, dynamic>>();
      data[doc.documentID].addAll(doc.data);
      QuerySnapshot matches =
          await doc.reference.collection('Match Scouting').getDocuments();
      matches.documents.forEach((match) {
        data[doc.documentID]['Match Scouting'][match.documentID] = match.data;
      });
    });

    File updated = await file.writeAsString(jsonEncode(data));
    return ref.putFile(updated).onComplete;
  }

  // static Future<void> importDB() async { }
}
