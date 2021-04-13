import 'package:mustang_app/constants/constants.dart';

class DataCollectionYearData {
  int year;
  List<DataCollectionMatchData> data;
  DataCollectionMatchData avgData;
  int winRate;
  int rankBeforeAllianceSelection;
  int endRank;

  DataCollectionYearData({
    this.year,
    this.data,
    this.avgData,
    this.winRate,
    this.rankBeforeAllianceSelection,
    this.endRank,
  });
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
    try {
      gamePiecesAttempted = row[1];
    } catch (e) {
      print("Invalid input, defaulting to 0 game pieces attempted");
      gamePiecesAttempted = 0;
    }

    try {
      gamePiecesScored = row[2];
    } catch (e) {
      print("Invalid input, defaulting to 0 game pieces scored");
      gamePiecesScored = 0;
    }

    try {
      percentageScored = row[3] as double;
    } catch (e) {
      print("Invalid input, defaulting to 0% scored");
      percentageScored = 0;
    }
    
    try {
      if (row[4] == "Y") {
        climbed = true;
      } else {
        climbed = false;
      }
    } catch (e) {
      print("Invalid input, defaulting to no climb");
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
      driverSkill = row[6];
    } catch (e) {
      print("Invalid input, defaulting to 0 driver skill");
      driverSkill = 0;
    }

    try {
      rankingPoints = row[7];
    } catch (e) {
      print("Invalid input, defaulting to 0 ranking points");
      rankingPoints = 0;
    }

    if (row[9] == 'W') {
      matchResult = MatchResult.Win;
    } else if (row[9] == 'L') {
      matchResult = MatchResult.Lose;
    } else if (row[9] == "T") {
      matchResult = MatchResult.Tie;
    }
  }
}

enum Strategy { Offensive, Defensive, Combo }

enum MatchResult { Win, Tie, Lose }
