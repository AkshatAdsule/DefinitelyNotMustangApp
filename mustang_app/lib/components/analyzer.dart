import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mustang_app/components/game_action.dart';
import '../backend/team_data_analyzer.dart';

import 'package:mustang_app/constants/constants.dart';

class Analyzer extends StatefulWidget {
  String _teamNum, _driveBase;

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
  double _numShotsPrev, _numIntakesPrev, _totalDefActionTime, _totalQualGameTime;
  var _pushTime;
  Map<String, double> _fouls;
  Map<double, double> _pushStartZones, _pushEndZones; //<columnNum, rowNum>

  var allMatches;
  //array for each type of action, has all instances of that action for all games
  //FOR NOW ONLY ARRAY LENGTH OF EACH IS USEFUL BUT AFTER FOR LIKE COMMON ZONE AND TIMES N STUFF
  List<ActionType> foul_reg = [], foul_tech = [], foul_yellow = [], foul_red = [], foul_disabled = [], foul_disqual = [],
      shot_low = [], show_outer = [], shot_inner = [], missed_low = [], missed_outer = [],
      other_climb = [], other_climb_miss = [], other_wheel_position = [], other_wheel_color = [],
      prev_shot = [], prev_intake = [], push = [];



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
    // setState(() {
    _hasAnalysis = TeamDataAnalyzer.getTeamDoc(_teamNum)['hasAnalysis'];
    // });
    if (!_hasAnalysis) {
      return;
    }
    //initialize all vars
    //setState(() {
      //random values for now just to test
      var action1 = new GameAction(ActionType.FOUL_REG, 2, 3, 4);
      var action2 = new GameAction(ActionType.SHOT_INNER, 6, 15, 1);
      var action3 = new GameAction(ActionType.PREV_SHOT, 10, 13, 9);
      var action4 = new GameAction(ActionType.MISSED_OUTER, 15, 2, 4);
      var action5 = new GameAction(ActionType.OTHER_CLIMB_MISS, 9, 3, 3);
      var action6 = new GameAction(ActionType.SHOT_LOW, 30, 0, 13);
      var action7 = new GameAction(ActionType.SHOT_INNER, 39, 5, 2);
      var action8 = new GameAction(ActionType.SHOT_OUTER, 40, 8, 12);
      var action9 = new GameAction.push(44, 10, 5, 8, 4, 3);

      var matchArray1 = [action1, action2, action3];
      var matchArray2 = [action4, action5, action6];
      var matchArray3 = [action7, action8, action9];

      //FINALARRAY IS WHAT WILL BE PASSED INTO THE ANALYZER
      var finalArray = [matchArray1, matchArray2, matchArray3];     
      allMatches = finalArray;
      //_collectData();

      _driveBase = "tank";

      //EVERYTHING UNDER SHOULD BE GONE
      _numShotsPrev = 10;
      _numIntakesPrev = 5;
      _totalDefActionTime = 120;
      _totalQualGameTime = 600; //4 games
      _fouls = {"regFouls":3, "techFouls":2, "yellowCards":1, "redCards":0};

      _pushStartZones = {10:4, 6:6};
      _pushEndZones = {6:2, 5:4};

      _pushTime = new List(2);
      _pushTime[0] = 2;
      _pushTime[1] = 3;

      _initialized = true;
    //});
  }

  String getReport() {
    _collectData();
    double _totPtsPrev = calcTotPtsPrev();
    //_totPtsPrev = _totPtsPrev.round() as int;
    double _ptsPrevOverDefTime = calcTotPtsPrev()/_totalDefActionTime;
    double _percentTimeInDefense = 100*(_totalDefActionTime/_totalQualGameTime);
    double _percentTimeInOffense = 100 - _percentTimeInDefense;
    double _regFouls = _fouls["regFouls"];
    double _techFouls = _fouls["techFouls"];
    double _yellowCards = _fouls["yellowCards"];
    double _redCards = _fouls["redCards"];

    //testing purposes
    //var match2 = allMatches.elementAt(2);
    //var some2match2 = match2.elementAt(2);
    //ActionType action = some2match2.action;

    return "Team: " + _teamNum
    + "\n foul_reg: " + foul_reg.toString()
    //+ "\n action: " + action.toString()
    + "\nTotal points prevented: " + _totPtsPrev.toStringAsFixed(1).toString()
    + "\nPoints prevented/sec: " + _ptsPrevOverDefTime.toStringAsFixed(3)
    + "\n% time in defense: " + _percentTimeInDefense.toString() 
    + "%, offense: " + _percentTimeInOffense.toString()
    
     + "%\nTotal reg fouls: " + _regFouls.round().toString()
    + ", tech: " + _techFouls.round().toString()
    + ", yellow: " + _yellowCards.round().toString()
    + ", red: " + _redCards.round().toString();
  }

  void _collectData(){
    debugPrint("allMatch: " + allMatches.toString());
    //DO I NEED TO RESET ALL ARRAYS TO 0 BC THEN IT JUST KEEPS ON ADDING??
    //LOOK UP!
    //goes thru all matches
    for (int i = 0; i < allMatches.length; i++){
      var currentMatch = allMatches.elementAt(i);
        //goes thru each action in the match
       for (int j = 0; j < currentMatch.length; j++){
        //ActionType currentAction = currentMatch.elementAt(j).action;
        //ActionType currentA = currentMatch[j].action;

        //debugPrint("currentA: " + currentA.toString());

         //debugPrint(currentAction.toString());
         //switch (currentAction){
          //case ActionType.FOUL_REG: {_foul_reg_total++;}
          //break;
         //}
         /*
         if (currentAction == ActionType.FOUL_REG){
           foul_reg.add(currentAction);
         }
*/
       }
     }
     //debugPrint("_foul_reg_total: " + _foul_reg_total.toString());
  }

  void updateData(){

  }


  double calcTotPtsPrev(){
    return calcShotPtsPrev() + calcIntakePtsPrev() + calcPushPtsPrev() - calcFoulLostPts();
  }
  double calcShotPtsPrev(){
    return _numShotsPrev*Constants.shotValue;
  }
  double calcIntakePtsPrev(){
    return _numIntakesPrev*Constants.intakeValue;
  }
  double calcPushPtsPrev(){
    double _result = 0;

    //set speed
    double _normalVelocity;
    if (_driveBase.contains("tank")){ _normalVelocity = Constants.tankSpeed; }
    if (_driveBase.contains("omni")){ _normalVelocity = Constants.omniSpeed; }
    if (_driveBase.contains("westCoast")){ _normalVelocity = Constants.westCoastSpeed; }
    if (_driveBase.contains("mecanum")){ _normalVelocity = Constants.mecanumSpeed; }
    if (_driveBase.contains("swerve")){ _normalVelocity = Constants.swerveSpeed; }

    //only way of accessing it bc they're not in numerical order or anything 
    List _startColumn = _pushStartZones.keys.toList();
    List _startRow = _pushStartZones.values.toList();
    List _endColumn = _pushEndZones.keys.toList();
    List _endRow = _pushEndZones.values.toList();

    //ALL OF THIS IS ASSUMING ABOT WANTS TO GO TOWARDS RED SHOOTING ZONE - ALWAYS WANT TO BE BC SCREEN WILL BE FLIPPED?
    for (var i = 0; i < _pushTime.length; i++){
      var _predictedDisplacement = _normalVelocity * _pushTime[i];
      var _actualDisplacement = calcDisplacement(_startColumn[i], _startRow[i], _endColumn[i], _endRow[i]);
      var _zoneDisplacementDifference = (_predictedDisplacement - _actualDisplacement)/Constants.zoneSideLength;
      
      _result += (_zoneDisplacementDifference * Constants.zoneDisplacementValue);
    }
    return _result;
  }

  //returns neg value if displaced in opp direction, positive if displaced in aBot's intended direction
  //returned in feet
  double calcDisplacement(double startColumn, double startRow, double endColumn, double endRow){
    var _columnDisplacement = (endColumn - startColumn)*Constants.zoneSideLength;
    var _rowDisplacement = (endRow - startRow)*Constants.zoneSideLength;
    //"hypotenuse" of column and row displacement
    var _displacement = pow(pow(_columnDisplacement, 2) + pow(_rowDisplacement, 2), 1/2);
    
    //went backwards, make displacement negative
    if (endColumn - startColumn < 0){
      _displacement *= -1;
    }
    return _displacement;
  }

  //returns a positive number, must subtract from total
  double calcFoulLostPts(){
    double _regPtsLost = _fouls["regFouls"] * Constants.regFoul;
    double _techPtsLost = _fouls["techFouls"] * Constants.techFoul;
    double _yellowPtsLost = _fouls["yellowCards"] * Constants.yellowCard;
    double _redPtsLost = _fouls["redCards"] * Constants.redCard;
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
