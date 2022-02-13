import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:mustang_app/constants/game_constants.dart';
import 'package:mustang_app/constants/robot_constants.dart';
import 'package:mustang_app/models/game_action.dart';
import 'package:mustang_app/models/match.dart';
import 'package:mustang_app/models/robot.dart';
import 'package:mustang_app/models/team.dart';
import '../models/match.dart';

// ignore: must_be_immutable
class Analyzer {
  Team team;
  List<Match> matches;
  bool _initialized = false;
  String _teamNum = '';
  DriveBaseType _driveBase = DriveBaseType.TANK;
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

      //rapid react actions
      _shotLowerHub = [],
      _shotUpperHub = [],
      _missedLowerHub = [],
      _missedUpperHub = [],
      _terminalIntake = [],
      _missedTerminalIntake = [],
      _groundIntake = [],
      _missGroundIntake = [],
      _climbLowRung = [],
      _climbMidRung = [],
      _climbHighRung = [],
      _climbTraversalRung = [],
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

  Analyzer({this.team, this.matches}) {
    init(team, matches);
  }

  bool get initialized => _initialized;
  String get teamNum => _teamNum;
  int totalNumGames() => _totalNumGames;

  void init(Team newTeam, List<Match> newMatches) {
    if (newTeam != null && newMatches != null) {
      team = newTeam;
      matches = newMatches;
      _driveBase = team.drivebaseType;
      _allMatches = matches;
      flipGameActionOffenseAllMatches();
      _initialized = true;
    } else {
      _initialized = false;
    }
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

  String getDataDisplayForMatch(String matchNum) {
    //_clearAllData();
    // _collectData();

    /* failed attempt at looping it. was hard to understand and replicate for future games anyways

    //if val is >0, then it occurred
    List<ActionType> actionsToDisplay = [ActionType.SHOT_INNER, ActionType.SHOT_OUTER, ActionType.SHOT_LOW, ActionType.INTAKE, ActionType.MISSED_OUTER, ActionType.MISSED_LOW, ActionType.MISSED_INTAKE, ActionType.OTHER_CLIMB, ActionType.OTHER_CLIMB_MISS, ActionType.OTHER_WHEEL_POSITION, ActionType.OTHER_WHEEL_ROTATION, ActionType.PREV_SHOT, ActionType.PREV_INTAKE, ActionType.OTHER_CROSSED_INITIATION_LINE, ActionType.OTHER_PARKED, ActionType.OTHER_LEVELLED];
    //index of actionOccurences matches index of actionsToDisplay
    List<int> teleopActionOccurences = [actionsToDisplay.length];

    //first 7 indexes matches first 7 indexes of actionsToDisplay but auton version
    //last 11 indexes will be empty
    List<int> autonActionOccurences = [actionsToDisplay.length];

    for (int a = 0; a < teleopActionOccurences.length; a++){
      teleopActionOccurences[a] = 0;
      autonActionOccurences[a] = 0;
    }
    
    debugPrint("actions: " + actions.toString());
    debugPrint("actions to display length: " + actionsToDisplay.length.toString());
    //fill up variables above with values
    for (int i = 0; i < actions.length; i++){
      for (int j = 0; j < actionsToDisplay.length; j++){
        GameAction currAction = actions[i];
        if (currAction.actionType == actionsToDisplay[j]){
          debugPrint("j: " + j.toString());
          if (currAction.timeStamp <= GameConstants.autonMillisecondLength){ //happened during auton
            //debugPrint("autonActionOccurences[j]: " + autonActionOccurences[j].toString());
            //autonActionOccurences[j] ++; //use j to set same index as action
          } else{
            //teleopActionOccurences[j]++;
          }
        }
      }
    }
    */

    String result = "";

    List<GameAction> actions = getMatch(matchNum);

    bool crossedTarmac = false,
        wheelPosition = false,
        wheelRotation = false,
        climbed = false,
        climbMissed = false,
        climbLevelled = false,
        climbParked = false,
        //rapid react climbing actions
        climbedLow = false,
        climbedMid = false,
        climbedHigh = false,
        climbedTraversal = false;
    int autonInnerScored = 0,
        autonOuterScored = 0,
        autonLowScored = 0,
        autonOuterMissed = 0,
        autonLowMissed = 0,
        autonIntake = 0,
        autonIntakeMissed = 0,
        //rapid react actions
        autonLowerScored = 0,
        autonUpperScored = 0,
        autonTerminalIntake = 0,
        autonGroundIntake = 0,
        autonLowerMissed = 0,
        autonUpperMissed = 0,
        autonTerminalIntakeMissed = 0,
        autonGroundIntakeMissed = 0;
    int teleopInnerScored = 0,
        teleopOuterScored = 0,
        teleopLowScored = 0,
        teleopOuterMissed = 0,
        teleopLowMissed = 0,
        teleopIntake = 0,
        teleopIntakeMissed = 0,
        //rapid react actions
        teleopLowerScored = 0,
        teleopUpperScored = 0,
        teleopGroundIntake = 0,
        teleopTerminalIntake = 0,
        teleopLowerMissed = 0,
        teleopUpperMissed = 0,
        teleopTerminalIntakeMissed = 0,
        teleopGroundIntakeMissed = 0;
    int shotsPrev = 0, intakesPrev = 0, pushes = 0;
    int foulRegs = 0,
        foulTechs = 0,
        foulYellows = 0,
        foulReds = 0,
        foulDisableds = 0,
        foulDisqualifieds = 0;

    for (GameAction a in actions) {
      //happened during auton
      //TODO: Change this
      if (a.timeStamp <= GameConstants.autonMillisecondLength) {
        if (a.actionType == ActionType.SHOT_LOWER) {
          autonLowerScored++;
        } else if (a.actionType == ActionType.SHOT_UPPER) {
          autonUpperScored++;
        } else if (a.actionType == ActionType.MISSED_LOWER) {
          autonLowerMissed++;
        } else if (a.actionType == ActionType.MISSED_UPPER) {
          autonUpperMissed++;
        } else if (a.actionType == ActionType.TERMINAL_INTAKE) {
          autonTerminalIntake++;
        } else if (a.actionType == ActionType.GROUND_INTAKE) {
          autonGroundIntake++;
        } else if (a.actionType == ActionType.MISSED_TERMINAL_INTAKE) {
          autonTerminalIntake++;
        } else if (a.actionType == ActionType.MISSED_GROUND_INTAKE) {
          autonTerminalIntakeMissed++;
        }
      }

      //happened during teleop
      else {
        if (a.actionType == ActionType.SHOT_LOWER) {
          teleopLowerScored++;
        } else if (a.actionType == ActionType.SHOT_UPPER) {
          teleopUpperScored++;
        } else if (a.actionType == ActionType.MISSED_LOWER) {
          teleopLowerMissed++;
        } else if (a.actionType == ActionType.MISSED_UPPER) {
          teleopUpperMissed++;
        } else if (a.actionType == ActionType.GROUND_INTAKE) {
          teleopGroundIntake++;
        } else if (a.actionType == ActionType.TERMINAL_INTAKE) {
          teleopTerminalIntake++;
        } else if (a.actionType == ActionType.MISSED_GROUND_INTAKE) {
          teleopGroundIntakeMissed++;
        } else if (a.actionType == ActionType.MISSED_TERMINAL_INTAKE) {
          teleopTerminalIntakeMissed++;
        }
      }

      //defense
      if (a.actionType == ActionType.PREV_SHOT) {
        shotsPrev++;
      } else if (a.actionType == ActionType.PREV_INTAKE) {
        intakesPrev++;
      } else if (a.actionType == ActionType.PUSH_START) {
        pushes++;
      }

      //fouls
      if (a.actionType == ActionType.FOUL_REG) {
        foulReds++;
      } else if (a.actionType == ActionType.FOUL_TECH) {
        foulTechs++;
      } else if (a.actionType == ActionType.FOUL_YELLOW) {
        foulYellows++;
      } else if (a.actionType == ActionType.FOUL_RED) {
        foulReds++;
      } else if (a.actionType == ActionType.FOUL_DISABLED) {
        foulDisableds++;
      } else if (a.actionType == ActionType.FOUL_DISQUAL) {
        foulDisqualifieds++;
      }

      //other actions, mainly booleans
      if (a.actionType == ActionType.CROSSED_TARMAC) {
        crossedTarmac = true;
      } else if (a.actionType == ActionType.OTHER_WHEEL_POSITION) {
        wheelPosition = true;
      } else if (a.actionType == ActionType.OTHER_WHEEL_ROTATION) {
        wheelRotation = true;
        // } else if (a.actionType == ActionType.OTHER_CLIMB) {
        //   climbed = true;
        // } else if (a.actionType == ActionType.OTHER_CLIMB_MISS) {
        //   climbMissed = true;
      } else if (a.actionType == ActionType.LOW_RUNG_CLIMB) {
        climbedLow = true;
      } else if (a.actionType == ActionType.MID_RUNG_CLIMB) {
        climbedMid = true;
      } else if (a.actionType == ActionType.HIGH_RUNG_CLIMB) {
        climbedHigh = true;
      } else if (a.actionType == ActionType.TRAVERSAL_RUNG_CLIMB) {
        climbedTraversal = true;
      } else if (a.actionType == ActionType.OTHER_PARKED) {
        climbParked = true;
      } else if (a.actionType == ActionType.OTHER_LEVELLED) {
        climbLevelled = true;
      }
    }
    //add all filled variables to string and return
    //(team != null ? team.teamNumber : "")

    //TODO: Change this
    result = "AUTON:" +
        "\n Crossed Tarmac: " +
        crossedTarmac.toString() +
        "\n Lower Hub Shots Scored: " +
        autonLowerScored.toString() +
        "\n Upper Hub Shots Scored: " +
        autonUpperScored.toString() +
        "\n Lower Hub Shots Missed: " +
        autonLowerMissed.toString() +
        "\n Upper Hub Shots Missed: " +
        autonUpperMissed.toString() +
        "\n Missed Ground Intakes: " +
        autonGroundIntakeMissed.toString() +
        "\n Terminal Intakes: " +
        autonTerminalIntake.toString() +
        "\n Missed Ground Intakes: " +
        autonGroundIntakeMissed.toString() +
        "\n Missed Terminal Intakes: " +
        autonTerminalIntakeMissed.toString() +
        "\n\n TELEOP:" +
        "\n Lower Hub Shots Scored: " +
        teleopLowerScored.toString() +
        "\n Upper Hub Shots Scored: " +
        teleopUpperScored.toString() +
        "\n Lower Hub Shots Missed: " +
        teleopLowerMissed.toString() +
        "\n Upper Shots Missed: " +
        teleopUpperMissed.toString() +
        "\n Ground Intakes: " +
        teleopGroundIntake.toString() +
        "\n Missed Ground Intakes: " +
        teleopGroundIntakeMissed.toString() +
        "\n Terminal Intakes: " +
        teleopTerminalIntake.toString() +
        "\n Missed Terminal Intakes: " +
        teleopTerminalIntakeMissed.toString() +
        "\n Wheel Position: " +
        wheelPosition.toString() +
        "\n Wheel Rotation: " +
        wheelRotation.toString() +
        "\n\n DEFENSE:" +
        "\n Shots Prevented: " +
        shotsPrev.toString() +
        "\n Intakes Prevented: " +
        intakesPrev.toString() +
        "\n Pushes: " +
        pushes.toString() +
        "\n\n ENDGAME:" +
        "\n Parked: " +
        climbParked.toString() +
        "\n Low Rung CLimb: " +
        climbedLow.toString() +
        "\n Mid Rung CLimb: " +
        climbedMid.toString() +
        "\n High Rung CLimb: " +
        climbedHigh.toString() +
        "\n Traversal Rung CLimb: " +
        climbedTraversal.toString() +
        "\n Climb Missed: " +
        climbMissed.toString() +
        "\n Levelled: " +
        climbLevelled.toString() +
        "\n\n FOULS:" +
        "\n Regular Fouls: " +
        foulRegs.toString() +
        "\n Tech Fouls: " +
        foulTechs.toString() +
        "\n Yellow Fouls: " +
        foulYellows.toString() +
        "\n Red Fouls: " +
        foulReds.toString() +
        "\n Disabled Fouls: " +
        foulDisableds.toString() +
        "\n Disqualified Fouls: " +
        foulDisqualifieds.toString();

    return result;
  }

  String getReport() {
    if (!_initialized || _allMatches.length == 0) {
      return "No analysis available";
    }
    _clearAllData();
    _collectData();

    // if (_allMatches.length > _oldAllMatchLength) {
    //   _oldAllMatchLength = _allMatches.length;
    //   //need to reset everything to 0 (simpler than checking what parts need to be updated)
    //   _clearAllData();
    //   _collectData();
    // }

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

    return "Shooting points/game: " +
        _shootingPtsPerGame.toString() +
        "\nNon-shooting points/game: " +
        _nonShootingsPtsPerGame.toString() +
        "\nClimb Accuracy: " +
        _climbAccuracy.toString() +
        "%\n    Shot Accuracy: " +
        _shotAccuracy.toString() +
        "%\nPoints prevented/game: " +
        _ptsPreventedPerGame.toString() +
        "\n" +
        fouls;
  }

  //TODO: Change this
  void _collectData() {
    _totalNumGames = _allMatches.length;
    //goes thru all matches
    for (int i = 0; i < _totalNumGames; i++) {
      Match _currentMatch = _allMatches[i];

      List<GameAction> actions = _currentMatch.actions;

      //rapid react actions
      _shotLowerHub.addAll(actions
          .where((element) => element.actionType == ActionType.SHOT_LOWER));
      _shotUpperHub.addAll(actions
          .where((element) => element.actionType == ActionType.SHOT_UPPER));
      _missedLowerHub.addAll(actions
          .where((element) => element.actionType == ActionType.MISSED_LOWER));
      _missedUpperHub.addAll(actions
          .where((element) => element.actionType == ActionType.MISSED_LOWER));
      _terminalIntake.addAll(actions.where(
          (element) => element.actionType == ActionType.TERMINAL_INTAKE));
      _missedTerminalIntake.addAll(actions.where((element) =>
          element.actionType == ActionType.MISSED_TERMINAL_INTAKE));
      _groundIntake.addAll(actions.where(
          (element) => element.actionType == ActionType.TERMINAL_INTAKE));
      _missGroundIntake.addAll(actions.where(
          (element) => element.actionType == ActionType.MISSED_GROUND_INTAKE));
      _climbLowRung.addAll(actions
          .where((element) => element.actionType == ActionType.LOW_RUNG_CLIMB));
      _climbMidRung.addAll(actions
          .where((element) => element.actionType == ActionType.MID_RUNG_CLIMB));
      _climbHighRung.addAll(actions.where(
          (element) => element.actionType == ActionType.HIGH_RUNG_CLIMB));
      _climbTraversalRung.addAll(actions.where(
          (element) => element.actionType == ActionType.TRAVERSAL_RUNG_CLIMB));

      _foulReg.addAll(actions
          .where((element) => element.actionType == ActionType.FOUL_REG));
      _foulTech.addAll(actions
          .where((element) => element.actionType == ActionType.FOUL_TECH));
      _foulYellow.addAll(actions
          .where((element) => element.actionType == ActionType.FOUL_YELLOW));
      _foulRed.addAll(actions
          .where((element) => element.actionType == ActionType.FOUL_RED));
      _foulDisabled.addAll(actions
          .where((element) => element.actionType == ActionType.FOUL_DISABLED));
      _foulDisqual.addAll(actions
          .where((element) => element.actionType == ActionType.FOUL_DISQUAL));
      _shotInner.addAll(actions
          .where((element) => element.actionType == ActionType.SHOT_INNER));
      _shotOuter.addAll(actions
          .where((element) => element.actionType == ActionType.SHOT_OUTER));
      _shotLow.addAll(actions
          .where((element) => element.actionType == ActionType.SHOT_LOW));
      _missedLow.addAll(actions
          .where((element) => element.actionType == ActionType.MISSED_LOW));
      _missedOuter.addAll(actions
          .where((element) => element.actionType == ActionType.MISSED_OUTER));
      _otherClimb.addAll(actions
          .where((element) => element.actionType == ActionType.OTHER_CLIMB));
      _otherClimbMiss.addAll(actions.where(
          (element) => element.actionType == ActionType.OTHER_CLIMB_MISS));
      _otherWheelRotation.addAll(actions.where(
          (element) => element.actionType == ActionType.OTHER_WHEEL_ROTATION));
      _otherWheelPosition.addAll(actions.where(
          (element) => element.actionType == ActionType.OTHER_WHEEL_POSITION));
      _prevIntake.addAll(actions
          .where((element) => element.actionType == ActionType.PREV_INTAKE));
      _prevShot.addAll(actions
          .where((element) => element.actionType == ActionType.PREV_SHOT));
      _pushStart.addAll(actions
          .where((element) => element.actionType == ActionType.PUSH_START));
      _pushEnd.addAll(actions
          .where((element) => element.actionType == ActionType.PUSH_END));
      _otherCrossedInitiationLine.addAll(actions
          .where((element) => element.actionType == ActionType.CROSSED_TARMAC));
      _otherParked.addAll(actions
          .where((element) => element.actionType == ActionType.OTHER_PARKED));
      _otherLevelled.addAll(actions
          .where((element) => element.actionType == ActionType.OTHER_LEVELLED));
    }
  }

  //TODO: Change this
  //used when more data is added, need to clear everything then re-add
  void _clearAllData() {
    //rapid react actions
    _shotLowerHub = [];
    _shotUpperHub = [];
    _missedLowerHub = [];
    _missedUpperHub = [];
    _terminalIntake = [];
    _missedTerminalIntake = [];
    _groundIntake = [];
    _missGroundIntake = [];
    _climbLowRung = [];
    _climbMidRung = [];
    _climbHighRung = [];
    _climbTraversalRung = [];

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

  //TODO: Change this
  double calcOffenseShootingPts() {
    // double _lowPts = 0.0, _outerPts = 0.0, _innerPts = 0.0;
    // for (int i = 0; i < _shotLow.length; i++) {
    //   if (_shotLow[i].timeStamp <= GameConstants.autonMillisecondLength) {
    //     _lowPts += GameConstants.lowShotAutonValue;
    //   } else {
    //     _lowPts += GameConstants.lowShotValue;
    //   }
    // }

    // for (int i = 0; i < _shotOuter.length; i++) {
    //   if (_shotOuter[i].timeStamp <= GameConstants.autonMillisecondLength) {
    //     _outerPts += GameConstants.outerShotAutonValue;
    //   } else {
    //     _outerPts += GameConstants.outerShotValue;
    //   }
    // }

    // for (int i = 0; i < _shotInner.length; i++) {
    //   if (_shotInner[i].timeStamp <= GameConstants.autonMillisecondLength) {
    //     _innerPts += GameConstants.innerShotAutonValue;
    //   } else {
    //     _innerPts += GameConstants.innerShotValue;
    //   }
    // }
    // return _lowPts + _outerPts + _innerPts;
    double _lowerPts = 0.0, _upperPts = 0.0;

    //calculates lower hub points
    for (int i = 0; i < _shotLowerHub.length; i++) {
      if (_shotLowerHub[i].timeStamp <= GameConstants.autonMillisecondLength) {
        _lowerPts += GameConstants.lowerHubShotAutonValue;
      } else {
        _lowerPts += GameConstants.lowerHubValue;
      }
    }
    //calculates upper hub points
    for (int i = 0; i < _shotUpperHub.length; i++) {
      if (_shotUpperHub[i].timeStamp <= GameConstants.autonMillisecondLength) {
        _upperPts += GameConstants.upperHubShotAutonValue;
      } else {
        _upperPts += GameConstants.upperHubValue;
      }
    }

    return _lowerPts + _upperPts;
  }

  double calcOffenseNonShootingPts() {
    double _crossInitiation = _otherCrossedInitiationLine.length *
        GameConstants.crossInitiationLineValue;
    double _rotationControl =
        _otherWheelRotation.length * GameConstants.positionControl;
    double _positionControl =
        _otherWheelPosition.length * GameConstants.positionControl;
    double _climb = (_otherClimb.length * GameConstants.climbValue) +
        (_otherParked.length * GameConstants.endgameParkValue) +
        (_otherLevelled.length * GameConstants.levelledValue);

    return _crossInitiation + _rotationControl + _positionControl + _climb;
  }

  double calcShotAccuracy() {
    // int _successfulShots =
    //     _shotLowerHub.length + _shotOuter.length + _shotInner.length;
    // int _missedShots = _missedLow.length + _missedOuter.length;
    // if (_successfulShots + _missedShots != 0) {
    //   return (_successfulShots / (_successfulShots + _missedShots)) * 100.0;
    // } else {
    //   return 0;
    // }
    int _successfulShots = _shotLowerHub.length + _shotUpperHub.length;
    int _missedShots = _missedLowerHub.length + _missedUpperHub.length;

    if (_successfulShots + _missedShots != 0) {
      return (_successfulShots / (_successfulShots + _missedShots)) * 100;
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
    return _prevShot.length * GameConstants.shotValue;
  }

  double calcIntakePtsPrev() {
    return _prevIntake.length * GameConstants.intakeValue;
  }

  double getBallsInBot(String matchNum, double timeStamp) {
    double ballsInBot = 0;
    List<GameAction> matchActions = getMatch(matchNum);

    if (matchActions == null) {
      return 0;
    }

    for (int b = 0; b < matchActions.length; b++) {
      //add intaked balls\
      //TODO: Intake
      if ((matchActions[b].actionType == ActionType.GROUND_INTAKE ||
              matchActions[b].actionType == ActionType.TERMINAL_INTAKE) &&
          matchActions[b].timeStamp <= timeStamp) {
        ballsInBot++;
      }

      //remove balls that were shot
      if (matchActions[b].actionType == ActionType.SHOT_LOWER ||
          matchActions[b].actionType == ActionType.SHOT_UPPER) {
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
        if (actions[a].actionType == ActionType.PUSH_START) {
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
    double zoneDisplacementValue = GameConstants.zoneDisplacementValue;
    zoneDisplacementValue *= (ballsInBot /
        GameConstants.maxBallsInBot); //take balls in bot into account
    zoneDisplacementValue *= calcShotAccuracy() /
        100.0; //take shot accuracy into account, worth more if higher value

    double _result = 0.0;
    //set speed
    double _normalVelocity = 0.0;

    if (_driveBase == DriveBaseType.TANK) {
      _normalVelocity = RobotConstants.tankSpeed;
    }
    if (_driveBase == DriveBaseType.OMNI) {
      _normalVelocity = RobotConstants.omniSpeed;
    }
    if (_driveBase == DriveBaseType.WESTCOAST) {
      _normalVelocity = RobotConstants.westCoastSpeed;
    }
    if (_driveBase == DriveBaseType.MECANUM) {
      _normalVelocity = RobotConstants.mecanumSpeed;
    }
    if (_driveBase == DriveBaseType.SWERVE) {
      _normalVelocity = RobotConstants.swerveSpeed;
    }

    var _actualDisplacement =
        calcDisplacement(pushStart.x, pushStart.y, pushEnd.x, pushEnd.y);
    var _pushTimeSeconds = (pushEnd.timeStamp - pushStart.timeStamp) / 1000.0;
    var _predictedDisplacement = _normalVelocity * _pushTimeSeconds;
    var _zoneDisplacementDifference =
        (_predictedDisplacement - _actualDisplacement) /
            GameConstants.zoneSideLength;
    _result += (_zoneDisplacementDifference * zoneDisplacementValue);

    return _result;
  }

  //returns neg value if displaced in opp direction, positive if displaced in aBot's intended direction
  double calcDisplacement(double x, double y, double endX, double endY) {
    var _columnDisplacement = (endX - x) * GameConstants.zoneSideLength;
    var _rowDisplacement = (endY - y) * GameConstants.zoneSideLength;
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
    return (_foulReg.length * GameConstants.regFoul) +
        (_foulTech.length * GameConstants.techFoul) +
        (_foulYellow.length * GameConstants.techFoul) +
        (_foulRed.length * GameConstants.redCard);
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
          if (currentAction.actionType == ActionType.SHOT_LOWER ||
              currentAction.actionType == ActionType.SHOT_UPPER) {
            if (currentAction.x == x && currentAction.y == y) {
              shotsMade++;
            }
          }

          if (currentAction.actionType == ActionType.MISSED_LOWER ||
              currentAction.actionType == ActionType.MISSED_UPPER) {
            if (currentAction.x == x && currentAction.y == y) {
              shotsMissed++;
            }
          }
        }
      }
    } else {
      ActionType missedVersionOfAction;
      //cannot miss a inner shot, accuracy is 100%
      //TODO:
      if (actionType == ActionType.SHOT_INNER) {
        for (int i = 0; i < _allMatches.length; i++) {
          //inside each array of actions
          for (int j = 0; j < _allMatches[i].actions.length; j++) {
            GameAction currentAction = _allMatches[i].actions[j];
            if (currentAction.actionType == actionType) {
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
      if (actionType == ActionType.SHOT_UPPER) {
        missedVersionOfAction = ActionType.MISSED_UPPER;
      }

      if (actionType == ActionType.SHOT_LOWER) {
        missedVersionOfAction = ActionType.MISSED_LOWER;
      }

      for (int i = 0; i < _allMatches.length; i++) {
        //inside each array of actions
        for (int j = 0; j < _allMatches[i].actions.length; j++) {
          GameAction currentAction = _allMatches[i].actions[j];
          if (currentAction.actionType == actionType) {
            if (currentAction.x == x && currentAction.y == y) {
              shotsMade++;
            }
          }

          if (currentAction.actionType == missedVersionOfAction) {
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
  //TODO:
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

          //upper shot
          if (currentAction.actionType == ActionType.SHOT_UPPER) {
            if (currentAction.x == x && currentAction.y == y) {
              if (currentAction.timeStamp <= GameConstants.teleopStartMillis) {
                totalPoints += GameConstants.upperHubShotAutonValue;
              } else {
                totalPoints += GameConstants.upperHubValue;
              }
            }
          }

          //inner shot
          if (currentAction.actionType == ActionType.SHOT_LOWER) {
            if (currentAction.x == x && currentAction.y == y) {
              if (currentAction.timeStamp <= GameConstants.teleopStartMillis) {
                totalPoints += GameConstants.lowerHubShotAutonValue;
              } else {
                totalPoints += GameConstants.lowerHubValue;
              }
            }
          }
        }
      }
    } else {
      if (actionType == ActionType.SHOT_LOWER) {
        pointValueAuton = GameConstants.lowerHubShotAutonValue;
        pointValueTeleop = GameConstants.lowerHubValue;
      }
      if (actionType == ActionType.SHOT_UPPER) {
        pointValueAuton = GameConstants.upperHubShotAutonValue;
        pointValueTeleop = GameConstants.upperHubValue;
      }

      for (int i = 0; i < _allMatches.length; i++) {
        //inside each array of actions
        for (int j = 0; j < _allMatches[i].actions.length; j++) {
          GameAction currentAction = _allMatches[i].actions[j];
          if (currentAction.actionType == actionType) {
            if (currentAction.x == x && currentAction.y == y) {
              if (currentAction.timeStamp <= GameConstants.teleopStartMillis) {
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
    int largestColumnNum = GameConstants.zoneColumns - 1;
    int largestRowNum = GameConstants.zoneRows - 1;

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
