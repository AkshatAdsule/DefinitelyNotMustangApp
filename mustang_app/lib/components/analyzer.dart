import 'dart:math';

import 'package:flutter/material.dart';
import '../backend/team_data_analyzer.dart';
import 'package:mustang_app/constants/constants.dart';

class Analyzer extends StatefulWidget {
  String _teamNum;
  Analyzer(String teamNum) {
    _teamNum = teamNum;
  }
  @override
  State<StatefulWidget> createState() {
    return _AnalyzerState(_teamNum);
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
    // setState(() {
    _hasAnalysis = TeamDataAnalyzer.getTeamDoc(_teamNum)['hasAnalysis'];
    // });
    if (!_hasAnalysis) {
      return;
    }
    //initialize all vars
    setState(() {
      //random values for now just to test
      _driveBase = "swerve";
      _numShotsPrev = 10;
      _numIntakesPrev = 5;
      _totalDefActionTime = 120;
      _totalQualGameTime = 600; //4 games
      _fouls = {"regFouls":3, "techFouls":2, "yellowCards":1, "redCards":0};

      _pushStartZones = {10:4};
      _pushEndZones = {6:2};

      //_pushTime = {2, 3, 1, 4};
      //for some reason I need to do it this way idk why either man
      _pushTime = new List(1);
      _pushTime[0] = 2;
      //_pushTime[1] = 3;
      //_pushTime[2] = 1;
      //_pushTime[3] = 4;

      _initialized = true;
    });
  }

  String getReport() {
    double _totPtsPrev = calcTotPtsPrev();
    double _ptsPrevOverDefTime = calcTotPtsPrev()/_totalDefActionTime;
    double _percentTimeInDefense = 100*(_totalDefActionTime/_totalQualGameTime);
    double _percentTimeInOffense = 100 - _percentTimeInDefense;
    double _regFouls = _fouls["regFouls"];
    double _techFouls = _fouls["techFouls"];
    double _yellowCards = _fouls["yellowCards"];
    double _redCards = _fouls["redCards"];

    double _pushPtsPrev = calcPushPtsPrev();
    return "Team: " + _teamNum
    + "\nTotal points prevented: " + _totPtsPrev.toString()
    + "\nPoints prevented/sec: " + _ptsPrevOverDefTime.toString()
    + "\n% time in defense: " + _percentTimeInDefense.toString() + "%, "
    + "% time in offense: " + _percentTimeInOffense.toString() + "%"
    + "\nTotal reg fouls: " + _regFouls.toString()
    + " Total tech fouls: " + _techFouls.toString()
    + "\nTotal yellow cards: " + _yellowCards.toString()
    + " Total red cards: " + _redCards.toString()
    + " \n push pts prev: " + _pushPtsPrev.toString();
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
      var _actualDisplacement = calcDisplacement(_startColumn[i], _startRow[i], _endColumn[i], _endRow[i])
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

//BELOW IS OLD BEACH BLITZ VERSION BUT I DON'T WANT TO MAKE A NEW CLASS 
//BC THEN I HAVE TO UPDATE EVERYTHING IN ALL THE OTHER CLASSES - YES I KNOW REFRACTOR 
//EXISTS BUT STILL *insert passive aggressive smile*
/*
class Analyzer extends StatefulWidget {
  String _teamNum;
  Analyzer(String teamNum) {
    _teamNum = teamNum;
  }
  @override
  State<StatefulWidget> createState() {
    return _AnalyzerState(_teamNum);
  }
}

class _AnalyzerState extends State<Analyzer> {
  bool _initialized = false, _hasAnalysis = true;
  String _teamNum;
  double _noDGames = 0,
      _lightDGames = 0,
      _heavyDGames =
          0; //number of games that team played with NO, LIGHT, or HEAVY defense
  double _noDPts = 0,
      _lightDPts = 0,
      _heavyDPts =
          0; //number of shooting game pieces that went in with NO, LIGHT, or HEAVY defense
  double _ptRankDiff = 0.5,
      _rank = 1,
      _highestRankPossible =
          10; //_ptRankDiff = point difference between an average game to go from 1 rank to the next
  double _noToLightRank = 1,
      _lightToHeavyRank = 1,
      _noPtAvg,
      _lightPtAvg,
      _heavyPtAvg;
  double _zone0Pts,
      _zone1Pts,
      _zone2and3Pts,
      _zone4Pts,
      _zone5Pts,
      _zone6Pts; //regardless of d, total pts scored in all games in each zone

  /*
  Points (_totPts, _noDPts, _lightDPts, _heavyDPts) refers to number of balls/game pieces that successfully went in/increased score, not point value they bring to alliance
	only refers to points gained when defense is feasible (NO AUTO POINTS JUST TELEOP)
	
	Given parameters in calculateRank, rank how easy/hard it is to defend a team 
	 - based on team's counter defense (i.e. how many total balls they score with no/light/heavy defense.
    -> rank 1-10 (1: very good at counter-defending, not worth it to attempt to defend them, 10: defending them will significantly decrease their shooting, definitively go for it)
    -> while rank isn't subjective, the way people interpret a rank is. However, since scouting with a subjective no/light/heavy system, it's important to take actual experience and observations into consideration as well
	 */

  _AnalyzerState(String teamNum) {
    _teamNum = teamNum;
  }

  void initState() {
    super.initState();
    if (_teamNum.isEmpty) {
      return;
    }
    // setState(() {
    _hasAnalysis = TeamDataAnalyzer.getTeamDoc(_teamNum)['hasAnalysis'];
    // });
    if (!_hasAnalysis) {
      return;
    }
    Map<String, double> noD =
        TeamDataAnalyzer.getTeamTargetAverages(_teamNum, "None");
    Map<String, double> lightD =
        TeamDataAnalyzer.getTeamTargetAverages(_teamNum, "Light");
    Map<String, double> heavyD =
        TeamDataAnalyzer.getTeamTargetAverages(_teamNum, "Heavy");

    //initialize all vars
    double tempnoDGames = TeamDataAnalyzer.getTotalNoDGames(_teamNum, "None");
    double templightDGames =
        TeamDataAnalyzer.getTotalNoDGames(_teamNum, "Light");
    double tempheavyDGames =
        TeamDataAnalyzer.getTotalNoDGames(_teamNum, "Heavy");
    setState(() {
      _noDGames = tempnoDGames;
      _lightDGames = templightDGames;
      _heavyDGames = tempheavyDGames;
      _noDPts = noD["teleBallsLow"] +
          noD["teleBalls1"] +
          noD["teleBalls23"] +
          noD["teleBalls4"] +
          noD["teleBalls5"] +
          noD["teleBalls6"];

      _lightDPts = lightD["teleBallsLow"] +
          lightD["teleBalls1"] +
          lightD["teleBalls23"] +
          lightD["teleBalls4"] +
          lightD["teleBalls5"] +
          lightD["teleBalls6"];

      _heavyDPts = heavyD["teleBallsLow"] +
          heavyD["teleBalls1"] +
          heavyD["teleBalls23"] +
          heavyD["teleBalls4"] +
          heavyD["teleBalls5"] +
          heavyD["teleBalls6"];

      _zone0Pts =
          noD["teleBallsLow"] + lightD["teleBallsLow"] + heavyD["teleBallsLow"];
      _zone1Pts =
          noD["teleBalls1"] + lightD["teleBalls1"] + heavyD["teleBalls1"];
      _zone2and3Pts =
          noD["teleBalls23"] + lightD["teleBalls23"] + heavyD["teleBalls23"];
      _zone4Pts =
          noD["teleBalls4"] + lightD["teleBalls4"] + heavyD["teleBalls4"];
      _zone5Pts =
          noD["teleBalls5"] + lightD["teleBalls5"] + heavyD["teleBalls5"];
      _zone6Pts =
          noD["teleBalls6"] + lightD["teleBalls6"] + heavyD["teleBalls6"];
      _initialized = true;
    });
  }

  String getReport() {
    double rank = calculateRank();
    String optimalDefenseStrategy = calculateOptimalDefenseStrategy();
    String opponentOptimalShootingZone = calculateOptimalZone();

    return "Team: " +
        _teamNum +
        "\ncounter-defense rank (1 - 10): " +
        rank.toString() +
        "\nRecommended Defense Strategy on Team " +
        _teamNum +
        ": " +
        optimalDefenseStrategy +
        "\nTeam " +
        _teamNum +
        " optimal shooting zone: " +
        opponentOptimalShootingZone;
  }

  double calculateRank() {
    setState(() {
      _noPtAvg = _noDPts / _noDGames;
      _lightPtAvg = _lightDPts / _lightDGames;
      _heavyPtAvg = _heavyDPts / _heavyDGames;

      //defense is useless, rank = 1
      if (_noPtAvg < _lightPtAvg ||
          _noPtAvg < _heavyPtAvg ||
          _lightPtAvg < _heavyPtAvg) {
        _rank = 1;
        return 1;
      }

      //finds rank of light defense compared to no defense
      for (int i = 1; i < _highestRankPossible; i++) {
        if (_noPtAvg - _lightPtAvg > _ptRankDiff * i) {
          _noToLightRank++;
        }
      }

      //finds rank of heavy defense compared to light defense
      for (int i = 1; i < _highestRankPossible; i++) {
        if (_lightPtAvg - _heavyPtAvg > _ptRankDiff * i) {
          _lightToHeavyRank++;
        }
      }

      //finds rank average of no->light defense and light->heavy defense
      _rank = (_noToLightRank + _lightToHeavyRank) / 2.0;
    });

    return _rank;
  }

  //depending on the rank difference between no, light, and heavy defense, recommends an optimal defense
  //should not be taked too seriously if there aren't enough data points, too many outliers (ex: robot broke down), and this is all based on subjective scouting
  String calculateOptimalDefenseStrategy() {
    if (_rank == 1) {
      return "no defense";
    }
    if (_lightToHeavyRank > _noToLightRank) {
      return "heavy defense";
    }
    if (_lightToHeavyRank < _noToLightRank) {
      return "light defense";
    } else {
      return "";
    }
  }

  //key = teleop in zone x, value = balls scored in zone x, low zone = zone 0
  String calculateOptimalZone() {
    List<double> a = [
      _zone0Pts,
      _zone1Pts,
      _zone2and3Pts,
      _zone4Pts,
      _zone5Pts,
      _zone6Pts
    ];
    double temp;

    for (int i = 0; i < a.length; i++) {
      for (int j = i + 1; j < a.length; j++) {
        if (a[i] > a[j]) {
          temp = a[i];
          a[i] = a[j];
          a[j] = temp;
        }
      }
    }

    double largest = a[a.length - 1];
    if (largest == _zone0Pts) {
      return "zone 0";
    }
    if (largest == _zone1Pts) {
      return "zone 1";
    }
    if (largest == _zone2and3Pts) {
      return "zone 2 and 3";
    }
    if (largest == _zone4Pts) {
      return "zone 4";
    }
    if (largest == _zone5Pts) {
      return "zone 5";
    }
    if (largest == _zone6Pts) {
      return "zone 6";
    } else {
      return null;
    }
  }

  double calculateTotGames() {
    return _noDGames + _lightDGames + _heavyDGames;
  }

  double calculateTotPts() {
    return _noDPts + _lightDPts + _heavyDPts;
  }

  double calcuatePtAvg() {
    return calculateTotPts() / calculateTotGames();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasAnalysis) {
      return Text('No Analysis For This Team =(');
    } else if (_initialized) {
      return Text(this.getReport());
    } else if (_teamNum.isEmpty) {
      return Text('Error! No Team Number Entered');
    } else {
      return Text('Loading...');
    }
  }
}
*/
