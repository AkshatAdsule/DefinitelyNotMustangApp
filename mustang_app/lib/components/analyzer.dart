import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/components/game_action.dart';
import '../backend/team_data_analyzer.dart';
import 'package:mustang_app/constants/constants.dart';

// ignore: must_be_immutable
class Analyzer extends StatefulWidget {
  String _teamNum;

  Analyzer(String teamNum) {
    _teamNum = teamNum;
  }
  @override
  State<StatefulWidget> createState() {
    return _AnalyzerState(
      _teamNum,
    );
  }
}

class _AnalyzerState extends State<Analyzer> {
  bool _initialized = false, _hasAnalysis = true;
  String _teamNum, _driveBase;

  var _allMatches; //array that holds everything
  int _oldAllMatchLength = 0,
      _totalNumGames =
          0; //for testing if data needs to be collected again or not - if same then don't
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
      _push = [];

  _AnalyzerState(String teamNum) {
    _teamNum = teamNum;
  }

  void initState() {
    super.initState();
    if (_teamNum.isEmpty) {
      return;
    }
    //default is tank
    /*
    if (_driveBase == null){
      _driveBase = "tank";
    }
    */
    _hasAnalysis = TeamDataAnalyzer.getTeamDoc(_teamNum)['hasAnalysis'];
    if (!_hasAnalysis) {
      return;
    }
    //initialize all vars
    var action1 = new GameAction(ActionType.FOUL_REG, 2000, 3, 4);
    var action1a = new GameAction(ActionType.FOUL_TECH, 2000, 4, 4);
    var action1b = new GameAction(ActionType.SHOT_LOW, 5000, 0, 13);
    var action2 = new GameAction(ActionType.SHOT_INNER, 6000, 15, 1);
    var action3 = new GameAction(ActionType.PREV_SHOT, 10000, 13, 9);
    var action4 = new GameAction(ActionType.MISSED_OUTER, 15000, 2, 4);
    var action4a = new GameAction(ActionType.MISSED_OUTER, 16000, 1, 4);
    var action5 = new GameAction(ActionType.OTHER_CLIMB_MISS, 19000, 3, 3);
    var action6 = new GameAction(ActionType.SHOT_LOW, 30000, 0, 13);
    var action7 = new GameAction(ActionType.SHOT_INNER, 39000, 5, 2);
    var action8 = new GameAction(ActionType.SHOT_OUTER, 40000, 8, 12);
    var action9 = new GameAction.push(ActionType.PUSH, 44000, 10, 5, 8, 4, 3);

    var matchArray1 = [action1, action1a, action1b, action2, action3];
    var matchArray2 = [action4, action4a, action5, action6];
    var matchArray3 = [action7, action8, action9];

    //FINALARRAY IS WHAT WILL BE PASSED INTO THE ANALYZER
    var finalArray = [matchArray1, matchArray2, matchArray3];
    _allMatches = finalArray;
    //_collectData();

    _driveBase = "tank";
    _initialized = true;
  }

  String getReport() {
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
        "\nOffense Shooting Points per game: " +
        (calcTotOffenseShootingPts() / _totalNumGames).round().toString() +
        "\nOverall Climb Accuracy: " +
        calcTotClimbAccuracy().round().toString() +
        "%"
        //+ "\nTotal points prevented: " + calcTotPtsPrev().round().toString()
        +
        "\nPts prevented per game: " +
        (calcTotPtsPrev() / _totalNumGames).round().toString() +
        "\nShot accuracy: " +
        calcShotAccuracy().round().toString() +
        "%" +
        "\n" +
        fouls;
  }

  void _collectData() {
    _totalNumGames = _allMatches.length;
    //goes thru all matches
    for (int i = 0; i < _totalNumGames; i++) {
      var _currentMatch = _allMatches.elementAt(i);
      //goes thru each action in the match
      for (int j = 0; j < _currentMatch.length; j++) {
        GameAction _currentGameAction = _currentMatch[j];
        ActionType _currentAction = _currentGameAction.action;

        //fill up each array of actions
        switch (_currentAction) {
          case ActionType.FOUL_REG:
            {
              _foulReg.add(_currentGameAction);
            }
            break;
          case ActionType.FOUL_TECH:
            {
              _foulTech.add(_currentGameAction);
            }
            break;
          case ActionType.FOUL_YELLOW:
            {
              _foulYellow.add(_currentGameAction);
            }
            break;
          case ActionType.FOUL_RED:
            {
              _foulRed.add(_currentGameAction);
            }
            break;
          case ActionType.FOUL_DISABLED:
            {
              _foulDisabled.add(_currentGameAction);
            }
            break;
          case ActionType.FOUL_DISQUAL:
            {
              _foulDisqual.add(_currentGameAction);
            }
            break;
          case ActionType.SHOT_LOW:
            {
              _shotLow.add(_currentGameAction);
            }
            break;
          case ActionType.SHOT_OUTER:
            {
              _shotOuter.add(_currentGameAction);
            }
            break;
          case ActionType.SHOT_INNER:
            {
              _shotInner.add(_currentGameAction);
            }
            break;
          case ActionType.MISSED_LOW:
            {
              _missedLow.add(_currentGameAction);
            }
            break;
          case ActionType.MISSED_OUTER:
            {
              _missedOuter.add(_currentGameAction);
            }
            break;
          case ActionType.OTHER_CLIMB:
            {
              _otherClimb.add(_currentGameAction);
            }
            break;
          case ActionType.OTHER_CLIMB_MISS:
            {
              _otherClimbMiss.add(_currentGameAction);
            }
            break;
          case ActionType.OTHER_WHEEL_POSITION:
            {
              _otherWheelPosition.add(_currentGameAction);
            }
            break;
          case ActionType.OTHER_WHEEL_ROTATION:
            {
              _otherWheelRotation.add(_currentGameAction);
            }
            break;
          case ActionType.PREV_SHOT:
            {
              _prevShot.add(_currentGameAction);
            }
            break;
          case ActionType.PREV_INTAKE:
            {
              _prevIntake.add(_currentGameAction);
            }
            break;
          case ActionType.PUSH:
            {
              _push.add(_currentGameAction);
            }
            break;
          default:
            break;
        }
      }
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
    _push = [];
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

    for (int i = 0; i < _push.length; i++) {
      var _predictedDisplacement = _normalVelocity * _push[i].pushTime;
      var _actualDisplacement = calcDisplacement(
          _push[i].x, _push[i].y, _push[i].endX, _push[i].endY);
      var _zoneDisplacementDifference =
          (_predictedDisplacement - _actualDisplacement) /
              Constants.zoneSideLength;
      _result +=
          (_zoneDisplacementDifference * Constants.zoneDisplacementValue);
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

  @override
  Widget build(BuildContext context) {
    if (!_hasAnalysis) {
      return Text('No Analysis For This Team :(');
    } else if (_initialized) {
      return Text(this.getReport());
    } else if (_teamNum.isEmpty) {
      return Text('Error! No Team Number Entered');
    } else {
      return Text('Loading...');
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<GameAction>('_foulTech', _foulTech));
  }
}
