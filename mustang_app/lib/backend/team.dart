import 'package:cloud_firestore/cloud_firestore.dart';

enum CheckBoxValues { NULL, TRUE, FALSE }

class Team {
  String _teamNumber, _drivebaseType, _notes;
  CheckBoxValues _innerPort,
      _outerPort,
      _bottomPort,
      _rotationControl,
      _positionControl,
      _hasClimber,
      _hasLeveller;

  Team(
      this._teamNumber,
      this._drivebaseType,
      this._notes,
      this._innerPort,
      this._outerPort,
      this._bottomPort,
      this._rotationControl,
      this._positionControl,
      this._hasClimber,
      this._hasLeveller);

  factory Team.fromSnapshot(DocumentSnapshot snapshot) {
    if (!snapshot.exists) {
      return null;
    }
    Map<String, dynamic> data = snapshot.data();
    return Team(
      snapshot.id,
      data['drivebaseType'] ?? 'tank',
      data['notes'] ?? '',
      data['innerPort'] ?? CheckBoxValues.NULL,
      data['outerPort'] ?? CheckBoxValues.NULL,
      data['bottomPort'] ?? CheckBoxValues.NULL,
      data['rotationControl'] ?? CheckBoxValues.NULL,
      data['positionControl'] ?? CheckBoxValues.NULL,
      data['climber'] ?? CheckBoxValues.NULL,
      data['leveller'] ?? CheckBoxValues.NULL,
    );
  }

  factory Team.fromJson(Map<String, dynamic> data) {
    return Team(
      data['teamNumber'] ?? '',
      data['drivebaseType'] ?? 'tank',
      data['notes'] ?? '',
      data['innerPort'] ?? CheckBoxValues.NULL,
      data['outerPort'] ?? CheckBoxValues.NULL,
      data['bottomPort'] ?? CheckBoxValues.NULL,
      data['rotationControl'] ?? CheckBoxValues.NULL,
      data['positionControl'] ?? CheckBoxValues.NULL,
      data['climber'] ?? CheckBoxValues.NULL,
      data['leveller'] ?? CheckBoxValues.NULL,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teamNumber': _teamNumber,
      'drivebaseType': _drivebaseType,
      'notes': _notes,
      'innerPort': _innerPort,
      'outerPort': _outerPort,
      'bottomPort': _bottomPort,
      'rotationControl': _rotationControl,
      'positionControl': _positionControl,
      'leveller': _hasLeveller,
      'climber': _hasClimber,
    };
  }

  String get teamNumber => _teamNumber;
  String get drivebaseType => _drivebaseType;
  String get notes => _notes;
  CheckBoxValues get innerPort => _innerPort;
  CheckBoxValues get outerPort => _outerPort;
  CheckBoxValues get bottomPort => _bottomPort;
  CheckBoxValues get rotationControl => _rotationControl;
  CheckBoxValues get positionControl => _positionControl;
  CheckBoxValues get hasLeveller => _hasLeveller;
  CheckBoxValues get hasClimber => _hasClimber;

  set teamNumber(String teamNumber) => _teamNumber = teamNumber;
  set drivebaseType(String drivebaseType) => _drivebaseType = drivebaseType;
  set notes(String notes) => _notes = notes;
  set innerPort(CheckBoxValues innerPort) => _innerPort = innerPort;
  set outerPort(CheckBoxValues outerPort) => _outerPort = outerPort;
  set bottomPort(CheckBoxValues bottomPort) => _bottomPort = bottomPort;
  set rotationControl(CheckBoxValues rotationControl) =>
      _rotationControl = rotationControl;
  set positionControl(CheckBoxValues positionControl) =>
      _positionControl = positionControl;
  set hasLeveller(CheckBoxValues hasLeveller) => _hasLeveller = hasLeveller;
  set hasClimber(CheckBoxValues hasClimber) => _hasClimber = hasClimber;
}
