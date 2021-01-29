import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mustang_app/components/game_action.dart';
import '../backend/team_data_analyzer.dart';

import 'package:mustang_app/constants/constants.dart';

class Analyzer extends StatefulWidget {
  String _teamNum;

  Analyzer(String teamNum) {
    _teamNum = teamNum;
  }
  @override
  State<StatefulWidget> createState() {
    return _AnalyzerState(_teamNum,);
  }
}

class _AnalyzerState extends State<Analyzer> {
  bool _initialized = false, _hasAnalysis = true;
  String _teamNum, _driveBase;
  //double _totalDefActionTime, _totalQualGameTime;
  
  var _allMatches;
  //for testing if data needs to be collected again or not - if same then don't
  int _oldAllMatchLength = 0, _totalNumGames = 0;
  //array for each type of action, has all instances of that action for all games
  //FOR NOW ONLY ARRAY LENGTH OF EACH IS USEFUL BUT AFTER FOR LIKE COMMON ZONE AND TIMES N STUFF
  List<GameAction> _foul_reg = [], _foul_tech = [], _foul_yellow = [], _foul_red = [], _foul_disabled = [], _foul_disqual = [],
      _shot_low = [], _shot_outer = [], _shot_inner = [], _missed_low = [], _missed_outer = [],
      _other_climb = [], _other_climb_miss = [], _other_wheel_position = [], _other_wheel_color = [],
      _prev_shot = [], _prev_intake = [], _push = [];

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

      var action1 = new GameAction(ActionType.FOUL_REG, 2, 3, 4);
      var action1a = new GameAction(ActionType.FOUL_TECH, 2, 4, 4);
      var action2 = new GameAction(ActionType.SHOT_INNER, 6, 15, 1);
      var action3 = new GameAction(ActionType.PREV_SHOT, 10, 13, 9);
      var action4 = new GameAction(ActionType.MISSED_OUTER, 15, 2, 4);
      var action4a = new GameAction(ActionType.MISSED_OUTER, 16, 1, 4);
      var action5 = new GameAction(ActionType.OTHER_CLIMB_MISS, 19, 3, 3);
      var action6 = new GameAction(ActionType.SHOT_LOW, 30, 0, 13);
      var action7 = new GameAction(ActionType.SHOT_INNER, 39, 5, 2);
      var action8 = new GameAction(ActionType.SHOT_OUTER, 40, 8, 12);
      var action9 = new GameAction.push(ActionType.PUSH, 44, 10, 5, 8, 4, 3);

      var matchArray1 = [action1, action1a, action2, action3];
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
    if (_allMatches.length > _oldAllMatchLength){
      _oldAllMatchLength = _allMatches.length;
      //need to reset everything to 0 (simpler than checking what parts need to be updated)
      _clearAllData();
      _collectData();
    }

    
    //new
    String fouls = "";
    if (_foul_reg.length > 0){
      fouls += "Reg Fouls: " + _foul_reg.length.toString();
    }
    if (_foul_tech.length > 0){
      fouls += " Tech Fouls: " + _foul_tech.length.toString();
    }
    if (_foul_yellow.length > 0){
      fouls += " Yellow Fouls: " + _foul_yellow.length.toString();
    }
    if (_foul_red.length > 0){
      fouls += " Red Fouls: " + _foul_red.length.toString();
    }
    if (_foul_disabled.length > 0){
      fouls += " Disabled Fouls: " + _foul_disabled.length.toString();
    }
    if (_foul_disqual.length > 0){
      fouls += " Disqual Fouls: " + _foul_disqual.length.toString();
    }

    return "Team: " + _teamNum
    + "\nTotal Offense Shooting Points: " + calcTotOffenseShootingPts().round().toString()
    + "\nOverall Climb Accuracy: " + calcTotClimbAccuracy().round().toString() + "%"
    + "\nTotal points prevented: " + calcTotPtsPrev().round().toString()
    + "\n" + fouls;
  }

  void _collectData(){
    _totalNumGames = _allMatches.length;
    //goes thru all matches
    for (int i = 0; i < _totalNumGames; i++){
      var _currentMatch = _allMatches.elementAt(i);
        //goes thru each action in the match
       for (int j = 0; j < _currentMatch.length; j++){
        GameAction _currentGameAction = _currentMatch[j];
        ActionType _currentAction = _currentGameAction.action;

        //fill up each array of actions
         switch (_currentAction){
          case ActionType.FOUL_REG: {_foul_reg.add(_currentGameAction);}
            break;
           case ActionType.FOUL_TECH: {_foul_tech.add(_currentGameAction);             }
             break;
           case ActionType.FOUL_YELLOW: {_foul_yellow.add(_currentGameAction);}
             break;
           case ActionType.FOUL_RED: {_foul_red.add(_currentGameAction);}
             break;
           case ActionType.FOUL_DISABLED: {_foul_disabled.add(_currentGameAction);}
             break;
           case ActionType.FOUL_DISQUAL: {_foul_disqual.add(_currentGameAction);}
             break;
           case ActionType.SHOT_LOW: {_shot_low.add(_currentGameAction);}
             break;
           case ActionType.SHOT_OUTER: {_shot_outer.add(_currentGameAction);}
             break;
           case ActionType.SHOT_INNER: {_shot_inner.add(_currentGameAction);}
             break;
           case ActionType.MISSED_LOW: {_missed_low.add(_currentGameAction);}
             break;
           case ActionType.MISSED_OUTER: {_missed_outer.add(_currentGameAction);}
             break;
           case ActionType.OTHER_CLIMB: {_other_climb.add(_currentGameAction);}
             break;
           case ActionType.OTHER_CLIMB_MISS: {_other_climb_miss.add(_currentGameAction);}
             break;
           case ActionType.OTHER_WHEEL_POSITION: {_other_wheel_position.add(_currentGameAction);}
             break;
           case ActionType.OTHER_WHEEL_COLOR: {_other_wheel_color.add(_currentGameAction);}
             break;
           case ActionType.PREV_SHOT: {_prev_shot.add(_currentGameAction);}
             break;
           case ActionType.PREV_INTAKE: {_prev_intake.add(_currentGameAction);}
             break;
           case ActionType.PUSH: {_push.add(_currentGameAction);}
             break;
         }
       }
     }
  }

  //used when more data is added, need to clear everything then re-add
  void _clearAllData(){
    _foul_reg = [];
    _foul_tech = [];
    _foul_yellow = [];
    _foul_red = [];
    _foul_disabled = [];
    _foul_disqual = [];
    _shot_low = [];
    _shot_outer = [];
    _shot_inner = [];
    _missed_low = [];
    _missed_outer = [];
    _other_climb = [];
    _other_climb_miss = [];
    _other_wheel_position = [];
    _other_wheel_color = [];
    _prev_shot = [];
    _prev_intake = [];
    _push = [];
  }

  double calcTotOffenseShootingPts(){
    //TODO: HIGHER PTS FOR AUTON (time <= 15 sec)
    double _lowPts = _shot_low.length*Constants.lowShotValue;
    double _outerPts = _shot_outer.length*Constants.outerShotValue;
    double _innerPts = _shot_inner.length*Constants.innerShotValue;
    double _rotationControl = _other_wheel_color.length*Constants.positionControl;
    double _positionControl = _other_wheel_position.length*Constants.positionControl;
    double _climb = _other_climb.length*Constants.climbValue;
    
    return _lowPts + _outerPts + _innerPts + _rotationControl + _positionControl + _climb;
  }

  double calcTotClimbAccuracy(){
    double _climb = _other_climb.length*1.0;
    double _miss = _other_climb_miss.length*1.0;
    double _totalClimbAttempts = _climb + _miss;

    return (_climb/_totalClimbAttempts)*100.0;
  }

  double calcTotPtsPrev(){
    return calcShotPtsPrev() + calcIntakePtsPrev() + calcPushPtsPrev() - calcFoulLostPts();
  }
  double calcShotPtsPrev(){
    return _prev_shot.length*Constants.shotValue;
  }
  double calcIntakePtsPrev(){
    return _prev_intake.length*Constants.intakeValue;
  }

  double calcPushPtsPrev(){
    double _result = 0.0;
    //set speed
    double _normalVelocity = 0.0;
    if (_driveBase.contains("tank")){ _normalVelocity = Constants.tankSpeed; }
    if (_driveBase.contains("omni")){ _normalVelocity = Constants.omniSpeed; }
    if (_driveBase.contains("westCoast")){ _normalVelocity = Constants.westCoastSpeed; }
    if (_driveBase.contains("mecanum")){ _normalVelocity = Constants.mecanumSpeed; }
    if (_driveBase.contains("swerve")){ _normalVelocity = Constants.swerveSpeed; }

    for (int i = 0; i < _push.length; i++){
      var _predictedDisplacement = _normalVelocity * _push[i].pushTime;
      var _actualDisplacement = calcDisplacement(_push[i].x, _push[i].y, _push[i].endX, _push[i].endY);
      var _zoneDisplacementDifference = (_predictedDisplacement - _actualDisplacement)/Constants.zoneSideLength;
      
      _result += (_zoneDisplacementDifference * Constants.zoneDisplacementValue);

    }
    return _result;
  }

  //returns neg value if displaced in opp direction, positive if displaced in aBot's intended direction
  //returned in feet
  double calcDisplacement(double x, double y, double endX, double endY){
    var _columnDisplacement = (endX - x)*Constants.zoneSideLength;
    var _rowDisplacement = (endY - y)*Constants.zoneSideLength;
    //"hypotenuse" of column and row displacement
    var _displacement = pow(pow(_columnDisplacement, 2) + pow(_rowDisplacement, 2), 1/2);
    
    //went backwards, make displacement negative
    if (endX - x < 0){
      _displacement *= -1;
    }
    return _displacement;
  }

  //returns a positive number, must subtract from total
  double calcFoulLostPts(){
    double _regPtsLost = _foul_reg.length*Constants.regFoul;
    double _techPtsLost = _foul_tech.length*Constants.techFoul;
    double _yellowPtsLost = _foul_yellow.length*Constants.techFoul;
    double _redPtsLost = _foul_red.length*Constants.redCard;
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
}