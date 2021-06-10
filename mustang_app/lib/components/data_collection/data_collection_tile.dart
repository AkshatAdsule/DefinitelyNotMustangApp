import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mustang_app/pages/data-collection-analysis/view_histogram_screen.dart';
import 'package:mustang_app/utils/data_collection_data.dart';

class DataCollectionYearTile extends StatelessWidget {
  final DataCollectionYearData _yearData;

  DataCollectionYearTile(this._yearData);
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(_yearData.year.year.toString()),
      children: [
        Column(
          children: _yearData.avgData == null
              ? []
              : [
                  Text(
                      "Average pieces attempted: ${_yearData.avgData.gamePiecesAttempted.toStringAsFixed(3)}"),
                  Text(
                      "Average pieces scored: ${_yearData.avgData.gamePiecesScored.toStringAsFixed(3)}"),
                  Text(
                      "Average points scored: ${_yearData.avgData.pointsScored.toStringAsFixed(3)}"),
                  Text(
                    "Average point rate: ${_yearData.avgData.pointRate.toStringAsFixed(3)}",
                  ),
                  Text(
                      "Average accuracy: ${(_yearData.avgData.percentageScored * 100).toStringAsFixed(3)}%"),
                  Text(
                      "Average driver skill: ${_yearData.avgData.driverSkill.toStringAsFixed(3)}"),
                  Text(
                      "Average ranking points scored: ${_yearData.avgData.rankingPoints.toStringAsFixed(3)}"),
                  Text(
                      "Win rate: ${(_yearData.winRate * 100).toStringAsFixed(3)}%"),
                  ElevatedButton(
                    child: Text(
                      "View Overall Data",
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              View670HistogramScreen(_yearData),
                        ),
                      );
                    },
                  ),
                  for (DataCollectionMatchData matchData
                      in _yearData.data ?? "N/A")
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: ExpansionTile(
                        title: Text(matchData.matchName),
                        childrenPadding: EdgeInsets.only(bottom: 20),
                        children: matchData == null
                            ? null
                            : [
                                Text(
                                  "Pieces scored: ${matchData.gamePiecesScored}",
                                ),
                                Text(
                                  "Pieces attempted: ${matchData.gamePiecesAttempted}",
                                ),
                                Text(
                                    "Points scored: ${matchData.matchPoints.toStringAsFixed(3)}"),
                                Text(
                                    "Accuracy: ${(matchData.percentageScored * 100).toStringAsFixed(3)}%"),
                                Text(
                                  "Climbed: ${matchData.climbed}",
                                ),
                                Text(
                                  "Point Rate: ${matchData.pointRate.toStringAsFixed(3)}",
                                ),
                                Text(
                                  "Result: ${describeEnum(matchData.matchResult)}",
                                ),
                                Text(
                                  "Driver Rating: ${matchData.driverSkill}",
                                ),
                                Text(
                                  "Strategy used: ${describeEnum(matchData.strategy)}",
                                ),
                              ],
                      ),
                    )
                ],
        ),
      ],
    );
  }
}
