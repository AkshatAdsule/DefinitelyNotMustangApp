import 'package:flutter/material.dart';
import 'package:mustang_app/utils/data_collection_data.dart';

class DataCollectionYearTile extends StatelessWidget {
  final DataCollectionYearData _yearData;

  DataCollectionYearTile(this._yearData);
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(_yearData.year.toString()),
      children: [
        Column(
          children: _yearData.avgData == null
              ? []
              : [
                  Text(
                      "Average points scored: ${_yearData.avgData.gamePiecesScored ?? "N/A"}"),
                  Text(
                      "Average accuracy: ${_yearData.avgData.percentageScored ?? "N/A"}"),
                  Text("Win rate: ${_yearData.winRate ?? "N/A"}"),
                  for (DataCollectionMatchData matchData
                      in _yearData.data ?? "N/A")
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: ExpansionTile(
                        title: Text(matchData.matchName),
                        children: matchData == null
                            ? null
                            : [
                                Text(
                                    "Points scored: ${matchData.gamePiecesScored ?? "N/A"}"),
                                Text(
                                    "Accuracy: ${matchData.percentageScored ?? "N/A"}"),
                                Text(
                                    "Result: ${matchData.matchResult ?? "N/A"}"),
                                Text(
                                    "Driver Rating: ${matchData.driverSkill ?? "N/A"}")
                              ],
                      ),
                    )
                ],
        ),
      ],
    );
  }
}
