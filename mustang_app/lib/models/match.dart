import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import './game_action.dart';

class Match {
  String matchNumber, teamNumber, allianceColor, notes;
  MatchResult matchResult;
  List<GameAction> actions;
  bool offenseOnRightSide;
  double driverSkill;
  MatchType matchType;
  String eventCode;

  Match({
    @required this.matchNumber,
    @required this.teamNumber,
    @required this.allianceColor,
    @required this.offenseOnRightSide,
    @required this.matchResult,
    this.notes = "",
    @required this.driverSkill,
    @required this.actions,
    @required this.matchType,
    this.eventCode = 'testing',
  });

  factory Match.fromJson(Map<String, dynamic> data) {
    return Match(
      matchNumber: data['matchNumber'] ?? '',
      teamNumber: data['teamNumber'] ?? '',
      allianceColor: data['allianceColor'] ?? 'blue',
      offenseOnRightSide: data['offenseOnRightSide'] ?? false,
      matchResult: matchResultFromString(data['matchResult']),
      notes: data['finalComments'] ?? '',
      driverSkill: data['driverSkill'] ?? 0,
      actions: data['actions'] != null
          ? data['actions']
              .map((action) => GameAction.fromJson(action))
              .toList()
          : [],
      matchType: data['matchType'] != null
          ? matchTypeFromString(data['matchType'].toString())
          : MatchType.QM,
      eventCode: data['eventCode'] ?? 'testing',
    );
  }

  factory Match.fromSnapshot(DocumentSnapshot snapshot) {
    if (!snapshot.exists) {
      return null;
    }
    Map<String, dynamic> data = snapshot.data();
    data['matchNumber'] = snapshot.id;
    return Match.fromJson(data);
  }
  static MatchType matchTypeFromString(String matchType) {
    MatchType.values.forEach((element) {
      if (describeEnum(element) == matchType) {
        return element;
      }
    });
    return MatchType.QM;
  }

  static MatchResult matchResultFromString(String matchResult) {
    MatchResult.values.forEach((element) {
      if (describeEnum(element) == matchResult) {
        return element;
      }
    });
    return MatchResult.LOSE;
  }

  Map<String, dynamic> toJson() {
    return {
      'teamNumber': teamNumber,
      'matchNumber': matchNumber,
      'finalComments': notes,
      'allianceColor': allianceColor,
      'offenseOnRightSide': offenseOnRightSide,
      'matchResult': describeEnum(matchResult),
      'actions': actions.map((e) => e.toJson()).toList(),
      'eventCode': eventCode,
      'matchType': describeEnum(matchType),
    };
  }

  String get matchKey =>
      matchNumber + '-' + describeEnum(matchType).toLowerCase();
}

// TODO: change the value to be lower case when adding it to the match name
enum MatchType {
  QM, //qualifier
  QF, //quarter final
  SF, //semi final
  F, // final
  TYPE, // for drop downs
}

enum MatchResult { WIN, LOSE, TIE }
