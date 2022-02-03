import 'package:mustang_app/constants/game_constants.dart';
import 'package:mustang_app/models/game_action.dart';
import 'package:mustang_app/models/match.dart';
import '../models/match.dart';

/*
really just a bunch of static methods that analyze data
take in data and spit out analyzed version
FOR WRITTEN ANALYSIS AND ALL DATA DISPLAY
*/
/*
NOTE: when methods return a List<int>, represents how many time that action occured in a match
action can be found by looking at ActionType enum. For ex: _getAutonNumShots returns List<int> in form [3, 1, 2]
In ActionType enum, first 3 actions are SHOT_LOW, SHOT_OUTER, SHOT_INNER,
Therefore, for the given match (param in _getAutonNumShots), that means there were 3 low shots, 1 outer shots, and 2 inner shots
*/
class KeivnaDataAnalyzer {
  //ALL DATA DISPLAY: returns basic, unanalyzed data for all matches
  static String getDataForAllMatches(List<Match> matches) {
    String result = "";
    for (int i = 0; i < matches.length; i++) {
      result += _getDataForMatch(matches[i]);
    }
    return result;
  }

  //used by getDataForAllMatches only, returns individual data for each match
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
      default:
        result += "\n";
        break;
    }
    //TODO: get driver skill fixed!
    // result += "Driver Skill: " + match.driverSkill.toString() + "/5\n";
    result += (match.notes.length > 0
        ? "Match Notes: " + match.notes + "\n"
        : "No Match Notes\n");

    //total shooting points scored
    int totalShootingPtsScored = _getShootingAutonPtsForMatch(match) +
        _getShootingTeleopPtsForMatch(match);
    result += "Total Shooting Points Scored: " +
        totalShootingPtsScored.toString() +
        "\n";

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
      if (numAutonShots[i] > 0) {
        result += ActionType.values[i].toString() +
            ": " +
            numAutonShots[i].toString() +
            "\n";
      }
    }

    //TELEOP:
    result += "Teleop: \n";
    List<int> numTeleopShots = _getTeleopNumShots(match);
    for (int i = 0; i < numTeleopShots.length; i++) {
      if (numTeleopShots[i] > 0) {
        result += ActionType.values[i].toString() +
            ": " +
            numTeleopShots[i].toString() +
            "\n";
      }
    }

    //KTODO: add fouls - not registering in db for some reason
    return result + "\n";
  }

  //WRITTEN ANALYSIS
  //KTODO: j a draft, complete!
  static String getWrittenAnalysis(List<Match> matches) {
    String result = "";

    //if there are no matches to analyze, do not run the rest of the methods
    //if (matches.length == 0) {
    //  return "No matches to analyze!";
    //}

    result += "Shooting points/game: " +
        formatInteger(_getAvgShootingPtsForAllMatches(matches));
    result += "\n% crossed initiation line: " +
        formatInteger(_getPercentAutonCrossedInitiationLine(matches)) +
        "%";
    result += "\nAuton Shooting points/game: " +
        formatInteger(_getAvgAutonShootingPoints(matches));
    result += "\nTeleop Shooting points/game: " +
        formatInteger(_getAvgTeleopShootingPoints(matches));

    return result;
//% time crossed initiation line        DONE
//avg auton shooting pts per game       DONE
//avg teleop shooting pts per game      DONE
//avg teleop pts prevented per game
//avg climb accuracy
//% of climbs that were levelled
//avg shot accuracy
  }

  //PRIVATE BACKHAND METHODS

  //if an int is -1, it returns "N/A". Otherwise, it returns the int as a string
  static String formatInteger(int i) {
    if (i.isNaN || i.isInfinite || i == -1) {
      return "N/A";
    } else {
      return i.toString();
    }
  }

  //returns points scored by shooting on average for all matches, includes auton and teleop
  //returns -1 if there are no games to analyze
  static int _getAvgShootingPtsForAllMatches(List<Match> matches) {
    double result = 0;
    for (Match match in matches) {
      //goes thru each match
      result += _getShootingAutonPtsForMatch(match);
      result += _getShootingTeleopPtsForMatch(match);
    }

    //preventing exceptions if number of matches is 0
    double value = (result / matches.length.toDouble());
    if (value.isNaN || value.isInfinite) {
      return -1;
    } else {
      return (result / matches.length.toDouble()).toInt();
    }
  }

  //returns the number of times the bot crossed auton init line
  //returns -1 if there are no matches to analyze
  static int _getPercentAutonCrossedInitiationLine(List<Match> matches) {
    int crossedInitLine = 0;
    for (Match match in matches) {
      if (_autonCrossedInitiationLine(match)) {
        crossedInitLine++;
      }
    }
    if (matches.length == 0) {
      return -1;
    } else {
      return (crossedInitLine / matches.length.toDouble()).toInt();
    }
  }

  //returns the average auton shooting points/game
  //returns -1 if there are no matches to analyze
  static int _getAvgAutonShootingPoints(List<Match> matches) {
    double result = 0;
    for (Match match in matches) {
      //goes thru each match
      result += _getShootingAutonPtsForMatch(match);
    }

    //preventing exceptions if number of matches is 0
    double value = (result / matches.length.toDouble());
    if (value.isNaN || value.isInfinite) {
      return -1;
    } else {
      return (result / matches.length.toDouble()).toInt();
    }
  }

  //returns the average teleop shooting points/game
  //returns -1 if there are no matches to analyze
  static int _getAvgTeleopShootingPoints(List<Match> matches) {
    double result = 0;
    for (Match match in matches) {
      //goes thru each match
      result += _getShootingTeleopPtsForMatch(match);
    }

    //preventing exceptions if number of matches is 0
    double value = (result / matches.length.toDouble());
    if (value.isNaN || value.isInfinite) {
      return -1;
    } else {
      return (result / matches.length.toDouble()).toInt();
    }
  }

  //TODO: Shooting actions outdated
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
      }
    }
    return result.toInt();
  }

  //TODO: Shooting actions outdated
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
      }
    }
    return result.toInt();
  }

//returns number of shots for each time of action, sorted in a list in same order as getActionTypeList()
  static List<int> _getAutonNumShots(Match match) {
    List<int> numShotsPerAction = List.filled(ActionType.values.length, 0);
    for (GameAction currentAction in match.actions) {
      //happened during auton
      if (currentAction.timeStamp <= GameConstants.autonMillisecondLength) {
        //adds 1 shot/miss to numShotsPerAction at corresponding action type
        int index = ActionType.values.indexOf(currentAction.actionType);
        numShotsPerAction[index] = numShotsPerAction[index] + 1;
      }
    }
    return numShotsPerAction;
  }

//returns number of shots for each time of action, sorted in a list in same order as getActionTypeList()
  static List<int> _getTeleopNumShots(Match match) {
    List<int> numShotsPerAction = List.filled(ActionType.values.length, 0);
    for (GameAction currentAction in match.actions) {
      //happened during teleop
      if (currentAction.timeStamp > GameConstants.autonMillisecondLength) {
        //adds 1 shot/miss to numShotsPerAction at corresponding action type
        int index = ActionType.values.indexOf(currentAction.actionType);
        numShotsPerAction[index] = numShotsPerAction[index] + 1;
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
