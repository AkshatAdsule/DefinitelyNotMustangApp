import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustang_app/constants/game_constants.dart';
import 'package:mustang_app/constants/robot_constants.dart';
import 'package:mustang_app/models/game_action.dart';
import 'package:mustang_app/models/match.dart';
import 'package:mustang_app/models/robot.dart';
import 'package:mustang_app/models/team.dart';
import 'package:mustang_app/services/team_service.dart';
import '../models/match.dart';

/*
really just a bunch of static methods that analyze data
take in data and spit out analyzed version
*/

class KeivnaAnalyzer {
  final List<ActionType> actionTypeArray = [ActionType.SHOT_LOW, ActionType.SHOT_OUTER, ActionType.SHOT_INNER];


  
  
  //ALL DATA DISPLAY: returns basic, unanalyzed data for given match
  static String getDataForAllMatches(List<Match> matches) {
    String result = "";
    for (int i = 0; i < matches.length; i++) {
      result += _getDataForMatch(matches[i]);
    }
    return result;
  }

  //used by getDataForAllMatches only, retunrs individual data for each match
  static String _getDataForMatch(Match match) {
    String result = "";

    //MATCH BASICS
    result += "Match Number: " + match.matchNumber.toString() + "\n";
    result += "Match Result: ";
    switch(match.matchResult){
      case MatchResult.WIN:
        result+= "Win\n";
        break;
      case MatchResult.TIE:
        result+= "Tie\n";
        break;
      case MatchResult.LOSE:
        result+= "Lose\n";
        break;
    }
    result += "Match Type: ";
    switch(match.matchType){
      case MatchType.QM:
        result+= "Qualifier\n";
        break;
      case MatchType.QF:
        result+= "Quarter Final\n";
        break;
      case MatchType.SF:
        result+= "SemiFinal\n";
        break;
      case MatchType.F:
        result+= "Final\n";
        break;
    }
    result += "Driver Skill: " + match.driverSkill.toString() + "/5\n";
    result += (match.notes.length > 0 ? "Match Notes: " + match.notes + "\n" : "No Match Notes\n" );

 
    //total points scored
    //total points prevented
    //if 0, don't print

    //AUTON: 
    //crossed init line
    result += "Crossed Init Line: " + _autonCrossedInitiationLine(match).toString() + "\n";
    //TODO: Make method calleg getACtionTypeArray instead of re-initiatlizing each time
    // List<ActionType> actionTypeArray = [ActionType.SHOT_LOW, ActionType.SHOT_OUTER, ActionType.SHOT_INNER];
    List<int> numAutonShots = _getAutonNumShots(match);
    for (int i = 0; i < numAutonShots.length; i++){
      String toAdd = getActionTypeList()[i].toString() + ": " + numAutonShots[i].toString() + "\n";
            result += toAdd;

    }
    // for (int index in numAutonShots){
    //   result += getActionTypeList()[index].toString() + ": " + numAutonShots[index].toString() + "\n";
    // }
    /*auton:
  num low shots made and missed:
  num outer shots made and missed:
  num inner shots made and missed:
  num intakes:
  */
    /*teleop:
  num low shots made and missed:
  num outer shots made and missed:
  num inner shots made and missed:
  num intakes:
  num shots prev:
  num intakes prev:
  num pushes:
  wheel rotation:
  wheel position:
  */
    /*endgame:
  num low shots made and missed:
  num outer shots made and missed:
  num inner shots made and missed:
  num intakes:
  num shots prev:
  num intakes prev:
  num pushes:
  wheel rotation:
  wheel position:
  parked:
  climbed:
  levelled:
  */
    /* all fouls
  */
    return result + "\n";
  }

  //WRITTEN ANALYSIS
static String getWrittenAnalysis(List<Match> matches){
//% time crossed initiation line
//avg auton shooting pts per game
//avg teleop shooting pts per game
//avg teleop pts prevented per game
//avg climb accuracy
//% of climbs that were levelled
//avg shot accuracy

}

static List<ActionType> getActionTypeList(){
    List<ActionType> actionTypeArray = [ActionType.SHOT_LOW, ActionType.SHOT_OUTER, ActionType.SHOT_INNER];

  return actionTypeArray;
}

//PRIVATE BACKHAND METHODS
static List<int> _getAutonNumShots(Match match){
  // List<int> numShotsPerAction = new List<int>(getActionTypeList().length);
  List<int> numShotsPerAction = List.filled(getActionTypeList().length, 0);


  for (GameAction currentAction in match.actions){
    //happened during auton
    if (currentAction.timeStamp <= GameConstants.autonMillisecondLength){
      //just until i get all actions in actionTYpeList
      if (getActionTypeList().contains(currentAction.actionType)){
        int index = getActionTypeList().indexOf(currentAction.actionType);
        numShotsPerAction[index] = numShotsPerAction[index] + 1;
      }
            
    }   
  }
return numShotsPerAction;
}

//returns true if crossed init line, otherwise false
static bool _autonCrossedInitiationLine(Match match){
  for (GameAction action in match.actions){
    if (action.actionType == ActionType.OTHER_CROSSED_INITIATION_LINE){
      return true;
    }
  }
  return false;
  }
}
