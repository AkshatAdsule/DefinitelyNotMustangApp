import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  final List<ActionType> actionTypeArray = [
    ActionType.SHOT_LOW,
    ActionType.SHOT_OUTER,
    ActionType.SHOT_INNER
  ];

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
    switch (match.matchResult) {
      case MatchResult.WIN:
        result += "Win\n";
        break;
      case MatchResult.TIE:
        result += "Tie\n";
        break;
      case MatchResult.LOSE:
        result += "Lose\n";
        break;
    }
    result += "Match Type: ";
    switch (match.matchType) {
      case MatchType.QM:
        result += "Qualifier\n";
        break;
      case MatchType.QF:
        result += "Quarter Final\n";
        break;
      case MatchType.SF:
        result += "SemiFinal\n";
        break;
      case MatchType.F:
        result += "Final\n";
        break;
    }
    //TODO: get driver skill fixed!
    // result += "Driver Skill: " + match.driverSkill.toString() + "/5\n";
    result += (match.notes.length > 0
        ? "Match Notes: " + match.notes + "\n"
        : "No Match Notes\n");

    //total points scored
    //total points prevented
    //if 0, don't print

    //AUTON:
    //crossed init line
    result += "Auton: \n";
    result += "Crossed Init Line: " +
        _autonCrossedInitiationLine(match).toString() +
        "\n";
    //prints all autonomous actions
    List<int> numAutonShots = _getAutonNumShots(match);
    for (int i = 0; i < numAutonShots.length; i++) {
      if (numAutonShots[i] > 0){
      result += getActionTypeList()[i].toString() +
          ": " +
          numAutonShots[i].toString() +
          "\n";
      }
    }

    //TELEOP:
    result += "Teleop: \n";
    List<int> numTeleopShots = _getTeleopNumShots(match);
    for (int i = 0; i < numTeleopShots.length; i++) {
      if (numTeleopShots[i] > 0){
      result += getActionTypeList()[i].toString() +
          ": " +
          numTeleopShots[i].toString() +
          "\n";
      }
    }
 
    /* all fouls
  */
    return result + "\n";
  }

  //WRITTEN ANALYSIS
  static String getWrittenAnalysis(List<Match> matches) {
    String result = "";
    result += "Shooting points/game: " + getAvgShootingPtsForAllMatches(matches).toString();
    return result;
//% time crossed initiation line
//avg auton shooting pts per game
//avg teleop shooting pts per game
//avg teleop pts prevented per game
//avg climb accuracy
//% of climbs that were levelled
//avg shot accuracy
  }

  /*
  used for organizing data when calling other methods that return a list of integers
  basically a skeleton for what the List<integers> represents
  ex: for getAutonNumShots(Match match) it returns a a List<int>. Could return <3, 1, 2> 
  means that during that match during auton, the robot scored 3 low shots (index 0), 1 outer shot (index 1) and 2 inner shots
  */
  static List<ActionType> getActionTypeList() {
    List<ActionType> actionTypeArray = [
      ActionType.SHOT_LOW,
      ActionType.SHOT_OUTER,
      ActionType.SHOT_INNER,
      ActionType.INTAKE,
      ActionType.MISSED_LOW,
      ActionType.MISSED_OUTER,
      ActionType.MISSED_INTAKE,
      ActionType.OTHER_WHEEL_ROTATION,
      ActionType.OTHER_WHEEL_POSITION,
      ActionType.PREV_SHOT,
      ActionType.PREV_INTAKE,
      ActionType.PUSH_START, //no need for push end bc for every push start, there is a push end
      ActionType.OTHER_PARKED,
      ActionType.OTHER_CLIMB,
      ActionType.OTHER_CLIMB_MISS,
      ActionType.OTHER_LEVELLED,
      //KTODO: FOULS AREN'T REGISTERING IN MATCH SCOUTING (AND ONLY 1 KIND OF FOUL)
      ActionType.FOUL_REG,
      ActionType.FOUL_TECH,
      ActionType.FOUL_YELLOW,
      ActionType.FOUL_RED,
      ActionType.FOUL_DISABLED,
      ActionType.FOUL_DISQUAL,
    ];
    return actionTypeArray;
  }

  static int getAvgShootingPtsForAllMatches(List<Match> matches){
    double result = 0;
    for (Match match in matches){
      result += getShootingAutonPtsForMatch(match);
      result += getShootingTeleopPtsForMatch(match);
    }
    return (result/matches.length.toDouble()).toInt();
  }

  static int getShootingTeleopPtsForMatch(Match match){
    List<int> numTeleopShots = _getTeleopNumShots(match);
    double result = 0;
    for (int i = 0; i < numTeleopShots.length; i++){
      ActionType action = getActionTypeList()[i];
      int occurence = numTeleopShots[i]; //how many types that action happened during the game
      switch (action){
        case (ActionType.SHOT_LOW):
          result += (GameConstants.lowShotValue*occurence);
          break;
        case (ActionType.SHOT_OUTER):
          result += (GameConstants.outerShotValue*occurence);
          break;
        case (ActionType.SHOT_INNER):
          result += (GameConstants.innerShotValue*occurence);
          break;
      }
    }
    return result.toInt();
  }


  static int getShootingAutonPtsForMatch(Match match){
    List<int> numAutonShots = _getAutonNumShots(match);
    double result = 0;
    for (int i = 0; i < numAutonShots.length; i++){
      ActionType gameAction = getActionTypeList()[i];
      int occurence = numAutonShots[i];
      switch (gameAction){
        case (ActionType.SHOT_LOW):
          result += (GameConstants.lowShotAutonValue*occurence);
          break;
        case (ActionType.SHOT_OUTER):
          result += (GameConstants.outerShotAutonValue*occurence);
          break;
        case (ActionType.SHOT_INNER):
          result += (GameConstants.innerShotAutonValue*occurence);
          break;
      }
    }
    return result.toInt();
  }

//PRIVATE BACKHAND METHODS
//returns number of shots for each time of action, sorted in a list in same order as getActionTypeList()
  static List<int> _getAutonNumShots(Match match) {
    List<int> numShotsPerAction = List.filled(getActionTypeList().length, 0);
    for (GameAction currentAction in match.actions) {
      //happened during auton
      if (currentAction.timeStamp <= GameConstants.autonMillisecondLength) {
        //just a safety precaution
        if (getActionTypeList().contains(currentAction.actionType)) {
          //adds 1 shot/miss to numShotsPerAction at corresponding action type
          int index = getActionTypeList().indexOf(currentAction.actionType);
          numShotsPerAction[index] = numShotsPerAction[index] + 1;
        }
      }
    }
    return numShotsPerAction;
  }

//returns number of shots for each time of action, sorted in a list in same order as getActionTypeList()
  static List<int> _getTeleopNumShots(Match match) {
    List<int> numShotsPerAction = List.filled(getActionTypeList().length, 0);
    for (GameAction currentAction in match.actions) {
      //happened during teleop
      if (currentAction.timeStamp > GameConstants.autonMillisecondLength) {
        //just a safety precaution
        if (getActionTypeList().contains(currentAction.actionType)) {
          //adds 1 shot/miss to numShotsPerAction at corresponding action type
          int index = getActionTypeList().indexOf(currentAction.actionType);
          numShotsPerAction[index] = numShotsPerAction[index] + 1;
        }
      }
    }
    return numShotsPerAction;
  }

//returns true if crossed init line, otherwise false
  static bool _autonCrossedInitiationLine(Match match) {
    for (GameAction action in match.actions) {
      if (action.actionType == ActionType.OTHER_CROSSED_INITIATION_LINE) {
        return true;
      }
    }
    return false;
  }
}
