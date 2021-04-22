import 'package:flutter/foundation.dart';
import 'package:mustang_app/constants/constants.dart';

class DataCollectionYearData {
  int year;
  List<DataCollectionMatchData> data;
  DataCollectionAverageYearData avgData;
  double winRate;
  int rankBeforeAllianceSelection;
  int endRank;

  DataCollectionYearData({
    @required this.year,
    @required this.data,
    @required this.rankBeforeAllianceSelection,
    @required this.endRank,
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

    // Calculate avg points scored
    double pointsScored =
        Constants.GAME_PIECE_VALUE[year] * avgGamePiecesScored;

    this.avgData = new DataCollectionAverageYearData(
      gamePiecesAttempted: avgGamePiecesAttempted,
      gamePiecesScored: avgGamePiecesScored,
      percentageScored: avgPercentageScored,
      driverSkill: avgDriverSkill,
      rankingPoints: avgRankingPoints,
      pointsScored: pointsScored,
    );
  }
}

class DataCollectionAverageYearData {
  double gamePiecesAttempted;
  double gamePiecesScored;
  double percentageScored;
  double driverSkill;
  double rankingPoints;
  double pointsScored;

  DataCollectionAverageYearData({
    @required this.gamePiecesAttempted,
    @required this.gamePiecesScored,
    @required this.percentageScored,
    @required this.driverSkill,
    @required this.rankingPoints,
    @required this.pointsScored,
  });
}

class DataCollectionMatchData {
  double dataVersion;
  String matchName;
  int gamePiecesAttempted;
  int gamePiecesScored;
  double pointsScored;
  double percentageScored;
  bool climbed;
  Strategy strategy;
  int driverSkill;
  int rankingPoints;
  MatchResult matchResult;

  DataCollectionMatchData.fromRow(List<dynamic> row, int year) {
    int failCount = 0;

    dataVersion = Constants.DATA_COLLECTION_DATA_VERSION;
    matchName = row[0];
    try {
      gamePiecesAttempted = row[1];
    } catch (e) {
      print("Invalid input, defaulting to 0 game pieces attempted");
      gamePiecesAttempted = 0;
      failCount++;
    }

    try {
      gamePiecesScored = row[2];
    } catch (e) {
      print("Invalid input, defaulting to 0 game pieces scored");
      gamePiecesScored = 0;
      failCount++;
    }

    try {
      percentageScored = row[3] as double;
    } catch (e) {
      if (row[3] == 1) {
        percentageScored = 1;
      } else {
        percentageScored = 0;
        failCount++;
      }
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
      failCount++;
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
      failCount++;
    }

    try {
      rankingPoints = row[7];
    } catch (e) {
      print("Invalid input, defaulting to 0 ranking points");
      rankingPoints = 0;
      failCount++;
    }

    // Check row[9] and row[10] due to inconsistency with data
    if (row[9] == 'W' || row[10] == 'W') {
      matchResult = MatchResult.Win;
    } else if (row[9] == 'L' || row[10] == 'L') {
      matchResult = MatchResult.Lose;
    } else if (row[9] == "T" || row[10] == 'T') {
      matchResult = MatchResult.Tie;
    } else {
      print("====== INVALID MATCH RESULT; ${row[9]} and ${row[10]} ======");
      failCount++;
    }

    // Check if data is valid
    if (failCount >= Constants.DATA_VALIDITY_THRESHOLD) {
      throw Exception("Data is too invalid! Fail count is $failCount");
    }

    // Calculate points scored
    pointsScored = Constants.GAME_PIECE_VALUE[year] * gamePiecesScored;
  }
}

enum Strategy { Offensive, Defensive, Combo }

enum MatchResult { Win, Tie, Lose }
