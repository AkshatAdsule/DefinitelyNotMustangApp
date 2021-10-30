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
  //NORMALIZING DATA:

  /*
  if blue alliance + driver station left side: shooting from bottom right
  if red alliance + driver station left side: shooting from bottom right

  if blue alliance + driver station right side: shooting from top left
  if red alliance + driver station right side: shooting from top left

  data needs to be "normalized" so all shots are from the BOTTOM RIGHT
  location of shots only changed if driver station was on right side
  
  WHY: *USED FOR MAP ANALYSIS ONLY*
  in map analysis, you see where all the shots were taken from
  if some are on the top left and other are on bottom right, hard to understand the map
  must "normalize" data so that all shots from the rop left are "transferred" to bottom right equivalent

  UNDERSTANDING OFFENSERIGHTSIDE:
  driver station right --> offenseOnRightSide is false
  driver station left --> offenseOnRightSide is true
  only need to normalize if offenseOnRightSide is false
  */
  static List<Match> _normalizeDataForMatches(List<Match> matches) {
    List<Match> normalizedMatchList = new List<Match>();
    for (Match match in matches) {
      Match normalizedMatch = _normalizeDataForMatch(match);
      normalizedMatchList.add(normalizedMatch);
    }
    return normalizedMatchList;
  }

  //does what's described above (for _normalizeDataForMatches)  but for a single match
  static Match _normalizeDataForMatch(Match match) {
    List<GameAction> normalizedGameActions = new List<GameAction>();
    //ie if shots are on top left side
    if (!match.offenseOnRightSide && match.offenseOnRightSide != null) {
      //starts at 0, 16 columns numbered from 0-15, same for rows
      int largestColumnNum = GameConstants.zoneColumns - 1; //15
      int largestRowNum = GameConstants.zoneRows - 1; //7

      for (GameAction gameAction in match.actions) {
        double newX = largestColumnNum - gameAction.x;
        double newY = largestRowNum - gameAction.y;
        GameAction normalizedGameAction = new GameAction(
            actionType: gameAction.actionType,
            timeStamp: gameAction.timeStamp,
            x: newX,
            y: newY);
        normalizedGameActions.add(normalizedGameAction);
      }

      Match normalizedMatch = new Match(
          matchNumber: match.matchNumber,
          teamNumber: match.teamNumber,
          allianceColor: match.allianceColor,
          offenseOnRightSide: match.offenseOnRightSide,
          matchResult: match.matchResult,
          notes: match.notes,
          driverSkill: match.driverSkill,
          actions: normalizedGameActions,
          matchType: match.matchType);
      return normalizedMatch;
    } else {
      //match does not need to be normalized
      return match;
    }
  }

  //MAP ANALYSIS:
  //returns a value from 0 - 900 rounded to nearest hunded, represents shade of green of that location
  //https://api.flutter.dev/flutter/material/Colors-class.html
  static int getShootingPointsColorValueAtLocation(List<Match> matches, int x,
      int y, ActionType selectedActionType, String selectedMatchNumber) {
    double avgShootingPointsAtLoc = 0;
    double maxPointsForZoneForMatch =
        1; //the value of the highest scoring zone in that match, will be the denom when determinign colorValue

    //getting shooting color for all matches, fill up avgShootingPointsAtLoc
    if (selectedMatchNumber.toLowerCase() == "all") {
      //use data that has been normalized
      List<Match> normalizedMatches = _normalizeDataForMatches(matches);
      double totalShootingPointsAtLoc = 0;
      double totalMaxPointsForZoneForAllMatches = 1;

      for (Match match in normalizedMatches) {
        totalShootingPointsAtLoc += _getShootingPointsAtLocationForSingleMatch(
            match, x, y, selectedActionType);
        totalMaxPointsForZoneForAllMatches +=
            _getMaxPointsForZoneInMatch(match, selectedActionType);
      }

      if (normalizedMatches.length > 0) {
        avgShootingPointsAtLoc =
            totalShootingPointsAtLoc / normalizedMatches.length;
        maxPointsForZoneForMatch =
            totalMaxPointsForZoneForAllMatches / normalizedMatches.length;
      }
    }

    //getting shooting color for j 1 match, fill up avgShootingPointsAtLoc
    else {
      Match normalizedMatch;
      //find the match and normalize it
      for (Match match in matches) {
        if (match.matchNumber == selectedMatchNumber) {
          normalizedMatch = _normalizeDataForMatch(match);
        }
      }

      avgShootingPointsAtLoc = _getShootingPointsAtLocationForSingleMatch(
          normalizedMatch, x, y, selectedActionType);
      maxPointsForZoneForMatch =
          _getMaxPointsForZoneInMatch(normalizedMatch, selectedActionType);
    }

    //color value depends on the max points scored in any zone, different for each match and team
    double colorValue =
        (avgShootingPointsAtLoc / maxPointsForZoneForMatch) * 900.0;

    //round to nearest hundred so that it returns a value that can be used for the color class
    //color class only takes values rounded to hundred
    int colorValueRoundedToHundred = ((colorValue + 50) ~/ 100) * 100;

    //should never happen bc maxPointsForZoneForMatch is always <= avgShootingPointsAtLoc but jic
    if (colorValueRoundedToHundred > 900) {
      return 900;
    }
    if (colorValueRoundedToHundred.isNaN) {
      debugPrint("color val rounded to 100 is NAN!!");
      return 0;
    }
    return colorValueRoundedToHundred;
  }

  static double _getMaxPointsForZoneInMatch(
      Match match, ActionType selectedActionType) {
    double maxValue = 1;

    //goes through each zone
    for (int x = 0; x < GameConstants.zoneColumns; x++) {
      for (int y = 0; y < GameConstants.zoneRows; y++) {
        double pointValueAtLoc = _getShootingPointsAtLocationForSingleMatch(
            match, x, y, selectedActionType);
        if (pointValueAtLoc > maxValue) {
          //NO KATIA IM NOT DOING THE "?" ONE I DONT LIKE IT
          maxValue = pointValueAtLoc;
        }
      }
    }
    return maxValue;
  }

//returns the total teleop and auton point value of all shots from location (x, y) for the given match
  static double _getShootingPointsAtLocationForSingleMatch(
      Match match, int x, int y, ActionType selectedActionType) {
    double result = 0;
    for (GameAction action in match.actions) {
      if (action.x == x && action.y == y) {
        //game action happened at given location
        //happpened during auton
        if (action.timeStamp <= GameConstants.autonMillisecondLength) {
          if (action.actionType == ActionType.SHOT_LOW &&
              (selectedActionType == ActionType.ALL ||
                  selectedActionType == ActionType.SHOT_LOW)) {
            result += GameConstants.lowShotAutonValue;
          }

          if (action.actionType == ActionType.SHOT_OUTER &&
              (selectedActionType == ActionType.ALL ||
                  selectedActionType == ActionType.SHOT_OUTER)) {
            result += GameConstants.outerShotAutonValue;
          }
          if (action.actionType == ActionType.SHOT_INNER &&
              (selectedActionType == ActionType.ALL ||
                  selectedActionType == ActionType.SHOT_INNER)) {
            result += GameConstants.innerShotAutonValue;
          }
        }

        //happpened during teleop
        if (action.timeStamp > GameConstants.autonMillisecondLength) {
          if (action.actionType == ActionType.SHOT_LOW &&
              (selectedActionType == ActionType.ALL ||
                  selectedActionType == ActionType.SHOT_LOW)) {
            result += GameConstants.lowShotValue;
          }

          if (action.actionType == ActionType.SHOT_OUTER &&
              (selectedActionType == ActionType.ALL ||
                  selectedActionType == ActionType.SHOT_OUTER)) {
            result += GameConstants.outerShotValue;
          }
          if (action.actionType == ActionType.SHOT_INNER &&
              (selectedActionType == ActionType.ALL ||
                  selectedActionType == ActionType.SHOT_INNER)) {
            result += GameConstants.innerShotValue;
          }
        }
      }
    }
    return result;
  }

  //returns the shade of green for given location (x, y) for the accuracy map
  //darker shade of green, higher shooting accuracy at that location
  static int getAccuracyColorValue(List<Match> matches, int x, int y,
      selectedActionType, String selectedMatchNumber) {
    List<Match> normalizedMatches = _normalizeDataForMatches(matches);

    //sum of all accuracies, will be way larger than 100 but then averaged later on
    double accuracyPerctentAtLoc = 0;

    if (selectedMatchNumber.toLowerCase() == "all") {
      double totalAccuracyPercentages = 0;
      for (Match match in normalizedMatches) {
        totalAccuracyPercentages += _geAccuracyPointsAtLocationForSingleMatch(
            match, x, y, selectedActionType);
      }
      if (matches.length > 0) {
        accuracyPerctentAtLoc =
            totalAccuracyPercentages / matches.length.toDouble();
      }
    } else {
      //only 1 match
      Match normalizedMatch;
      //find the match and normalize it
      for (Match match in matches) {
        if (match.matchNumber == selectedMatchNumber) {
          normalizedMatch = _normalizeDataForMatch(match);
        }
      }
      accuracyPerctentAtLoc = _geAccuracyPointsAtLocationForSingleMatch(
          normalizedMatch, x, y, selectedActionType);
    }

    //somewhere between 0-900, color value is simply the percent accuracy in a factor of 900
    double colorValue = accuracyPerctentAtLoc * 900;

    //round to nearest hundred so that it returns a value that can be used for the color class
    //color class only takes values rounded to hundred
    int colorValueRoundedToHundred = ((colorValue + 50) ~/ 100) * 100;
    if (colorValueRoundedToHundred > 900) {
      return 900;
    }
    return colorValueRoundedToHundred;
  }

  //returns the total teleop point value of all shots from location (x, y) for the given match
  static double _geAccuracyPointsAtLocationForSingleMatch(
      Match match, int x, int y, selectedActionType) {
    double shotsMade = 0;
    double shotsMissed = 0;
    for (GameAction action in match.actions) {
      if (action.x == x && action.y == y) {
        //all shots made

        if (action.actionType == ActionType.SHOT_LOW &&
            (selectedActionType == ActionType.ALL ||
                selectedActionType == ActionType.SHOT_LOW)) {
          shotsMade++;
        }
        if (action.actionType == ActionType.SHOT_OUTER &&
            (selectedActionType == ActionType.ALL ||
                selectedActionType == ActionType.SHOT_OUTER)) {
          shotsMade++;
        }
        if (action.actionType == ActionType.SHOT_INNER &&
            (selectedActionType == ActionType.ALL ||
                selectedActionType == ActionType.SHOT_INNER)) {
          shotsMade++;
        }

        //all shots missed
        if (action.actionType == ActionType.MISSED_LOW &&
            (selectedActionType == ActionType.ALL ||
                selectedActionType == ActionType.SHOT_LOW)) {
          shotsMissed++;
        }

        if (action.actionType == ActionType.MISSED_OUTER &&
            (selectedActionType == ActionType.ALL ||
                selectedActionType == ActionType.SHOT_OUTER)) {
          shotsMissed++;
        }
      }
    }
    if (shotsMade > 0) {
      //double from 1-100 of accuracy percentage

      double accuracyAsPercentage =
          (shotsMade / (shotsMade + shotsMissed)) * 100.0;
      // debugPrint("accuracyAsPercentage in single match method: " +
      //     accuracyAsPercentage.toString());
      return accuracyAsPercentage;
    }

    return 0;
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
