import 'package:flutter/material.dart';
import 'package:mustang_app/components/OverallScoreDisplay.dart';
import 'package:mustang_app/pages/pre-event-analysis/viewGraphScreen.dart';
import 'package:mustang_app/utils/TeamStatistic.dart';

class TeamStatsDisplay extends StatelessWidget {
  final TeamStatistic teamStatistic;
  final double score, max;

  TeamStatsDisplay({this.teamStatistic, this.score, this.max});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Team ${teamStatistic.teamCode.substring(3)}',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'OPR: ${teamStatistic.oprAverage.toStringAsFixed(2)}  ',
                  style: TextStyle(color: Colors.blue),
                ),
                Text(
                  'DPR: ${teamStatistic.dprAverage.toStringAsFixed(2)}  ',
                  style: TextStyle(color: Colors.red),
                ),
                Text(
                  'CCWM: ${teamStatistic.ccwmAverage.toStringAsFixed(2)}  ',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
            MaterialButton(
              child: Text('View graph'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewGraphScreen(teamStatistic),
                  ),
                );
              },
              color: Colors.grey[300],
            ),
            OverAllScoreDisplay(
              score: score,
              maxScore: max,
            )
          ],
        ),
      ),
    );
  }
}
