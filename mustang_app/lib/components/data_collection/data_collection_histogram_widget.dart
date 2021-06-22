/// Bar chart example
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/utils/data_collection_data.dart';

import '../../utils/data_collection_data.dart';

enum GamePieceResult { ATTEMPTED, SCORED }

class DataCollectionHistogramWidget extends StatelessWidget {
  final List<BarChartGroupData> _data;

  const DataCollectionHistogramWidget(this._data);

  static Map<GamePieceResult, List<BarChartGroupData>> createData(
      DataCollectionYearData yearData) {
    List<DataCollectionMatchData> matches = yearData.data;
    List<BarChartGroupData> attemptedData = [];
    List<BarChartGroupData> scoredData = [];

    int attemptedMin = 1000;
    int attemptedMax = 0;
    int scoredMin = 1000;
    int scoredMax = 0;
    for (DataCollectionMatchData matchData in matches) {
      if (matchData.gamePiecesAttempted < attemptedMin) {
        attemptedMin = matchData.gamePiecesAttempted;
      }
      if (matchData.gamePiecesAttempted > attemptedMax) {
        attemptedMax = matchData.gamePiecesAttempted;
      }

      if (matchData.gamePiecesScored < scoredMin) {
        scoredMin = matchData.gamePiecesScored;
      }
      if (matchData.gamePiecesScored > scoredMax) {
        scoredMax = matchData.gamePiecesScored;
      }
    }

    List<int> gamePiecesAttemptedFrequencies;
    List<int> gamePiecesScoredFrequencies;
    int attemptedBinWidth;
    int scoredBinWidth;
    if (attemptedMax - attemptedMin + 1 <= 12) {
      gamePiecesAttemptedFrequencies =
          new List.filled(attemptedMax - attemptedMin + 1, 0, growable: false);
      attemptedBinWidth = 1;
    } else {
      gamePiecesAttemptedFrequencies = new List.filled(12, 0, growable: false);
      attemptedBinWidth = num.parse(
          (((attemptedMax - attemptedMin) / 12) + 0.5).toStringAsFixed(0));
    }

    if (scoredMax - scoredMin + 1 <= 12) {
      gamePiecesScoredFrequencies =
          new List.filled(scoredMax - scoredMin + 1, 0, growable: false);
      scoredBinWidth = 1;
    } else {
      gamePiecesScoredFrequencies = new List.filled(12, 0, growable: false);
      scoredBinWidth =
          num.parse((((scoredMax - scoredMin) / 12) + 0.5).toStringAsFixed(0));
    }

    for (DataCollectionMatchData matchData in matches) {
      gamePiecesAttemptedFrequencies[num.parse(
          ((matchData.gamePiecesAttempted - attemptedMin) / attemptedBinWidth)
              .toStringAsFixed(0))] += 1;
      gamePiecesScoredFrequencies[num.parse(
          ((matchData.gamePiecesScored - scoredMin) / scoredBinWidth)
              .toStringAsFixed(0))] += 1;
    }

    for (int i = 0; i < gamePiecesAttemptedFrequencies.length; i++) {
      int numOfGamePieces = i * attemptedBinWidth + attemptedMin;
      attemptedData.add(
        BarChartGroupData(
          x: numOfGamePieces,
          barRods: [
            BarChartRodData(
              y: gamePiecesAttemptedFrequencies[i].toDouble(),
              colors: [Colors.lightBlueAccent, Colors.greenAccent],
            ),
          ],
        ),
      );
      print("ga $numOfGamePieces, ${gamePiecesAttemptedFrequencies[i]}");
    }

    for (int i = 0; i < gamePiecesScoredFrequencies.length; i++) {
      int numOfGamePieces = i * scoredBinWidth + scoredMin;
      scoredData.add(
        BarChartGroupData(
          x: numOfGamePieces,
          barRods: [
            BarChartRodData(
                y: gamePiecesScoredFrequencies[i].toDouble(),
                colors: [Colors.redAccent, Colors.orangeAccent]),
          ],
        ),
      );
      print("gs $numOfGamePieces, ${gamePiecesScoredFrequencies[i]}");
    }

    return {
      GamePieceResult.ATTEMPTED: attemptedData,
      GamePieceResult.SCORED: scoredData
    };
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          enabled: false,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipPadding: const EdgeInsets.all(0),
            tooltipMargin: 8,
            getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
            ) {
              return BarTooltipItem(
                rod.y.round().toString(),
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            margin: 20,
          ),
          leftTitles: SideTitles(
            showTitles: true,
          ),
        ),
        barGroups: _data,
      ),
    );
  }
}

/// Sample ordinal data type.
class HistogramStats {
  final String numOfGamePieces;
  final int frequency;

  HistogramStats(this.numOfGamePieces, this.frequency);
}
