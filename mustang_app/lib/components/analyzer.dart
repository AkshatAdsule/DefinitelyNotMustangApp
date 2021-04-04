import 'dart:math';
import 'package:mustang_app/backend/game_action.dart';
import 'package:mustang_app/backend/match.dart';
import 'package:mustang_app/backend/team.dart';
import 'package:mustang_app/backend/team_service.dart';
import 'package:mustang_app/constants/constants.dart';

// ignore: must_be_immutable
class Analyzer {
  bool _initialized = false;
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
      _pushEnd = [],
      _otherCrossedInitiationLine = [],
      _otherParked = [],
      _otherLevelled = [];

  Analyzer(String teamNum) {
    _teamNum = teamNum;
  }

  bool get initialized => _initialized;
  String get teamNum => _teamNum;
  int totalNumGames() => _totalNumGames;

  Future<void> init() async {
    Team team = await _teamService.getTeam(_teamNum);
    List<Match> matches = await _teamService.getMatches(_teamNum);
    _driveBase = team.drivebaseType;
    _allMatches = matches;
    flipGameActionOffenseAllMatches();
    _initialized = true;
  }

  List<String> getMatches() {
    List<String> matchNums = [];
    matchNums.add("");
    for (Match m in _allMatches) {
      matchNums.add(m.matchNumber);
    }
    return matchNums;
  }

  // returns names of the matches for the team
  List<GameAction> getMatch(String matchNum) {
    for (Match m in _allMatches)
      if (m.matchNumber == matchNum) return m.actions;
    return [];
  }

  // returns a list of actions at the time, x and y will be passed
  List<GameAction> getActionsAtTime(List<GameAction> matchActions, int second) {
    List<GameAction> currActions = [];
    for (GameAction g in matchActions) {
      if (g.timeStamp > ((second.round() * 1000) - 5000) &&
          g.timeStamp < ((second.round() * 1000) + 5000)) {
        currActions.add(g);
      }
    }
    return currActions;
  }

  String getReport() {
    if (!_initialized || _allMatches.length == 0) {
      return "No analysis available";
    }

    if (_allMatches.length > _oldAllMatchLength) {
      _oldAllMatchLength = _allMatches.length;
      //need to reset everything to 0 (simpler than checking what parts need to be updated)
      _clearAllData();
      _collectData();
    }

    int _shootingPtsPerGame =
        (calcOffenseShootingPts() / _totalNumGames).round();
    int _nonShootingsPtsPerGame =
        (calcOffenseNonShootingPts() / _totalNumGames).round();
    int _climbAccuracy = calcTotClimbAccuracy().round();
    int _shotAccuracy = calcShotAccuracy().round();
    int _ptsPreventedPerGame = (calcTotPtsPrev() / _totalNumGames).round();

    if (_shootingPtsPerGame == double.nan ||
        _shootingPtsPerGame == double.infinity) {
      _shootingPtsPerGame = null;
    }

    String fouls = "";
    if (_foulReg.length > 0) {
      fouls += "Reg Fouls: " + _foulReg.length.toString();
    }
    if (_foulTech.length > 0) {
      fouls += "    Tech Fouls: " + _foulTech.length.toString();
    }
    if (_foulYellow.length > 0) {
      fouls += "    Yellow Fouls: " + _foulYellow.length.toString();
    }
    if (_foulRed.length > 0) {
      fouls += "    Red Fouls: " + _foulRed.length.toString();
    }
    if (_foulDisabled.length > 0) {
      fouls += "    Disabled Fouls: " + _foulDisabled.length.toString();
    }
    if (_foulDisqual.length > 0) {
      fouls += "    Disqual Fouls: " + _foulDisqual.length.toString();
    }

    return "Shooting pts/game: " +
        _shootingPtsPerGame.toString() +
        "    Non-shooting pts/game: " +
        _nonShootingsPtsPerGame.toString() +
        "    Climb Accuracy: " +
        _climbAccuracy.toString() +
        "%\n    Shot Accuracy: " +
        _shotAccuracy.toString() +
        "%    Pts prevented/game: " +
        _ptsPreventedPerGame.toString() +
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
      _otherCrossedInitiationLine.addAll(actions.where((element) =>
          element.action == ActionType.OTHER_CROSSED_INITIATION_LINE));
      _otherParked.addAll(actions
          .where((element) => element.action == ActionType.OTHER_PARKED));
      _otherLevelled.addAll(actions
          .where((element) => element.action == ActionType.OTHER_LEVELLED));
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
    _otherCrossedInitiationLine = [];
    _otherParked = [];
    _otherLevelled = [];
  }

  double calcOffenseShootingPts() {
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
    return _lowPts + _outerPts + _innerPts;
  }

  double calcOffenseNonShootingPts() {
    double _crossInitiation =
        _otherCrossedInitiationLine.length * Constants.crossInitiationLineValue;
    double _rotationControl =
        _otherWheelRotation.length * Constants.positionControl;
    double _positionControl =
        _otherWheelPosition.length * Constants.positionControl;
    double _climb = (_otherClimb.length * Constants.climbValue) +
        (_otherParked.length * Constants.endgameParkValue) +
        (_otherLevelled.length * Constants.levelledValue);

    return _crossInitiation + _rotationControl + _positionControl + _climb;
  }

  double calcShotAccuracy() {
    int _successfulShots =
        _shotLow.length + _shotOuter.length + _shotInner.length;
    int _missedShots = _missedLow.length + _missedOuter.length;
    if (_successfulShots + _missedShots != 0) {
      return (_successfulShots / (_successfulShots + _missedShots)) * 100.0;
    } else {
      return 0;
    }
  }

  double calcTotClimbAccuracy() {
    double _climb = (_otherClimb.length + _otherLevelled.length) * 1.0;
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

  double getBallsInBot(String matchNum, double timeStamp) {
    double ballsInBot = 0;
    List<GameAction> matchActions = getMatch(matchNum);

    if (matchActions == null) {
      return 0;
    }

    for (int b = 0; b < matchActions.length; b++) {
      //add intaked balls
      if (matchActions[b].action == ActionType.INTAKE &&
          matchActions[b].timeStamp <= timeStamp) {
        ballsInBot++;
      }

      //remove balls that were shot
      if (matchActions[b].action == ActionType.SHOT_LOW ||
          matchActions[b].action == ActionType.SHOT_OUTER ||
          matchActions[b].action == ActionType.SHOT_INNER) {
        if (matchActions[b].timeStamp <= timeStamp) {
          ballsInBot--;
        }
      }
    }

    return ballsInBot;
  }

  double calcPushPtsPrev() {
    double result = 0;

    //goes thru all matches
    for (int i = 0; i < _allMatches.length; i++) {
      Match _currentMatch = _allMatches[i];
      List<GameAction> actions = _currentMatch.actions;
      String matchNum = _currentMatch.matchNumber;
      for (int a = 0; a < actions.length; a++) {
        if (actions[a].action == ActionType.PUSH_START) {
          double ballsInBot = getBallsInBot(matchNum, actions[a].timeStamp);
          //assume immediate action is end push
          result +=
              calcSinglePushPtsPrev(actions[a], actions[a + 1], ballsInBot);
        }
      }
    }
    return result;
  }

  double calcSinglePushPtsPrev(
      GameAction pushStart, GameAction pushEnd, double ballsInBot) {
    double zoneDisplacementValue = Constants.zoneDisplacementValue;
    zoneDisplacementValue *=
        (ballsInBot / Constants.maxBallsInBot); //take balls in bot into account
    zoneDisplacementValue *= calcShotAccuracy() /
        100.0; //take shot accuracy into account, worth more if higher value

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

    var _actualDisplacement =
        calcDisplacement(pushStart.x, pushStart.y, pushEnd.x, pushEnd.y);
    var _pushTimeSeconds = (pushEnd.timeStamp - pushStart.timeStamp) / 1000.0;
    var _predictedDisplacement = _normalVelocity * _pushTimeSeconds;
    var _zoneDisplacementDifference =
        (_predictedDisplacement - _actualDisplacement) /
            Constants.zoneSideLength;
    _result += (_zoneDisplacementDifference * zoneDisplacementValue);

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
    return (_foulReg.length * Constants.regFoul) +
        (_foulTech.length * Constants.techFoul) +
        (_foulYellow.length * Constants.techFoul) +
        (_foulRed.length * Constants.redCard);
  }

  double calcShotAccuracyAtZone(ActionType actionType, double x, double y) {
    double shotsMade = 0;
    double shotsMissed = 0;
    _clearAllData();
    _collectData();
    if (actionType == ActionType.ALL) {
      for (int i = 0; i < _allMatches.length; i++) {
        //inside each array of actions
        for (int j = 0; j < _allMatches[i].actions.length; j++) {
          GameAction currentAction = _allMatches[i].actions[j];
          if (currentAction.action == ActionType.SHOT_LOW ||
              currentAction.action == ActionType.SHOT_OUTER ||
              currentAction.action == ActionType.SHOT_INNER) {
            if (currentAction.x == x && currentAction.y == y) {
              shotsMade++;
            }
          }

          if (currentAction.action == ActionType.MISSED_LOW ||
              currentAction.action == ActionType.MISSED_OUTER) {
            if (currentAction.x == x && currentAction.y == y) {
              shotsMissed++;
            }
          }
        }
      }
    } else {
      ActionType missedVersionOfAction;
      //cannot miss a inner shot, accuracy is 100%
      if (actionType == ActionType.SHOT_INNER) {
        for (int i = 0; i < _allMatches.length; i++) {
          //inside each array of actions
          for (int j = 0; j < _allMatches[i].actions.length; j++) {
            GameAction currentAction = _allMatches[i].actions[j];
            if (currentAction.action == actionType) {
              if (currentAction.x == x && currentAction.y == y) {
                shotsMade++;
              }
            }
          }
        }
        if (shotsMade + shotsMissed == 0) {
          return 0;
        }
        return 1;
      }
      if (actionType == ActionType.SHOT_OUTER) {
        missedVersionOfAction = ActionType.MISSED_OUTER;
      }

      if (actionType == ActionType.SHOT_LOW) {
        missedVersionOfAction = ActionType.MISSED_LOW;
      }

      for (int i = 0; i < _allMatches.length; i++) {
        //inside each array of actions
        for (int j = 0; j < _allMatches[i].actions.length; j++) {
          GameAction currentAction = _allMatches[i].actions[j];
          if (currentAction.action == actionType) {
            if (currentAction.x == x && currentAction.y == y) {
              shotsMade++;
            }
          }

          if (currentAction.action == missedVersionOfAction) {
            if (currentAction.x == x && currentAction.y == y) {
              shotsMissed++;
            }
          }
        }
      }
    }
    if (shotsMade + shotsMissed == 0) {
      return 0;
    }
    return shotsMade / (shotsMade + shotsMissed);
  }

  //if doing everything, set actionType = ActionType.ALL
  double calcPtsAtZone(ActionType actionType, double x, double y) {
    double totalPoints = 0;
    double pointValueAuton = 0;
    double pointValueTeleop = 0;
    _clearAllData();
    _collectData();
    if (actionType == null) {
      return 0;
    } else if (actionType == ActionType.ALL) {
      for (int i = 0; i < _allMatches.length; i++) {
        //inside each array of actions
        for (int j = 0; j < _allMatches[i].actions.length; j++) {
          //low shot
          GameAction currentAction = _allMatches[i].actions[j];
          if (currentAction.action == ActionType.SHOT_LOW) {
            if (currentAction.x == x && currentAction.y == y) {
              if (currentAction.timeStamp <= Constants.teleopStartMillis) {
                totalPoints += Constants.lowShotAutonValue;
              } else {
                totalPoints += Constants.lowShotValue;
              }
            }
          }

          //outer shot
          if (currentAction.action == ActionType.SHOT_OUTER) {
            if (currentAction.x == x && currentAction.y == y) {
              if (currentAction.timeStamp <= Constants.teleopStartMillis) {
                totalPoints += Constants.outerShotAutonValue;
              } else {
                totalPoints += Constants.outerShotValue;
              }
            }
          }

          //inner shot
          if (currentAction.action == ActionType.SHOT_INNER) {
            if (currentAction.x == x && currentAction.y == y) {
              if (currentAction.timeStamp <= Constants.teleopStartMillis) {
                totalPoints += Constants.innerShotAutonValue;
              } else {
                totalPoints += Constants.innerShotValue;
              }
            }
          }
        }
      }
    } else {
      if (actionType == ActionType.SHOT_INNER) {
        pointValueAuton = Constants.innerShotAutonValue;
        pointValueTeleop = Constants.innerShotValue;
      }
      if (actionType == ActionType.SHOT_OUTER) {
        pointValueAuton = Constants.outerShotAutonValue;
        pointValueTeleop = Constants.outerShotValue;
      }
      if (actionType == ActionType.SHOT_LOW) {
        pointValueAuton = Constants.lowShotAutonValue;
        pointValueTeleop = Constants.lowShotValue;
      }

      for (int i = 0; i < _allMatches.length; i++) {
        //inside each array of actions
        for (int j = 0; j < _allMatches[i].actions.length; j++) {
          GameAction currentAction = _allMatches[i].actions[j];
          if (currentAction.action == actionType) {
            if (currentAction.x == x && currentAction.y == y) {
              if (currentAction.timeStamp <= Constants.teleopStartMillis) {
                totalPoints += pointValueAuton;
              } else {
                totalPoints += pointValueTeleop;
              }
            }
          }
        }
      }
    }
    return totalPoints;
  }

  //normalize data if offense was on left side, switch columns (or x) to the other side
  //ex: column 0 becomes column 15, column 3 becomes 12, columm 7 becomes 8
  void flipGameActionOffenseAllMatches() {
    int largestColumnNum = Constants.zoneColumns - 1;
    int largestRowNum = Constants.zoneRows - 1;

    for (Match m in _allMatches) {
      if (m.offenseOnRightSide != null && !m.offenseOnRightSide) {
        for (GameAction a in m.actions) {
          double tempX = a.x;
          a.x = largestColumnNum - tempX;

          double tempY = a.y;
          a.y = largestRowNum - tempY;
        }
      }
    }
  }
}
