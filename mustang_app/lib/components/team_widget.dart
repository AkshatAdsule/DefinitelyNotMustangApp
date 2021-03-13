import 'package:flutter/material.dart';
import 'package:mustang_app/components/overall_score_display.dart';
import 'package:mustang_app/utils/team_statistic.dart';
import 'package:mustang_app/utils/classification.dart';

class TeamWidget extends StatelessWidget {
  final TeamStatistic teamStatistic;
  final double maxScore;
  TeamWidget({this.teamStatistic, this.maxScore});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: Colors.grey[400],
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
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
            SizedBox(
              height: 7,
            ),
            OverAllScoreDisplay(
              score: OverAllScoreDisplay.calculateScore(teamStatistic),
              maxScore: maxScore,
            ),
          ],
        ),
      ),
    );
  }
}
