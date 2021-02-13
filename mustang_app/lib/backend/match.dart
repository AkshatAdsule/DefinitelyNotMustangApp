import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustang_app/backend/game_action.dart';

class Match {
  String _matchNumber, _teamNumber, _allianceColor, _matchResult, _notes;
  List<GameAction> _actions;

  Match(this._matchNumber, this._teamNumber, this._allianceColor,
      this._matchResult, this._notes, this._actions);

  factory Match.fromJson(Map<String, dynamic> data) {
    return Match(
      data['matchNumber'] ?? '',
      data['teamNumber'] ?? '',
      data['allianceColor'] ?? 'blue',
      data['matchResult'] ?? 'Lose',
      data['finalComments'] ?? '',
      data['actions'] != null
          ? data['actions']
              .map((action) => GameAction.fromJson(action))
              .toList()
          : [],
    );
  }

  factory Match.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data;
    return Match(
      snapshot.documentID,
      data['teamNumber'] ?? '',
      data['allianceColor'] ?? 'blue',
      data['matchResult'] ?? 'Lose',
      data['finalComments'] ?? '',
      data['actions'] != null
          ? List<dynamic>.of(data['actions'])
              .map((e) => GameAction.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teamNumber': _teamNumber,
      'matchNumber': _matchNumber,
      'finalComments': _notes,
      'allianceColor': _allianceColor,
      'matchResult': _matchResult,
      'actions': _actions.map((e) => e.toString()).toList(),
    };
  }

  String get matchNumber => _matchNumber;
  String get teamNumber => _teamNumber;
  String get allianceColor => _allianceColor;
  String get matchResult => _matchResult;
  String get notes => _notes;
  List<GameAction> get actions => _actions;

  set matchNumber(String matchNumber) => _matchNumber = matchNumber;
  set teamNumber(String teamNumber) => _teamNumber = teamNumber;
  set allianceColor(String allianceColor) => _allianceColor = allianceColor;
  set matchResult(String matchResult) => _matchResult = matchResult;
  set notes(String notes) => _notes = notes;
  set actions(List<GameAction> actions) => _actions = actions;
}
