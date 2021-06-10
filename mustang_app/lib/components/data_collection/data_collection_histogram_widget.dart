/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:mustang_app/utils/data_collection_data.dart';

import '../../utils/data_collection_data.dart';

enum GamePieceResult { ATTEMPTED, SCORED }

class DataCollectionHistogramWidget extends StatelessWidget {
  final List<charts.Series<HistogramStats, String>> data;
  final double height, width;

  DataCollectionHistogramWidget({this.data, this.height: 300, this.width: 500});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: new charts.BarChart(
          this.data,
          animate: true,
          behaviors: [
            new charts.ChartTitle('Number of Game Pieces',
                behaviorPosition: charts.BehaviorPosition.bottom,
                titleOutsideJustification:
                    charts.OutsideJustification.middleDrawArea),
            new charts.ChartTitle('Frequency',
                behaviorPosition: charts.BehaviorPosition.start,
                titleOutsideJustification:
                    charts.OutsideJustification.middleDrawArea),
            new charts.SeriesLegend(
              position: charts.BehaviorPosition.top,
              horizontalFirst: false,
              desiredMaxRows: 5,
              cellPadding: new EdgeInsets.only(right: 10.0, bottom: 5.0),
              entryTextStyle: charts.TextStyleSpec(fontSize: 10),
            )
          ],
        ),
      ),
    );
  }

  /// Create one series with sample hard coded data.
  static Map<GamePieceResult, List<charts.Series<HistogramStats, String>>>
      createData(DataCollectionYearData yearData) {
    List<HistogramStats> gamePiecesAttemptedData = [];
    List<HistogramStats> gamePiecesScoredData = [];
    List<DataCollectionMatchData> matches = yearData.data;

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

    var gamePiecesAttemptedFrequencies;
    var gamePiecesScoredFrequencies;
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
      gamePiecesAttemptedData.add(new HistogramStats(
          numOfGamePieces.toString(), gamePiecesAttemptedFrequencies[i]));
    }

    for (int i = 0; i < gamePiecesScoredFrequencies.length; i++) {
      int numOfGamePieces = i * scoredBinWidth + scoredMin;
      gamePiecesScoredData.add(new HistogramStats(
          numOfGamePieces.toString(), gamePiecesScoredFrequencies[i]));
    }

    return {
      GamePieceResult.ATTEMPTED: [
        new charts.Series<HistogramStats, String>(
          id: 'Attempted Game Pieces',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (HistogramStats stats, _) => stats.numOfGamePieces,
          measureFn: (HistogramStats stats, _) => stats.frequency,
          data: gamePiecesAttemptedData,
        ),
      ],
      GamePieceResult.SCORED: [
        new charts.Series<HistogramStats, String>(
          id: 'Scored Game Pieces',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (HistogramStats stats, _) => stats.numOfGamePieces,
          measureFn: (HistogramStats stats, _) => stats.frequency,
          data: gamePiecesScoredData,
        ),
      ]
    };
  }
}

/// Sample ordinal data type.
class HistogramStats {
  final String numOfGamePieces;
  final int frequency;

  HistogramStats(this.numOfGamePieces, this.frequency);
}
