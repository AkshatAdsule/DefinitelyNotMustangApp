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
    setState(() {
      //random values for now just to test
      _driveBase = "tank";
      _numShotsPrev = 10;
      _numIntakesPrev = 5;
      _totalDefActionTime = 120;
      _totalQualGameTime = 600; //4 games
      _fouls = {"regFouls":3, "techFouls":2, "yellowCards":1, "redCards":0};

      _pushStartZones = {10:4, 6:6};
      _pushEndZones = {6:2, 5:4};

      //_pushTime = {2, 3, 1, 4};
      //for some reason I need to do it this way idk why either man
      _pushTime = new List(2);
      _pushTime[0] = 2;
      _pushTime[1] = 3;
      //_pushTime[2] = 1;
      //_pushTime[3] = 4;

      _initialized = true;
    });
  }

  String getReport() {
    double _totPtsPrev = calcTotPtsPrev();
    //_totPtsPrev = _totPtsPrev.round() as int;
    double _ptsPrevOverDefTime = calcTotPtsPrev()/_totalDefActionTime;
    double _percentTimeInDefense = 100*(_totalDefActionTime/_totalQualGameTime);
    double _percentTimeInOffense = 100 - _percentTimeInDefense;
    double _regFouls = _fouls["regFouls"];
    double _techFouls = _fouls["techFouls"];
    double _yellowCards = _fouls["yellowCards"];
    double _redCards = _fouls["redCards"];
    var actionTest;
    actionTest = new GameAction(ActionType.FOUL_REG, 2, 3, 4);
    //action.Action( action: action.ActionType.FOUL_REG, seconds_elapsed: 2, row: 3, column: 4);

    return "Team: " + _teamNum
    + "\n action" + actionTest.seconds_elapsed.toString()
    + "\nTotal points prevented: " + _totPtsPrev.toStringAsFixed(1).toString()
    + "\nPoints prevented/sec: " + _ptsPrevOverDefTime.toStringAsFixed(3)
    + "\n% time in defense: " + _percentTimeInDefense.toString() 
    + "%, offense: " + _percentTimeInOffense.toString()
    
     + "%\nTotal reg fouls: " + _regFouls.round().toString()
    + ", tech: " + _techFouls.round().toString()
    + ", yellow: " + _yellowCards.round().toString()
    + ", red: " + _redCards.round().toString();
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
      debugPrint("smth here: " +  _result.toString());
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
