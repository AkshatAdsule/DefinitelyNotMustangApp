/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:mustang_app/utils/data_collection_data.dart';

enum DataType { ATTEMPTED, SCORED }

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
  static Map<DataType, List<charts.Series<HistogramStats, String>>> createData(DataCollectionYearData yearData) {
    List<HistogramStats> gamePiecesAttemptedData = [];
    List<HistogramStats> gamePiecesScoredData = [];
    List<DataCollectionMatchData> matches = yearData.data;

    int attemptedMin = 1000;
    int attemptedMax = 0;
    int scoredMin = 1000;
    int scoredMax = 0;
    for (DataCollectionMatchData matchData in matches) {
      print("Points scored: ${matchData.gamePiecesScored}");
      if (matchData.gamePiecesAttempted < attemptedMin) {
        attemptedMin = matchData.gamePiecesAttempted;
      } if (matchData.gamePiecesAttempted > attemptedMax) {
        attemptedMax = matchData.gamePiecesAttempted;
      }

      if (matchData.gamePiecesScored < scoredMin) {
        scoredMin = matchData.gamePiecesScored;
      } if (matchData.gamePiecesScored > scoredMax) {
        print("New max: ${matchData.gamePiecesScored}");
        scoredMax = matchData.gamePiecesScored;
      }
    }

    // var gamePiecesAttemptedFrequencies = [attemptedMax - attemptedMin];

    var gamePiecesAttemptedFrequencies =
        new List.filled(attemptedMax - attemptedMin + 1, 0, growable: false);
    print("Scored max: $scoredMax ");
    var gamePiecesScoredFrequencies =
        new List.filled(scoredMax - scoredMin + 1, 0, growable: false);
    for (DataCollectionMatchData matchData in matches) {
      print(matchData.gamePiecesAttempted - attemptedMin);
      gamePiecesAttemptedFrequencies[
          matchData.gamePiecesAttempted - attemptedMin] += 1;
      print("Value: ${scoredMin} out of ${gamePiecesScoredFrequencies.length}");
      gamePiecesScoredFrequencies[matchData.gamePiecesScored - scoredMin] += 1;
    }

    for (int i = 0; i < gamePiecesAttemptedFrequencies.length; i++) {
      int numOfGamePieces = i + attemptedMax;
      gamePiecesAttemptedData.add(new HistogramStats(
          numOfGamePieces.toString(), gamePiecesAttemptedFrequencies[i]));
    }

    for (int i = 0; i < gamePiecesScoredFrequencies.length; i++) {
      int numOfGamePieces = i + scoredMin;
      gamePiecesScoredData.add(new HistogramStats(
          numOfGamePieces.toString(), gamePiecesScoredFrequencies[i]));
    }

    return {
      DataType.ATTEMPTED: [
        new charts.Series<HistogramStats, String>(
          id: 'Attempted Game Pieces',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (HistogramStats stats, _) => stats.numOfGamePieces,
          measureFn: (HistogramStats stats, _) => stats.frequency,
          data: gamePiecesAttemptedData,
        ), 
      ], 
      DataType.SCORED: [
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
