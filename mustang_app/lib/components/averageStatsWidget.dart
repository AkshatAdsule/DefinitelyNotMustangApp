import 'package:flutter/material.dart';
import 'package:mustang_app/utils/TeamStatistic.dart';
import 'package:mustang_app/utils/classification.dart';

import 'LineChartWidget.dart';

/// Builds a new TeamStatisticWidget from a TeamStatistic object
@Deprecated('Use TeamStatsDisplay instead')
class AverageStatsWidget extends StatelessWidget {
  final TeamStatistic teamStatistic;
  AverageStatsWidget({this.teamStatistic});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: Colors.grey[400],
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(this.teamStatistic.teamCode),
                    ClassifierWidget(
                        classification:
                            ClassifierWidget.getClassification(teamStatistic))
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'OPR: ${this.teamStatistic.oprAverage.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.blue),
                    ),
                    Text(
                      'DPR: ${this.teamStatistic.dprAverage.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.red),
                    ),
                    Text(
                      'CCWM: ${this.teamStatistic.ccwmAverage.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.green),
                    ),
                    Text(
                        'Win Rate: ${this.teamStatistic.winRateAverage.toStringAsFixed(2)}'),
                    Text(
                      'Contribution Percentage: ${this.teamStatistic.pointContributionAvg.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.purple),
                    ),
                  ],
                )
              ],
            ),
            LineChartWidget(
              data: LineChartWidget.createTeamData(teamStatistic),
            )
          ],
        ),
      ),
    );
  }
}
