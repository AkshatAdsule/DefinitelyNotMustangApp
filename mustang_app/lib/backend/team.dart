import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  String _teamNumber, _drivebaseType, _notes;
  bool _innerPort,
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

  Team.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data;
    _teamNumber = snapshot.documentID;
    _drivebaseType = data['drivebaseType'];
    _notes = data['notes'];
    _innerPort = data['innerPort'];
    _outerPort = data['outerPort'];
    _teamNumber = data['bottomPort'];
    _rotationControl = data['rotationControl'];
    _positionControl = data['positionControl'];
    _hasLeveller = data['leveller'];
    _hasClimber = data['climber'];
  }

  Team.fromJson(Map<String, dynamic> data) {
    _teamNumber = data['teamNumber'];
    _drivebaseType = data['drivebaseType'];
    _notes = data['notes'];
    _innerPort = data['innerPort'];
    _outerPort = data['outerPort'];
    _teamNumber = data['bottomPort'];
    _rotationControl = data['rotationControl'];
    _positionControl = data['positionControl'];
    _hasLeveller = data['leveller'];
    _hasClimber = data['climber'];
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
  bool get innerPort => _innerPort;
  bool get outerPort => _outerPort;
  bool get bottomPort => _bottomPort;
  bool get rotationControl => _rotationControl;
  bool get positionControl => _positionControl;
  bool get hasLeveller => _hasLeveller;
  bool get hasClimber => _hasClimber;

  set teamNumber(String teamNumber) => _teamNumber = teamNumber;
  set drivebaseType(String drivebaseType) => _drivebaseType = drivebaseType;
  set notes(String notes) => _notes = notes;
  set innerPort(bool innerPort) => _innerPort = innerPort;
  set outerPort(bool outerPort) => _outerPort = outerPort;
  set bottomPort(bool bottomPort) => _bottomPort = bottomPort;
  set rotationControl(bool rotationControl) =>
      _rotationControl = rotationControl;
  set positionControl(bool positionControl) =>
      _positionControl = positionControl;
  set hasLeveller(bool hasLeveller) => _hasLeveller = hasLeveller;
  set hasClimber(bool hasClimber) => _hasClimber = hasClimber;
}
