import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mustang_app/constants/game_constants.dart';
import 'package:mustang_app/models/game_action.dart';
import 'package:mustang_app/models/match.dart';
import 'package:provider/provider.dart';
import '../models/match.dart';

/*
really just a bunch of static methods that analyze data
take in data and spit out analyzed version
*/
//FOR ALL MAPS: SCORING MAP, ACCURACY MAP, GAME REPLAY
class KeivnaMapAnalyzer {
  //MAP ANALYSIS:
  //returns a value from 0 - 900, represents shade of green of that location
  //https://api.flutter.dev/flutter/material/Colors-class.html
//KTODO: write on key that 150 is max
//NORMALIZE RIGHT SIDE OF DATA!!!
//shooting from top left (normalize): blue, right & red, right
//shooting from bottom right (don't normalize): blue, left & red, left
//KTODO: selected action type
//KTODO: teleop only rn, add in auton as well
  static int getShootingPointsColorValueAtLocation(List<Match> matches, int x, int y) {
    int result = 0;
    double totalShootingPointsAtLoc = 0;
    for (Match match in matches) {
      totalShootingPointsAtLoc += _getTeleopShootingPointsAtLocationForSingleMatch(match, x, y);
    }

    double avgShootingPointsAtLoc = totalShootingPointsAtLoc/matches.length;
        // debugPrint("average shooting points at location: " + avgShootingPointsAtLoc.toString());
    if (avgShootingPointsAtLoc > 0){
              debugPrint("average shooting points at: (" + x.toString() + ", " + y.toString() + "): " + avgShootingPointsAtLoc.toString());

    }
    double colorValue = (avgShootingPointsAtLoc/GameConstants.maxPtValuePerZonePerGame)*900.0;

    //temporary rounding
        if (colorValue > 0 && colorValue < 100){
      colorValue = 100;
    }
    if (colorValue > 0){
          debugPrint("scoring color value before round: " + colorValue.toString());

    }

    //STILL NEED TO ROUND TO NEAREST HUNDRED!!!
    
    //rounding colorValue to nearest hundred to be accepted as a color value
    // int roundedColorValue = colorValue.ceilToDouble().toInt();
    // int lowerBound = 0, upperBound = 0;
    // if (!colorValue.isNaN && colorValue.isFinite) {
    //   lowerBound = (colorValue ~/ 100) * 100; //lower bound of 100
    //   upperBound = (colorValue ~/ 100 + 1) * 100; //upper bound
    // }

    // int returnVal = (colorValue - lowerBound > upperBound - colorValue)
    //     ? upperBound
    //     : lowerBound;

    // if (roundedColorValue > 900) {
    //   return 900;
    // }
    // debugPrint("scoring color value: " + roundedColorValue.toString());
    // return roundedColorValue;
     if (colorValue > 900) {
      return 900;
    }
    return colorValue.toInt();
        // return 400;

  }

//returns the total point value of all shots from location (x, y) for the given match
  static double _getTeleopShootingPointsAtLocationForSingleMatch(Match match, int x, int y) {
    double result = 0;
    for (GameAction action in match.actions){
      if (action.x == x && action.y == y && action.timeStamp > GameConstants.autonMillisecondLength){
        debugPrint("ActionType: " + action.actionType.toString() + " at location: (" + x.toString() + ", " + y.toString() + "): ");
        switch (action.actionType){
          case(ActionType.SHOT_LOW):
            result+=GameConstants.lowShotValue;
            break;
          case(ActionType.SHOT_OUTER):
            result+=GameConstants.outerShotValue;
            break;
          case(ActionType.SHOT_INNER):
            result+=GameConstants.innerShotValue;
            break;
            default:
            break;
        }
      }
    }
    if (result > 0){
      debugPrint("teleop shooting points at (" + x.toString() + ", " + y.toString() + "): " + result.toString());
    }
    return result;
  }


  static int getAccuracyColorValue(ActionType actionType, int x, int y) {
    return 400;
    // double zoneAccuracyOutOf1 = myAnalyzer.calcShotAccuracyAtZone(
    //     actionType, x.toDouble(), y.toDouble());

    // double zoneAccuracyOutOf900 = zoneAccuracyOutOf1 * 900;
    // if (!zoneAccuracyOutOf900.isInfinite && !zoneAccuracyOutOf900.isNaN) {
    //   int a = (zoneAccuracyOutOf900 ~/ 100) * 100; //lower bound of 100
    //   int b = (zoneAccuracyOutOf900 ~/ 100 + 1) * 100; //upper bound
    //   int returnVal =
    //       (zoneAccuracyOutOf900 - a > b - zoneAccuracyOutOf900) ? b : a;
    //   debugPrint("accuracy color value: " + returnVal.toString());
    //   return returnVal;
    // } else {
    //   debugPrint("accuracy color value: 0");
    //   return 0;
    // }
  }

  //returns points scored by shooting on average for all matches, includes auton and teleop
  static int _getAvgShootingPtsForAllMatches(List<Match> matches) {
    double result = 0;
    for (Match match in matches) {
      //goes thru each match
      result += _getShootingAutonPtsForMatch(match);
      result += _getShootingTeleopPtsForMatch(match);
    }
    return (result / matches.length.toDouble()).toInt();
  }

  //returns points scored by shooting for the given match, only shots scored during teleop
  static int _getShootingTeleopPtsForMatch(Match match) {
    List<int> numTeleopShots = _getTeleopNumShots(match);
    double result = 0;
    for (int i = 0; i < numTeleopShots.length; i++) {
      ActionType action = ActionType.values[i];
      int occurence = numTeleopShots[
          i]; //how many types that action happened during the game
      switch (action) {
        case (ActionType.SHOT_LOW):
          result += (GameConstants.lowShotValue * occurence);
          break;
        case (ActionType.SHOT_OUTER):
          result += (GameConstants.outerShotValue * occurence);
          break;
        case (ActionType.SHOT_INNER):
          result += (GameConstants.innerShotValue * occurence);
          break;
        default:
          break;
      }
    }
    return result.toInt();
  }

  //returns points scored by shooting for the given match, only shots scored during auton
  //takes in double score value of shots during auton
  static int _getShootingAutonPtsForMatch(Match match) {
    List<int> numAutonShots = _getAutonNumShots(match);
    double result = 0;
    for (int i = 0; i < numAutonShots.length; i++) {
      ActionType gameAction = ActionType.values[i];
      int occurence = numAutonShots[i];
      switch (gameAction) {
        case (ActionType.SHOT_LOW):
          result += (GameConstants.lowShotAutonValue * occurence);
          break;
        case (ActionType.SHOT_OUTER):
          result += (GameConstants.outerShotAutonValue * occurence);
          break;
        case (ActionType.SHOT_INNER):
          result += (GameConstants.innerShotAutonValue * occurence);
          break;
        default:
          break;
      }
    }
    return result.toInt();
  }

//returns number of shots for each time of action, sorted in a list in same order as ActionType.values.
  static List<int> _getAutonNumShots(Match match) {
    List<int> numShotsPerAction = List.filled(ActionType.values.length, 0);
    for (GameAction currentAction in match.actions) {
      //happened during auton
      if (currentAction.timeStamp <= GameConstants.autonMillisecondLength) {
        //just a safety precaution
        if (ActionType.values.contains(currentAction.actionType)) {
          //adds 1 shot/miss to numShotsPerAction at corresponding action type
          int index = ActionType.values.indexOf(currentAction.actionType);
          numShotsPerAction[index] = numShotsPerAction[index] + 1;
        }
      }
    }
    return numShotsPerAction;
  }

//returns number of shots for each type of action, sorted in a list in same order as ActionType.values.
  static List<int> _getTeleopNumShots(Match match) {
    List<int> numShotsPerAction = List.filled(ActionType.values.length, 0);
    for (GameAction currentAction in match.actions) {
      //happened during teleop
      if (currentAction.timeStamp > GameConstants.autonMillisecondLength) {
        //just a safety precaution
        if (ActionType.values.contains(currentAction.actionType)) {
          //adds 1 shot/miss to numShotsPerAction at corresponding action type
          int index = ActionType.values.indexOf(currentAction.actionType);
          numShotsPerAction[index] = numShotsPerAction[index] + 1;
        }
      }
    }
    return numShotsPerAction;
  }

  //returns number of shots for each time of action, sorted in a list in same order as ActionType.values.
  static List<int> _getTeleopNumShotsAtLocation(Match match, int x, int y) {
    List<int> numShotsPerAction = List.filled(ActionType.values.length, 0);
    for (GameAction currentAction in match.actions) {
      //happened during teleop
      if (currentAction.timeStamp > GameConstants.autonMillisecondLength) {
        //just a safety precaution
        if (ActionType.values.contains(currentAction.actionType)) {
          //adds 1 shot/miss to numShotsPerAction at corresponding action type
          int index = ActionType.values.indexOf(currentAction.actionType);
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

  //Game Replay stuff
  static List<List<Object>> actionRelatedColors = [
    ["OTHER", Colors.orange],
    ["FOUL", Colors.yellow],
    ["PUSH", Colors.deepPurple],
    ["PREV", Colors.pink[200]],
    ["MISSED", Colors.red],
    ["INTAKE", Colors.blue],
    ["SHOT", Colors.green],
    ["LOW", Colors.white],
    ["OUTER", Colors.grey],
    ["INNER", Colors.black],
  ];

  //KTODO: move getColorCombo and other game replay method here
  static List<Color> getColorCombo(BuildContext context, String selectedMatch,
      double timeInGame, int x, int y) {
    GameAction curr;
    List<GameAction> currActions = getAllMatchActions(context, selectedMatch)
        .where((element) => element.timeStamp > timeInGame * 1000 - 5000)
        .where((element) => element.timeStamp < timeInGame * 1000 + 1000)
        .toList();
    for (GameAction currentAction in currActions) {
      if (currentAction.x == x && currentAction.y == y) {
        curr = currentAction;
        break;
      }
    }
    if (curr == null) return [Colors.green[0], Colors.yellow[0]];

    List<Color> gradientCombo = [];
    String actionType = curr.actionType.toString();

    for (List<Object> shade in actionRelatedColors)
      if (actionType.contains(shade[0])) gradientCombo.add(shade[1]);

    if (gradientCombo.length < 2) {
      if (actionType.contains("FOUL")) {
        gradientCombo.add(Colors.yellow[600]);
      } else if (actionType.contains("OTHER")) {
        gradientCombo.add(Colors.orange[600]);
      }
    }

    return gradientCombo;
  }

  static List<GameAction> getAllMatchActions(
      BuildContext context, String selectedMatch) {
    if (selectedMatch == "ALL") {
      return Provider.of<List<Match>>(context)
          .map((e) => e.actions)
          .reduce((value, element) => [...value, ...element]);
    }
    return Provider.of<List<Match>>(context)
        .where((element) => element.matchNumber == selectedMatch)
        .map((e) => e.actions)
        .reduce((value, element) => [...value, ...element]);
    // return selectedMatch == "ALL"
    //     ? Provider.of<List<Match>>(context)
    //         .map((e) => e.actions)
    //         .reduce((value, element) => [...value, ...element])
    //     : Provider.of<List<Match>>(context)
    //         .where((element) => element.matchNumber == selectedMatch)
    //         .map((e) => e.actions)
    //         .reduce((value, element) => [...value, ...element]);
  }
}
