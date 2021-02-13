import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustang_app/components/game_action.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseOperations {
  static bool _initialized = false;
  static List<String> _teamNumbers = [];
  static String _year;
  static List<DocumentSnapshot> _teams = [];
  static List<DocumentSnapshot> _matches = [];
  static Firestore _db = Firestore.instance;

  static Future<void> init() async {
    _year = DateTime.now().year.toString();
    _teams = (await _db.collection('teams').getDocuments()).documents;
    _matches = (await _db.collectionGroup('matches').getDocuments()).documents;
    _updateTeamNumbers();
    _initialized = true;
    _db.collection('teams').snapshots().listen((event) {
      _teams = event.documents;
      _updateTeamNumbers();
    });
    _db.collectionGroup('matches').snapshots().listen((event) {
      _matches = event.documents;
      _updateTeamNumbers();
    });
  }

  static Future<void> refresh() async {
    _initialized = false;
    _teams = (await _db.collection('teams').getDocuments()).documents;
    _matches = (await _db.collectionGroup('matches').getDocuments()).documents;
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

  static List<DocumentSnapshot> get teamDocs {
    return _teams;
  }

  static List<DocumentSnapshot> get matchDocs {
    return _matches;
  }

  static DocumentSnapshot getTeamDoc(String teamNumber) {
    return _teams
        .where((element) => element.documentID == teamNumber)
        .toList()
        .first;
  }

  static List<DocumentSnapshot> getMatchDocs(String teamNumber) {
    return _matches
        .where((element) => element.data['teamNumber'] == teamNumber)
        .toList();
  }

  static DocumentSnapshot getMatch(String teamNumber, String matchNumber) {
    return _matches
        .where((element) =>
            element.data['teamNumber'] == teamNumber &&
            element.documentID == matchNumber)
        .toList()
        .first;
  }

  static List<GameAction> getMatchActions(
      String teamNumber, String matchNumber) {
    return _matches
        .where((match) =>
            match.data['teamNumber'] == teamNumber &&
            match.documentID == matchNumber)
        .first
        .data['actions']
        .map((action) => GameAction.fromJson(action))
        .toList();
  }

  static Map<String, List<GameAction>> getAllMatchActions(String teamNumber) {
    List<DocumentSnapshot> matches =
        _matches.where((element) => element.data['teamNumber'] == teamNumber);
    Map<String, List<GameAction>> mapActions = {};
    matches.forEach((match) {
      mapActions[match.documentID] = match.data['actions']
          .map((action) => GameAction.fromJson(action))
          .toList();
    });
    return mapActions;
  }

  static void _updateTeamNumbers() {
    List<String> numbers = [];
    _teams.forEach((team) {
      numbers.add(team.documentID);
    });
    _teamNumbers = numbers;
  }

  static Future<void> updatePitScouting(String teamNumber,
      {bool inner,
      outer,
      bottom,
      rotation,
      position,
      climb,
      leveller,
      String notes,
      drivebaseType}) async {
    await _db.collection('teams-$_year').document(teamNumber).updateData({
      'driveBaseType': drivebaseType,
      'innerPort': inner,
      'outerPort': outer,
      'bottomPort': bottom,
      'rotationControl': rotation,
      'positionControl': position,
      'climber': climb,
      'leveller': leveller,
      'notes': notes
    });
  }

  static List<Map<String, dynamic>> _convertActionsToJson(
      List<GameAction> actions) {
    return actions.map((action) => action.toJson()).toList();
  }

  static Future<void> updateMatchData(
      String teamNumber, String matchNumber, List<GameAction> actions,
      {String matchResult, String finalComments, String allianceColor}) async {
    await _db
        .collection('teams-$_year')
        .document(teamNumber)
        .collection('matches')
        .document(matchNumber)
        .setData({
      'actions': _convertActionsToJson(actions),
      'finalComments': finalComments,
      'matchResult': matchResult,
      'allianceColor': allianceColor,
      'teamNumber': teamNumber,
    });
  }

  static bool doesPitDataExist(String teamNumber) {
    DocumentSnapshot team =
        _teams.where((team) => team.documentID == teamNumber).first;

    if (team == null) {
      return false;
    } else if (team.data == null) {
      return false;
    } else {
      return true;
    }
  }

  static bool doesMatchDataExist(String teamNumber, String matchNumber) {
    DocumentSnapshot match = _matches
        .where((match) =>
            match.data['teamNumber'] == teamNumber &&
            match.documentID == matchNumber)
        .first;
    if (match == null) {
      return false;
    } else if (match.data == null) {
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
    QuerySnapshot teams = await _db.collection('teams').getDocuments();
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
