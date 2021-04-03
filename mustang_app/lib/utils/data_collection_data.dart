import 'package:mustang_app/constants/constants.dart';

class DataCollectionYearData {
  final int year;
  final List<DataCollectionEventData> matchData;

  DataCollectionYearData({this.year, this.matchData});
}

class DataCollectionEventData {
  String eventName;
  List<DataCollectionMatchData> data;
  DataCollectionMatchData avgData;
  int rankBeforeAllianceSelection;
  int endRank;
}

class DataCollectionMatchData {
  double dataVersion;
  String matchName;
  int gamePiecesAttempted;
  int gamePiecesScored;
  double percentageScored;
  bool climbed;
  Strategy strategy;
  int driverSkill;
  int rankingPoints;
  MatchResult matchResult;

  DataCollectionMatchData.fromRow(List<dynamic> row) {
    dataVersion = Constants.DATA_COLLECTION_DATA_VERSION;
    matchName = row[0];
    gamePiecesAttempted = row[1] as int;
    gamePiecesScored = row[2] as int;
    percentageScored = row[3] as double;

    if (row[4] == "Y") {
      climbed = true;
    } else {
      climbed = false;
    }

    if (row[5] == "Defense") {
      strategy = Strategy.Defensive;
    } else if (row[5] == "Offense") {
      strategy = Strategy.Offensive;
    } else {
      strategy = Strategy.Combo;
    }

    try {
      driverSkill = row[6] as int;
    } catch (e) {
      print("Invalid input, defaulting to 0 driver skill");
      driverSkill = 0;
    }

    rankingPoints = row[7] as int;

    if (row[9] == 'W') {
      matchResult = MatchResult.Win;
    } else if (row[9] == 'L') {
      matchResult = MatchResult.Lose;
    } else {
      matchResult = MatchResult.Tie;
    }
  }
}

enum Strategy { Offensive, Defensive, Combo }

enum MatchResult { Win, Tie, Lose }
