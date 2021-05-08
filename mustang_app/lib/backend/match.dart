import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mustang_app/backend/game_action.dart';

class Match {
  String _matchNumber, _teamNumber, _allianceColor, _matchResult, _notes;
  List<GameAction> _actions;
  bool _offenseOnRightSide;
  double _driverSkill;
  MatchType _matchType;
  String _eventCode;

  Match(
    this._matchNumber,
    this._teamNumber,
    this._allianceColor,
    this._offenseOnRightSide,
    this._matchResult,
    this._notes,
    this._driverSkill,
    this._actions,
    this._matchType,
    this._eventCode,
  );

  factory Match.fromJson(Map<String, dynamic> data) {
    return Match(
        data['matchNumber'] ?? '',
        data['teamNumber'] ?? '',
        data['allianceColor'] ?? 'blue',
        data['offenseOnRightSide'] ?? false,
        data['matchResult'] ?? 'Lose',
        data['finalComments'] ?? '',
        data['driverSkill'] ?? 0,
        data['actions'] != null
            ? data['actions']
                .map((action) => GameAction.fromJson(action))
                .toList()
            : [],
        data['matchType'] != null
            ? _matchTypeFromString(data['matchType'].toString())
            : MatchType.QM,
        data['eventCode'] ?? 'testing');
  }

  factory Match.fromSnapshot(DocumentSnapshot snapshot) {
    if (!snapshot.exists) {
      return null;
    }
    Map<String, dynamic> data = snapshot.data();
    return Match(
        snapshot.id,
        data['teamNumber'] ?? '',
        data['allianceColor'] ?? 'blue',
        data['offenseOnRightSide'] ?? false,
        data['matchResult'] ?? 'Lose',
        data['finalComments'] ?? '',
        data['driverSkill'] ?? 0,
        data['actions'] != null
            ? List<dynamic>.of(data['actions'])
                .map((e) => GameAction.fromJson(Map<String, dynamic>.from(e)))
                //Type: ActionType.OTHER_CROSSED_INITIATION_LINE; Duration: 5321.0; Location: (-1.0, -1.0)
                //Type: ActionType.INTAKE; Duration: 9565.0; Location: (3.0, 5.0)
                .toList()
            : [],
        data['matchType'] != null
            ? _matchTypeFromString(data['matchType'].toString())
            : MatchType.QM,
        data['eventCode'] ?? 'testing');
  }

  static MatchType _matchTypeFromString(String matchType) {
    for (int i = 0; i < MatchType.values.length; i++) {
      MatchType element = MatchType.values[i];
      if (matchType == element.name) {
        return element;
      }
    }
    return MatchType.QM;
  }

  Map<String, dynamic> toJson() {
    return {
      'teamNumber': _teamNumber,
      'matchNumber': _matchNumber,
      'finalComments': _notes,
      'allianceColor': _allianceColor,
      'offenseOnRightSide': _offenseOnRightSide,
      'matchResult': _matchResult,
      'actions': _actions.map((e) => e.toJson()).toList(),
      'eventCode': _eventCode,
      'matchType': _matchType.name,
    };
  }

  String get matchNumber => _matchNumber;
  String get teamNumber => _teamNumber;
  String get allianceColor => _allianceColor;
  bool get offenseOnRightSide => _offenseOnRightSide;
  String get matchResult => _matchResult;
  String get notes => _notes;
  double get driverSkill => _driverSkill;
  List<GameAction> get actions => _actions;
  String get eventCode => _eventCode;
  MatchType get matchType => _matchType;
  String get matchKey => _matchNumber + '-' + _matchType.name;

  set matchNumber(String matchNumber) => _matchNumber = matchNumber;
  set teamNumber(String teamNumber) => _teamNumber = teamNumber;
  set allianceColor(String allianceColor) => _allianceColor = allianceColor;
  set offenseOnRightSide(bool offenseOnRightSide) =>
      _offenseOnRightSide = offenseOnRightSide;
  set matchResult(String matchResult) => _matchResult = matchResult;
  set notes(String notes) => _notes = notes;
  set driverSkill(double driverSkill) => _driverSkill = driverSkill;
  set actions(List<GameAction> actions) => _actions = actions;
  set eventCode(String eventCode) => _eventCode = eventCode;
  set matchType(MatchType matchType) => _matchType = matchType;
}

// TODO: change the value to be lower case when adding it to the match name
enum MatchType {
  QM, //qualifier
  QF, //quarter final
  SF, //semi final
  F, // final
  TYPE, // for drop downs
}

extension ParseToString on MatchType {
  String get name => describeEnum(this).toLowerCase();
}
