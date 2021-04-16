import 'package:mustang_app/constants/constants.dart';

class DataCollectionYearData {
  int year;
  List<DataCollectionMatchData> data;
  DataCollectionAverageYearData avgData;
  double winRate;
  int rankBeforeAllianceSelection;
  int endRank;

  DataCollectionYearData({
    this.year,
    this.data,
    this.rankBeforeAllianceSelection,
    this.endRank,
  }) {
    // Calculate win rate
    int winCount =
        data.where((element) => element.matchResult == MatchResult.Win).length;
    this.winRate = winCount / data.length;

    // Calculate avg data
    int totalGamePiecesAttempted = 0;
    int totalGamePiecesScored = 0;
    double totalPercentageScored = 0;
    int totalDriverSkill = 0;
    int totalRankingPoints = 0;
    for (DataCollectionMatchData match_data in data) {
      totalGamePiecesAttempted += match_data.gamePiecesAttempted;
      totalGamePiecesScored += match_data.gamePiecesScored;
      totalPercentageScored += match_data.percentageScored;
      totalDriverSkill += match_data.driverSkill;
      totalRankingPoints += match_data.rankingPoints;
    }
    int len = data.length;
    double avgGamePiecesAttempted = totalGamePiecesAttempted / len;
    double avgGamePiecesScored = totalGamePiecesScored / len;
    double avgPercentageScored = totalPercentageScored / len;
    double avgDriverSkill = totalDriverSkill / len;
    double avgRankingPoints = totalRankingPoints / len;

    this.avgData = new DataCollectionAverageYearData(
        gamePiecesAttempted: avgGamePiecesAttempted,
        gamePiecesScored: avgGamePiecesScored,
        percentageScored: avgPercentageScored,
        driverSkill: avgDriverSkill,
        rankingPoints: avgRankingPoints);
  }
}

class DataCollectionAverageYearData {
  double gamePiecesAttempted;
  double gamePiecesScored;
  double percentageScored;
  double driverSkill;
  double rankingPoints;

  DataCollectionAverageYearData({
    this.gamePiecesAttempted,
    this.gamePiecesScored,
    this.percentageScored,
    this.driverSkill,
    this.rankingPoints,
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

    // Check row[9] and row[10] due to inconsistency with data
    if (row[9] == 'W' || row[10] == 'W') {
      matchResult = MatchResult.Win;
    } else if (row[9] == 'L' || row[10] == 'L') {
      matchResult = MatchResult.Lose;
    } else if (row[9] == "T" || row[10] == 'T') {
      matchResult = MatchResult.Tie;
    } else {
      print("====== INVALID MATCH RESULT; ${row[9]} and ${row[10]}");
    }
  }
}

enum Strategy { Offensive, Defensive, Combo }

enum MatchResult { Win, Tie, Lose }
