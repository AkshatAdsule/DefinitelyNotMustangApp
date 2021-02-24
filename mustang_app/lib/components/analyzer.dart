import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/backend/game_action.dart';
import 'package:mustang_app/backend/match.dart';
import 'package:mustang_app/backend/team.dart';
import 'package:mustang_app/backend/team_service.dart';
import 'package:mustang_app/constants/constants.dart';

// ignore: must_be_immutable
class Analyzer {
  bool _initialized = false, _hasAnalysis = true;
  String _teamNum = '', _driveBase = 'tank';
  TeamService _teamService = TeamService();
  List<Match> _allMatches = []; //array that holds everything
  int _oldAllMatchLength = 0;
  //for testing if data needs to be collected again or not - if same then don't
  int _totalNumGames = 1;
  //array for each type of action, has all instances of that action for all games
  List<GameAction> _foulReg = [],
      _foulTech = [],
      _foulYellow = [],
      _foulRed = [],
      _foulDisabled = [],
      _foulDisqual = [],
      _shotLow = [],
      _shotOuter = [],
      _shotInner = [],
      _missedLow = [],
      _missedOuter = [],
      _otherClimb = [],
      _otherClimbMiss = [],
      _otherWheelPosition = [],
      _otherWheelRotation = [],
      _prevShot = [],
      _prevIntake = [],
      _pushStart = [],
      _pushEnd = [];

  Analyzer(String teamNum) {
    _teamNum = teamNum;
  }

  bool get initialized => _initialized;

  Future<void> init() async {    
    Team team = await _teamService.getTeam(_teamNum);
    List<Match> matches = await _teamService.getMatches(_teamNum);
    _driveBase = team.drivebaseType;
    _allMatches = matches;
    _initialized = true;
  }

  int totalNumGames() => _totalNumGames;

  String getReport() {
    if (!_initialized || _allMatches.length == 0){
      return "No analysis available";
    }
    //TEST TO SEE IF DATA RLY NEEDS TO BE COLLECTED!!
    if (_allMatches.length > _oldAllMatchLength) {
      _oldAllMatchLength = _allMatches.length;
      //need to reset everything to 0 (simpler than checking what parts need to be updated)
      _clearAllData();
      _collectData();
    }

    String fouls = "";
    if (_foulReg.length > 0) {
      fouls += "Reg Fouls: " + _foulReg.length.toString();
    }
    if (_foulTech.length > 0) {
      fouls += " Tech Fouls: " + _foulTech.length.toString();
    }
    if (_foulYellow.length > 0) {
      fouls += " Yellow Fouls: " + _foulYellow.length.toString();
    }
    if (_foulRed.length > 0) {
      fouls += " Red Fouls: " + _foulRed.length.toString();
    }
    if (_foulDisabled.length > 0) {
      fouls += " Disabled Fouls: " + _foulDisabled.length.toString();
    }
    if (_foulDisqual.length > 0) {
      fouls += " Disqual Fouls: " + _foulDisqual.length.toString();
    }

    return "Team: " +
        _teamNum
        //+ "\nOffense Shooting Points: " + calcTotOffenseShootingPts().round().toString()
        +
        "\nShooting pts/game: " +
        (calcTotOffenseShootingPts() / _totalNumGames).round().toString() +
        "    Climb Accuracy: " +
        calcTotClimbAccuracy().round().toString() +
        "%"
        //+ "\nTotal points prevented: " + calcTotPtsPrev().round().toString()
        +
        "    Points prevented/game: " +
        (calcTotPtsPrev() / _totalNumGames).round().toString() +
        "    Shot Accuracy: " +
        calcShotAccuracy().round().toString() +
        "%" +
        "\n" +
        fouls;
  }

  void _collectData() {
    _totalNumGames = _allMatches.length;
    //goes thru all matches
    for (int i = 0; i < _totalNumGames; i++) {
      Match _currentMatch = _allMatches[i];
      List<GameAction> actions = _currentMatch.actions;

      _foulReg.addAll(
          actions.where((element) => element.action == ActionType.FOUL_REG));
      _foulTech.addAll(
          actions.where((element) => element.action == ActionType.FOUL_TECH));
      _foulYellow.addAll(
          actions.where((element) => element.action == ActionType.FOUL_YELLOW));
      _foulRed.addAll(
          actions.where((element) => element.action == ActionType.FOUL_RED));
      _foulDisabled.addAll(actions
          .where((element) => element.action == ActionType.FOUL_DISABLED));
      _foulDisqual.addAll(actions
          .where((element) => element.action == ActionType.FOUL_DISQUAL));
      _shotInner.addAll(
          actions.where((element) => element.action == ActionType.SHOT_INNER));
      _shotOuter.addAll(
          actions.where((element) => element.action == ActionType.SHOT_OUTER));
      _shotLow.addAll(
          actions.where((element) => element.action == ActionType.SHOT_LOW));
      _missedLow.addAll(
          actions.where((element) => element.action == ActionType.MISSED_LOW));
      _missedOuter.addAll(actions
          .where((element) => element.action == ActionType.MISSED_OUTER));
      _otherClimb.addAll(
          actions.where((element) => element.action == ActionType.OTHER_CLIMB));
      _otherClimbMiss.addAll(actions
          .where((element) => element.action == ActionType.OTHER_CLIMB_MISS));
      _otherWheelRotation.addAll(actions.where(
          (element) => element.action == ActionType.OTHER_WHEEL_ROTATION));
      _otherWheelPosition.addAll(actions.where(
          (element) => element.action == ActionType.OTHER_WHEEL_POSITION));
      _prevIntake.addAll(
          actions.where((element) => element.action == ActionType.PREV_INTAKE));
      _prevShot.addAll(
          actions.where((element) => element.action == ActionType.PREV_SHOT));
      _pushStart.addAll(
          actions.where((element) => element.action == ActionType.PUSH_START));
      _pushEnd.addAll(
          actions.where((element) => element.action == ActionType.PUSH_END));
    }
  }

  //used when more data is added, need to clear everything then re-add
  void _clearAllData() {
    _foulReg = [];
    _foulTech = [];
    _foulYellow = [];
    _foulRed = [];
    _foulDisabled = [];
    _foulDisqual = [];
    _shotLow = [];
    _shotOuter = [];
    _shotInner = [];
    _missedLow = [];
    _missedOuter = [];
    _otherClimb = [];
    _otherClimbMiss = [];
    _otherWheelPosition = [];
    _otherWheelRotation = [];
    _prevShot = [];
    _prevIntake = [];
    _pushStart = [];
    _pushEnd = [];
  }

  double calcTotOffenseShootingPts() {
    double _lowPts = 0.0, _outerPts = 0.0, _innerPts = 0.0;
    for (int i = 0; i < _shotLow.length; i++) {
      if (_shotLow[i].timeStamp <= Constants.autonMillisecondLength) {
        _lowPts += Constants.lowShotAutonValue;
      } else {
        _lowPts += Constants.lowShotValue;
      }
    }

    for (int i = 0; i < _shotOuter.length; i++) {
      if (_shotOuter[i].timeStamp <= Constants.autonMillisecondLength) {
        _outerPts += Constants.outerShotAutonValue;
      } else {
        _outerPts += Constants.outerShotValue;
      }
    }

    for (int i = 0; i < _shotInner.length; i++) {
      if (_shotInner[i].timeStamp <= Constants.autonMillisecondLength) {
        _innerPts += Constants.innerShotAutonValue;
      } else {
        _innerPts += Constants.innerShotValue;
      }
    }

    double _rotationControl =
        _otherWheelRotation.length * Constants.positionControl;
    double _positionControl =
        _otherWheelPosition.length * Constants.positionControl;
    double _climb = _otherClimb.length * Constants.climbValue;
    return _lowPts +
        _outerPts +
        _innerPts +
        _rotationControl +
        _positionControl +
        _climb;
  }

  double calcShotAccuracy() {
    int _successfulShots =
        _shotLow.length + _shotOuter.length + _shotInner.length;
    int _missedShots = _missedLow.length + _missedOuter.length;
    return (_successfulShots / (_successfulShots + _missedShots)) * 100;
  }

  double calcTotClimbAccuracy() {
    double _climb = _otherClimb.length * 1.0;
    double _miss = _otherClimbMiss.length * 1.0;
    double _totalClimbAttempts = _climb + _miss;
    if (_totalClimbAttempts == 0) {
      return 0;
    }
    return (_climb / _totalClimbAttempts) * 100.0;
  }

  double calcTotPtsPrev() {
    return calcShotPtsPrev() +
        calcIntakePtsPrev() +
        calcPushPtsPrev() -
        calcFoulLostPts();
  }

  double calcShotPtsPrev() {
    return _prevShot.length * Constants.shotValue;
  }

  double calcIntakePtsPrev() {
    return _prevIntake.length * Constants.intakeValue;
  }

  double calcPushPtsPrev() {
    double _result = 0.0;
    //set speed
    double _normalVelocity = 0.0;

    if (_driveBase.contains("tank")) {
      _normalVelocity = Constants.tankSpeed;
    }
    if (_driveBase.contains("omni")) {
      _normalVelocity = Constants.omniSpeed;
    }
    if (_driveBase.contains("westCoast")) {
      _normalVelocity = Constants.westCoastSpeed;
    }
    if (_driveBase.contains("mecanum")) {
      _normalVelocity = Constants.mecanumSpeed;
    }
    if (_driveBase.contains("swerve")) {
      _normalVelocity = Constants.swerveSpeed;
    }

    for (int i = 0; i < _pushStart.length; i++) {
      var _actualDisplacement = calcDisplacement(_pushStart[i].x, _pushStart[i].y, _pushEnd[i].x, _pushEnd[i].y);
      var _pushTimeSeconds = (_pushEnd[i].timeStamp - _pushStart[i].timeStamp)/1000;
      var _predictedDisplacement = _normalVelocity * _pushTimeSeconds;
      var _zoneDisplacementDifference = (_predictedDisplacement - _actualDisplacement)/Constants.zoneSideLength;
      _result += (_zoneDisplacementDifference * Constants.zoneDisplacementValue);
    }

    return _result;
  }

  //returns neg value if displaced in opp direction, positive if displaced in aBot's intended direction
  double calcDisplacement(double x, double y, double endX, double endY) {
    var _columnDisplacement = (endX - x) * Constants.zoneSideLength;
    var _rowDisplacement = (endY - y) * Constants.zoneSideLength;
    //"hypotenuse" of column and row displacement
    var _displacement =
        pow(pow(_columnDisplacement, 2) + pow(_rowDisplacement, 2), 1 / 2);

    //went backwards, make displacement negative
    if (endX - x < 0) {
      _displacement *= -1;
    }
    return _displacement;
  }

  //returns a positive number, must subtract from total
  double calcFoulLostPts() {
    double _regPtsLost = _foulReg.length * Constants.regFoul;
    double _techPtsLost = _foulTech.length * Constants.techFoul;
    double _yellowPtsLost = _foulYellow.length * Constants.techFoul;
    double _redPtsLost = _foulRed.length * Constants.redCard;
    return _regPtsLost + _techPtsLost + _yellowPtsLost + _redPtsLost;
  }

  //for map display, takes in a zone and returns offense pts scored there
  double calcShotAccuracyAtZone(double x, double y){
    double shotsMade = 0;
    double shotsMissed = 0;
    for (int i = 0; i < _allMatches.length; i++) {
      //inside each array of actions
      for (int j = 0; j < _allMatches[i].actions.length; j++) {
        GameAction currentAction = _allMatches[i].actions[j];
        if (currentAction.action == ActionType.SHOT_LOW || currentAction.action == ActionType.SHOT_OUTER || currentAction.action == ActionType.SHOT_INNER) {
          if (currentAction.x == x && currentAction.y == y) {
            shotsMade ++;
          }
        }

        if (currentAction.action == ActionType.MISSED_LOW || currentAction.action == ActionType.MISSED_OUTER) {
          if (currentAction.x == x && currentAction.y == y) {
            shotsMissed ++;
          }
        }
      }
    }
    return shotsMade/(shotsMade + shotsMissed);
  }
  double calcPtsAtZone(double x, double y) {
    //random values for testing purposes that doesn't work
    double totalPoints = 0;

    for (int i = 0; i < _allMatches.length; i++) {
      //inside each array of actions
      for (int j = 0; j < _allMatches[i].actions.length; j++) {
        //low shot
        GameAction currentAction = _allMatches[i].actions[j];
        if (currentAction.action == ActionType.SHOT_LOW) {
          if (currentAction.x == x && currentAction.y == y) {
            if (currentAction.timeStamp <= 15000) {
              totalPoints += Constants.lowShotAutonValue;
            } else {
              totalPoints += Constants.lowShotValue;
            }
          }
        }

        //outer shot
        if (currentAction.action == ActionType.SHOT_OUTER) {
          if (currentAction.x == x && currentAction.y == y) {
            if (currentAction.timeStamp <= 15000) {
              totalPoints += Constants.outerShotAutonValue;
            } else {
              totalPoints += Constants.outerShotValue;
            }
          }
        }

        //inner shot
        if (currentAction.action == ActionType.SHOT_INNER) {
          if (currentAction.x == x && currentAction.y == y) {
            if (currentAction.timeStamp <= 15000) {
              totalPoints += Constants.innerShotAutonValue;
            } else {
              totalPoints += Constants.innerShotValue;
            }
          }
        }
      }
    }
    
    return totalPoints;
  }
}
